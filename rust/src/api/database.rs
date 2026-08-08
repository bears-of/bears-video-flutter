use anyhow::{anyhow, Context, Result};
use rusqlite::{params, Connection, OptionalExtension};
use std::{
    fs,
    path::PathBuf,
    sync::{OnceLock, RwLock},
    time::{SystemTime, UNIX_EPOCH},
};

static DATABASE_PATH: OnceLock<RwLock<Option<PathBuf>>> = OnceLock::new();

#[derive(Clone, Debug)]
pub struct FavoriteRecord {
    pub video_id: i64,
    pub video_title: String,
    pub video_poster: String,
    pub video_detail_json: String,
    pub created_at: i64,
}

#[derive(Clone, Debug)]
pub struct EpisodeHistoryRecord {
    pub video_id: i64,
    pub source_index: i32,
    pub episode_index: i32,
    pub watched_position_ms: i64,
    pub total_duration_ms: i64,
    pub video_title: String,
    pub video_poster: String,
    pub video_detail_json: String,
    pub source_name: String,
    pub episode_label: String,
    pub updated_at: i64,
}

#[derive(Clone, Debug)]
pub struct EpisodeDownloadRecord {
    pub video_id: i64,
    pub video_title: String,
    pub video_poster: String,
    pub video_detail_json: String,
    pub source_name: String,
    pub episode_index: i32,
    pub episode_label: String,
    pub remote_url: String,
    pub local_path: String,
    pub headers_json: String,
    pub downloaded_at: i64,
    pub file_size_bytes: i64,
}

pub fn initialize_database(directory: String) -> Result<()> {
    let directory = PathBuf::from(directory);
    fs::create_dir_all(&directory).context("failed to create database directory")?;
    let path = directory.join("bears_video.db");
    *database_path()
        .write()
        .map_err(|_| anyhow!("database path lock was poisoned"))? = Some(path);
    let connection = open_connection()?;
    create_schema(&connection)
}

pub fn search_history_get_recent(limit: i32) -> Result<Vec<String>> {
    let connection = open_connection()?;
    let mut statement = connection
        .prepare("SELECT keyword FROM search_history ORDER BY searched_at DESC LIMIT ?1")?;
    let rows = statement.query_map(params![limit.max(0)], |row| row.get(0))?;
    rows.collect::<rusqlite::Result<Vec<_>>>()
        .map_err(Into::into)
}

pub fn search_history_save(keyword: String) -> Result<()> {
    let keyword = keyword.trim();
    if keyword.is_empty() {
        return Ok(());
    }
    open_connection()?.execute(
        "INSERT INTO search_history (keyword, searched_at) VALUES (?1, ?2)
         ON CONFLICT(keyword) DO UPDATE SET searched_at = excluded.searched_at",
        params![keyword, now_ms()?],
    )?;
    Ok(())
}

pub fn search_history_clear() -> Result<()> {
    open_connection()?.execute("DELETE FROM search_history", [])?;
    Ok(())
}

pub fn favorite_is_saved(video_id: i64) -> Result<bool> {
    Ok(open_connection()?
        .query_row(
            "SELECT 1 FROM video_favorites WHERE video_id = ?1 LIMIT 1",
            params![video_id],
            |_| Ok(()),
        )
        .optional()?
        .is_some())
}

pub fn favorite_save(
    video_id: i64,
    video_title: String,
    video_poster: String,
    video_detail_json: String,
) -> Result<()> {
    open_connection()?.execute(
        "INSERT INTO video_favorites
         (video_id, video_title, video_poster, video_detail_json, created_at)
         VALUES (?1, ?2, ?3, ?4, ?5)
         ON CONFLICT(video_id) DO UPDATE SET
           video_title = excluded.video_title,
           video_poster = excluded.video_poster,
           video_detail_json = excluded.video_detail_json,
           created_at = excluded.created_at",
        params![
            video_id,
            video_title,
            video_poster,
            video_detail_json,
            now_ms()?
        ],
    )?;
    Ok(())
}

pub fn favorite_remove(video_id: i64) -> Result<()> {
    open_connection()?.execute(
        "DELETE FROM video_favorites WHERE video_id = ?1",
        params![video_id],
    )?;
    Ok(())
}

pub fn favorite_get_detail_json(video_id: i64) -> Result<Option<String>> {
    open_connection()?
        .query_row(
            "SELECT video_detail_json FROM video_favorites WHERE video_id = ?1 LIMIT 1",
            params![video_id],
            |row| row.get(0),
        )
        .optional()
        .map_err(Into::into)
}

