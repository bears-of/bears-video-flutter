use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

use crate::models::episode::PlaySource;

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[frb(json_serializable)]
pub struct BackendVideoDetail {
    pub comment_count: i32,
    pub is_collect: i32,
    // todo: use a more specific type for vod_history instead of serde_json::Value pub vod_history: Option<serde_json::Value>,
    pub vod_info: VodInfo,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[frb(json_serializable)]
pub struct VodInfo {
    pub group_id: i32,
    pub type_id: i32,
    pub type_id_1: i32,
    pub vod_id: i64,
    pub vod_name: String,
    pub vod_en: String,
    pub vod_sub: String,
    pub vod_actor: String,
    pub vod_director: String,
    pub vod_writer: String,
    pub vod_area: String,
    pub vod_lang: String,
    pub vod_year: String,
    pub vod_class: String,
    pub vod_pic: String,
    pub vod_pic_thumb: String,
    pub vod_pic_slide: String,
    pub vod_pic_screenshot: Option<String>,
    pub vod_blurb: String,
    pub vod_content: String,
    pub vod_remarks: String,
    pub vod_pubdate: String,
    pub vod_total: i32,
    pub vod_serial: String,
    pub vod_duration: String,
    pub vod_score: String,
    pub vod_score_all: i32,
    pub vod_score_num: i32,
    pub vod_douban_id: i64,
    pub vod_douban_score: String,
    pub vod_hits: i64,
    pub vod_hits_day: i64,
    pub vod_hits_week: i64,
    pub vod_hits_month: i64,
    pub vod_up: i64,
    pub vod_down: i64,
    pub vod_status: i32,
    pub vod_isend: i32,
    pub vod_lock: i32,
    pub vod_level: i32,
    pub vod_copyright: i32,
    pub vod_points: i32,
    pub vod_points_play: i32,
    pub vod_points_down: i32,
    pub vod_trysee: i32,
    pub vod_plot: i32,
    pub vod_plot_name: String,
    pub vod_plot_detail: String,
    pub vod_play_from: String,
    pub vod_play_server: String,
    pub vod_play_note: String,
    pub vod_play_url: String,
    pub vod_down_from: String,
    pub vod_down_server: String,
    pub vod_down_note: String,
    pub vod_down_url: String,
    pub vod_jumpurl: String,
    pub vod_pwd: String,
    pub vod_pwd_url: String,
    pub vod_pwd_play: String,
    pub vod_pwd_play_url: String,
    pub vod_pwd_down: String,
    pub vod_pwd_down_url: String,
    pub vod_rel_vod: String,
    pub vod_rel_art: String,
    pub vod_tag: String,
    pub vod_letter: String,
    pub vod_color: String,
    pub vod_author: String,
    pub vod_behind: String,
    pub vod_state: String,
    pub vod_version: String,
    pub vod_weekday: String,
    pub vod_tv: String,
    pub vod_tpl: String,
    pub vod_tpl_play: String,
    pub vod_tpl_down: String,
    pub vod_reurl: String,
    pub vod_time: i64,
    pub vod_time_add: i64,
    pub vod_time_hits: i64,
    pub vod_time_make: i64,
    pub vod_url_with_player: Option<Vec<VodPlayer>>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[frb(json_serializable)]
pub struct VodPlayer {
    pub code: String,
    pub name: String,
    pub url: String,
    pub headers: String,
    pub parse_api: String,
    pub extra_parse_api: String,
    pub parse_secret: bool,
    pub link_features: String,
    pub un_link_features: String,
    pub core_params: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct FrontendVideoDetail {
    pub play_sources: Vec<PlaySource>,
    pub video_info: BackendVideoDetail,
}