pub fn favorite_get_all() -> Result<Vec<FavoriteRecord>> {
    let connection = open_connection()?;
    let mut statement = connection.prepare(
        "SELECT video_id, video_title, video_poster, video_detail_json, created_at
         FROM video_favorites ORDER BY created_at DESC",
    )?;
    let rows = statement.query_map([], favorite_from_row)?;
    rows.collect::<rusqlite::Result<Vec<_>>>()
        .map_err(Into::into)
}

pub fn episode_history_get(video_id: i64) -> Result<Option<EpisodeHistoryRecord>> {
    open_connection()?
        .query_row(
            &format!("{} WHERE video_id = ?1", episode_history_select()),
            params![video_id],
            episode_history_from_row,
        )
        .optional()
        .map_err(Into::into)
}

pub fn episode_history_get_all() -> Result<Vec<EpisodeHistoryRecord>> {
    let connection = open_connection()?;
    let mut statement = connection.prepare(&format!(
        "{} WHERE video_title != '' ORDER BY updated_at DESC",
        episode_history_select()
    ))?;
    let rows = statement.query_map([], episode_history_from_row)?;
    rows.collect::<rusqlite::Result<Vec<_>>>()
        .map_err(Into::into)
}

pub fn episode_history_save_selection(
    video_id: i64,
    source_index: i32,
    episode_index: i32,
) -> Result<()> {
    open_connection()?.execute(
        "INSERT INTO episode_history
         (video_id, source_index, episode_index, updated_at)
         VALUES (?1, ?2, ?3, ?4)
         ON CONFLICT(video_id) DO UPDATE SET
           watched_position_ms = CASE
             WHEN source_index != excluded.source_index OR episode_index != excluded.episode_index
             THEN 0 ELSE watched_position_ms END,
           total_duration_ms = CASE
             WHEN source_index != excluded.source_index OR episode_index != excluded.episode_index
             THEN 0 ELSE total_duration_ms END,
           source_index = excluded.source_index,
           episode_index = excluded.episode_index,
           updated_at = excluded.updated_at",
        params![video_id, source_index, episode_index, now_ms()?],
    )?;
    Ok(())
}

pub fn episode_history_save_progress(
    video_id: i64,
    source_index: i32,
    episode_index: i32,
    watched_position_ms: i64,
    total_duration_ms: i64,
) -> Result<()> {
    open_connection()?.execute(
        "INSERT INTO episode_history
         (video_id, source_index, episode_index, watched_position_ms, total_duration_ms, updated_at)
         VALUES (?1, ?2, ?3, ?4, ?5, ?6)
         ON CONFLICT(video_id) DO UPDATE SET
           watched_position_ms = excluded.watched_position_ms,
           total_duration_ms = excluded.total_duration_ms,
           updated_at = excluded.updated_at
         WHERE source_index = excluded.source_index AND episode_index = excluded.episode_index",
        params![
            video_id,
            source_index,
            episode_index,
            watched_position_ms,
            total_duration_ms,
            now_ms()?
        ],
    )?;
    Ok(())
}

#[allow(clippy::too_many_arguments)]
pub fn episode_history_save_metadata(
    video_id: i64,
    source_index: i32,
    episode_index: i32,
    video_title: String,
    video_poster: String,
    video_detail_json: String,
    source_name: String,
    episode_label: String,
) -> Result<()> {
    open_connection()?.execute(
        "INSERT INTO episode_history
         (video_id, source_index, episode_index, video_title, video_poster,
          video_detail_json, source_name, episode_label, updated_at)
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)
         ON CONFLICT(video_id) DO UPDATE SET
           watched_position_ms = CASE
             WHEN source_index != excluded.source_index OR episode_index != excluded.episode_index
             THEN 0 ELSE watched_position_ms END,
           total_duration_ms = CASE
             WHEN source_index != excluded.source_index OR episode_index != excluded.episode_index
             THEN 0 ELSE total_duration_ms END,
           source_index = excluded.source_index,
           episode_index = excluded.episode_index,
           video_title = excluded.video_title,
           video_poster = excluded.video_poster,
           video_detail_json = excluded.video_detail_json,
           source_name = excluded.source_name,
           episode_label = excluded.episode_label,
           updated_at = excluded.updated_at",
        params![
            video_id,
            source_index,
            episode_index,
            video_title,
            video_poster,
            video_detail_json,
            source_name,
            episode_label,
            now_ms()?
        ],
    )?;
    Ok(())
}

pub fn episode_history_clear() -> Result<()> {
    open_connection()?.execute("DELETE FROM episode_history", [])?;
    Ok(())
}

pub fn episode_download_get(
    video_id: i64,
    source_name: String,
    episode_index: i32,
) -> Result<Option<EpisodeDownloadRecord>> {
    open_connection()?
        .query_row(
            &format!(
                "{} WHERE video_id = ?1 AND source_name = ?2 AND episode_index = ?3 LIMIT 1",
                episode_download_select()
            ),
            params![video_id, source_name, episode_index],
            episode_download_from_row,
        )
        .optional()
        .map_err(Into::into)
}

pub fn episode_download_save(record: EpisodeDownloadRecord) -> Result<()> {
    open_connection()?.execute(
        "INSERT INTO episode_downloads
         (video_id, video_title, video_poster, video_detail_json, source_name,
          episode_index, episode_label, remote_url, local_path, headers_json,
          downloaded_at, file_size_bytes)
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12)
         ON CONFLICT(video_id, source_name, episode_index) DO UPDATE SET
           video_title = excluded.video_title,
           video_poster = excluded.video_poster,
           video_detail_json = excluded.video_detail_json,
           episode_label = excluded.episode_label,
           remote_url = excluded.remote_url,
           local_path = excluded.local_path,
           headers_json = excluded.headers_json,
           downloaded_at = excluded.downloaded_at,
           file_size_bytes = excluded.file_size_bytes",
        params![
            record.video_id,
            record.video_title,
            record.video_poster,
            record.video_detail_json,
            record.source_name,
            record.episode_index,
            record.episode_label,
            record.remote_url,
            record.local_path,
            record.headers_json,
            record.downloaded_at,
            record.file_size_bytes,
        ],
    )?;
    Ok(())
}

pub fn episode_download_delete(
    video_id: i64,
    source_name: String,
    episode_index: i32,
) -> Result<()> {
    open_connection()?.execute(
        "DELETE FROM episode_downloads
         WHERE video_id = ?1 AND source_name = ?2 AND episode_index = ?3",
        params![video_id, source_name, episode_index],
    )?;
    Ok(())
}

pub fn episode_download_get_for_video(video_id: i64) -> Result<Vec<EpisodeDownloadRecord>> {
    query_downloads(
        &format!(
            "{} WHERE video_id = ?1 ORDER BY episode_index ASC",
            episode_download_select()
        ),
        Some(video_id),
    )
}

pub fn episode_download_get_all() -> Result<Vec<EpisodeDownloadRecord>> {
    query_downloads(
        &format!("{} ORDER BY downloaded_at DESC", episode_download_select()),
        None,
    )
}

fn database_path() -> &'static RwLock<Option<PathBuf>> {
    DATABASE_PATH.get_or_init(|| RwLock::new(None))
}

fn open_connection() -> Result<Connection> {
    let path = database_path()
        .read()
        .map_err(|_| anyhow!("database path lock was poisoned"))?
        .clone()
        .ok_or_else(|| anyhow!("database has not been initialized"))?;
    let connection = Connection::open(path).context("failed to open database")?;
    connection.busy_timeout(std::time::Duration::from_secs(5))?;
    connection.pragma_update(None, "foreign_keys", "ON")?;
    Ok(connection)
}

fn create_schema(connection: &Connection) -> Result<()> {
    connection.execute_batch(
        "PRAGMA journal_mode = WAL;
         CREATE TABLE IF NOT EXISTS search_history (
           keyword TEXT PRIMARY KEY,
           searched_at INTEGER NOT NULL
         );
         CREATE TABLE IF NOT EXISTS video_favorites (
           video_id INTEGER PRIMARY KEY,
           video_title TEXT NOT NULL,
           video_poster TEXT NOT NULL DEFAULT '',
           video_detail_json TEXT NOT NULL,
           created_at INTEGER NOT NULL
         );
         CREATE TABLE IF NOT EXISTS episode_history (
           video_id INTEGER PRIMARY KEY,
           source_index INTEGER NOT NULL DEFAULT 0,
           episode_index INTEGER NOT NULL DEFAULT 0,
           watched_position_ms INTEGER NOT NULL DEFAULT 0,
           total_duration_ms INTEGER NOT NULL DEFAULT 0,
           video_title TEXT NOT NULL DEFAULT '',
           video_poster TEXT NOT NULL DEFAULT '',
           video_detail_json TEXT NOT NULL DEFAULT '',
           source_name TEXT NOT NULL DEFAULT '',
           episode_label TEXT NOT NULL DEFAULT '',
           updated_at INTEGER NOT NULL DEFAULT 0
         );
         CREATE TABLE IF NOT EXISTS episode_downloads (
           video_id INTEGER NOT NULL,
           video_title TEXT NOT NULL,
           video_poster TEXT NOT NULL DEFAULT '',
           video_detail_json TEXT NOT NULL DEFAULT '',
           source_name TEXT NOT NULL,
           episode_index INTEGER NOT NULL,
           episode_label TEXT NOT NULL,
           remote_url TEXT NOT NULL,
           local_path TEXT NOT NULL,
           headers_json TEXT NOT NULL,
           downloaded_at INTEGER NOT NULL,
           file_size_bytes INTEGER NOT NULL DEFAULT 0,
           PRIMARY KEY (video_id, source_name, episode_index)
         );",
    )?;
    Ok(())
}

fn now_ms() -> Result<i64> {
    Ok(SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .context("system clock is before Unix epoch")?
        .as_millis() as i64)
}

fn favorite_from_row(row: &rusqlite::Row<'_>) -> rusqlite::Result<FavoriteRecord> {
    Ok(FavoriteRecord {
        video_id: row.get(0)?,
        video_title: row.get(1)?,
        video_poster: row.get(2)?,
        video_detail_json: row.get(3)?,
        created_at: row.get(4)?,
    })
}

fn episode_history_select() -> &'static str {
    "SELECT video_id, source_index, episode_index, watched_position_ms,
     total_duration_ms, video_title, video_poster, video_detail_json,
     source_name, episode_label, updated_at FROM episode_history"
}

fn episode_history_from_row(row: &rusqlite::Row<'_>) -> rusqlite::Result<EpisodeHistoryRecord> {
    Ok(EpisodeHistoryRecord {
        video_id: row.get(0)?,
        source_index: row.get(1)?,
        episode_index: row.get(2)?,
        watched_position_ms: row.get(3)?,
        total_duration_ms: row.get(4)?,
        video_title: row.get(5)?,
        video_poster: row.get(6)?,
        video_detail_json: row.get(7)?,
        source_name: row.get(8)?,
        episode_label: row.get(9)?,
        updated_at: row.get(10)?,
    })
}

fn episode_download_select() -> &'static str {
    "SELECT video_id, video_title, video_poster, video_detail_json, source_name,
     episode_index, episode_label, remote_url, local_path, headers_json,
     downloaded_at, file_size_bytes FROM episode_downloads"
}

fn episode_download_from_row(row: &rusqlite::Row<'_>) -> rusqlite::Result<EpisodeDownloadRecord> {
    Ok(EpisodeDownloadRecord {
        video_id: row.get(0)?,
        video_title: row.get(1)?,
        video_poster: row.get(2)?,
        video_detail_json: row.get(3)?,
        source_name: row.get(4)?,
        episode_index: row.get(5)?,
        episode_label: row.get(6)?,
        remote_url: row.get(7)?,
        local_path: row.get(8)?,
        headers_json: row.get(9)?,
        downloaded_at: row.get(10)?,
        file_size_bytes: row.get(11)?,
    })
}

fn query_downloads(sql: &str, video_id: Option<i64>) -> Result<Vec<EpisodeDownloadRecord>> {
    let connection = open_connection()?;
    let mut statement = connection.prepare(sql)?;
    let rows = match video_id {
        Some(video_id) => statement.query_map(params![video_id], episode_download_from_row)?,
        None => statement.query_map([], episode_download_from_row)?,
    };
    rows.collect::<rusqlite::Result<Vec<_>>>()
        .map_err(Into::into)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn persists_application_data_and_resets_progress_on_episode_change() -> Result<()> {
        let directory = std::env::temp_dir().join(format!(
            "bears-video-database-test-{}-{}",
            std::process::id(),
            now_ms()?
        ));
        initialize_database(directory.to_string_lossy().into_owned())?;

        search_history_save(" first ".into())?;
        std::thread::sleep(std::time::Duration::from_millis(2));
        search_history_save("second".into())?;
        assert_eq!(search_history_get_recent(2)?, vec!["second", "first"]);

        favorite_save(7, "Title".into(), "poster".into(), "{}".into())?;
        assert!(favorite_is_saved(7)?);
        assert_eq!(favorite_get_all()?.len(), 1);

        episode_history_save_progress(7, 0, 1, 25_000, 50_000)?;
        let progress = episode_history_get(7)?.expect("history should exist");
        assert_eq!(progress.watched_position_ms, 25_000);
        episode_history_save_selection(7, 0, 2)?;
        let changed = episode_history_get(7)?.expect("history should exist");
        assert_eq!(changed.watched_position_ms, 0);
        assert_eq!(changed.total_duration_ms, 0);

        let download = EpisodeDownloadRecord {
            video_id: 7,
            video_title: "Title".into(),
            video_poster: String::new(),
            video_detail_json: "{}".into(),
            source_name: "source".into(),
            episode_index: 2,
            episode_label: "Episode 3".into(),
            remote_url: "https://example.com/video.mp4".into(),
            local_path: "video.mp4".into(),
            headers_json: "{}".into(),
            downloaded_at: now_ms()?,
            file_size_bytes: 1024,
        };
        episode_download_save(download)?;
        assert!(episode_download_get(7, "source".into(), 2)?.is_some());

        fs::remove_dir_all(directory)?;
        Ok(())
    }
}
