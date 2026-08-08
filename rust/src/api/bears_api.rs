use crate::{
    crypto::CryptoService,
    models::{
        base_response::BaseResponse,
        danmaku_item::DanmakuItem,
        episode::{parse_and_strip_play_sources, Episode},
        page_response::PageResponse,
        recommend_video::HomeRecommendData,
        search_result::{SearchRequest, SearchVodItem},
        video_detail::{BackendVideoDetail, FrontendVideoDetail},
        video_list::{VideoListRequest, VodListItem},
    },
};
use anyhow::{Context, Result};
use md5;
use reqwest::{
    self,
    header::{HeaderMap, HeaderName, HeaderValue, ACCEPT_ENCODING, CONTENT_TYPE, HOST, USER_AGENT},
    Client, IntoUrl,
};
use std::collections::HashMap;

const BASE_URL: &str = "http://110.42.3.76:37255/naiqiyi.php/v7/logs";
const BUILD_TIME: &str = "1784358145599";
const PK_ID: &str = "com.CDAStudio.ReinforcingBarAndroid.aqyc";
const SIGN_MD5: &str = "cfde20b83e3b9a845ad287bfcce65b19";
const APK_PATH: &str =
    "/data/app/~~j_lGiZAQYk3fPnH-NVSoMA==/com.CDAStudio.ReinforcingBarAndroid.aqyc-UuZtT8tyooeJzbP2SbLwCw==/base.apk";
const APK_LENGTH: i64 = 54591120;
const REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(20);

#[cfg(test)]
mod tests {
    use crate::{
        api::bears_api::ApiService,
        models::{search_result::SearchRequest, video_list::VideoListRequest},
    };

    #[tokio::test]
    async fn test_fetch_home_recommend() {
        let api_service = super::ApiService::new().unwrap();
        let result = api_service.fetch_home_recommend().await;
        match result {
            Ok(data) => {
                println!("Fetched home recommend data: {:?}", data);
            }
            Err(e) => {
                eprintln!("Error fetching home recommend data: {:?}", e);
            }
        }
    }

    #[tokio::test]
    async fn test_search() {
        let api_service = super::ApiService::new().unwrap();
        let keyword = "炽夏";
        let page = 1;
        let req = SearchRequest {
            pg: page,
            tid: None,
            text: keyword.into(),
            token: "".into(),
        };
        let result = api_service.search(req).await;
        match result {
            Ok(data) => {
                println!("Search results for '{}': {:?}", keyword, data);
            }
            Err(e) => {
                eprintln!("Error searching for '{}': {:?}", keyword, e);
            }
        }
    }

    #[tokio::test]
    async fn test_fetch_player_url_by_source_and_episode() -> anyhow::Result<()> {
        let video_id = 601173;
        let episode_index = 1; // 第一集

        let api = ApiService::new()?;
        let video_detail = api.fetch_video_detail(video_id).await?;
        println!("{}", video_detail.play_sources[1].name);
        let play_source = &video_detail.play_sources[1];
        let eposide = &play_source.episodes[episode_index];
        let parse_url = &play_source.parse_api;
        let video_url = format!("{}{}", parse_url, eposide.url);
        let eposide = api
            .fetch_specified_video_url(video_url, play_source.headers.clone())
            .await?;
        println!("{}", eposide);
        Ok(())
    }

    #[tokio::test]
    async fn test_fetch_video_list() {
        let api_service = super::ApiService::new().unwrap();
        let tid = 2; // Example type ID
        let page = 1;
        let req = VideoListRequest {
            tid: tid,
            pg: page,
            ..Default::default()
        };
        let result = api_service.fetch_video_list(req).await;
        match result {
            Ok(data) => {
                println!("Fetched video list for tid {}: {:?}", tid, data);
            }
            Err(e) => {
                eprintln!("Error fetching video list for tid {}: {:?}", tid, e);
            }
        }
    }

    #[tokio::test]
    async fn test_fetch_video_detail() {
        let api_service = super::ApiService::new().unwrap();
        let video_id = 601173; // Example video ID
        let result = api_service.fetch_video_detail(video_id).await;
        match result {
            Ok(data) => {
                println!("flutter_video_detail: {:?}", data);
            }
            Err(e) => {
                eprintln!(
                    "Error fetching video detail for video_id {}: {:?}",
                    video_id, e
                );
            }
        }
    }

    #[tokio::test]
    async fn test_fetch_danmaku_list() {
        let api_service = super::ApiService::new().unwrap();
        let group_key = "example_group_key"; // Replace with a valid group key
        let group_id: i64 = 0;
        let vod_id: i64 = 604369;
        let result = api_service
            .fetch_danmaku_list_by_ids(vod_id, group_id)
            .await;
        match result {
            Ok(data) => {
                println!(
                    "Fetched danmaku list for group_key {}: {:?}",
                    group_key, data
                );
            }
            Err(e) => {
                eprintln!(
                    "Error fetching danmaku list for group_key {}: {:?}",
                    group_key, e
                );
            }
        }
    }
}

// struct VideoService {
//     current_episode: Vec<>,
// }

pub struct ApiService {
    client: reqwest::Client,
    crypto: CryptoService,
}

impl ApiService {
    pub fn new() -> Result<Self> {
        let client = Client::builder()
            .connect_timeout(std::time::Duration::from_secs(10))
            .timeout(REQUEST_TIMEOUT)
            .build()?;
        Ok(Self {
            client,
            crypto: CryptoService::new(BUILD_TIME, PK_ID),
        })
    }

    async fn request<T: serde::Serialize, F: serde::de::DeserializeOwned>(
        &self,
        method: &str,
        data: T,
    ) -> Result<F> {
        let csrf = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)?
            .as_millis();

        let body = serde_json::json!({
            "method": method,
            "data": data,
            "csrf": csrf,
        });

        let body_str = body.to_string();
        let encrypted = self.crypto.encrypt(&body_str)?;

        let response = self
            .client
            .post(BASE_URL)
            .header(HOST, "110.42.3.76:37255")
            .header(USER_AGENT, "Dart/3.11 (dart:io)")
            .header(HeaderName::from_static("version"), "2.0.3")
            .header(ACCEPT_ENCODING, "gzip")
            .header(HeaderName::from_static("version-number"), "104")
            .header(HeaderName::from_static("pk-id"), PK_ID)
            .header(HeaderName::from_static("build-time"), BUILD_TIME)
            .header(HeaderName::from_static("platform"), "android")
            .header(
                HeaderName::from_static("platform-version"),
                "LE2110_14.0.0.1901(CN01)",
            )
            .header(CONTENT_TYPE, "text/plain")
            .body(encrypted)
            .send()
            .await
            .with_context(|| format!("请求主接口失败，method={method}"))?;

        let status = response.status();
        let response_body = response
            .text()
            .await
            .with_context(|| format!("读取主接口响应失败，method={method}"))?;

        if !status.is_success() {
            anyhow::bail!(
                "主接口返回 HTTP {}，method={}，响应: {}",
                status,
                method,
                response_preview(&response_body)
            );
        }

        let json_str = if response_body.is_empty() {
            "null".to_string()
        } else if response_body.contains(CryptoService::response_magic()) {
            self.crypto.decrypt_response(&response_body)?
        } else {
            response_body
        };

        // let serde_json_value = serde_json::from_str::<serde_json::Value>(&json_str)?;
        // println!("serde_json_value: {serde_json_value}");

        let result = serde_json::from_str::<F>(&json_str).with_context(|| {
            format!(
                "解析主接口响应失败，method={}，响应: {}",
                method,
                response_preview(&json_str)
            )
        })?;
        Ok(result)
    }

    async fn request_video(
        &self,
        video_url: impl IntoUrl,
        headers: &HashMap<String, String>,
    ) -> Result<String> {
        let video_url = video_url.into_url().context("解析接口 URL 无效")?;
        let request = self
            .client
            .get(video_url)
            .headers(to_header_map(headers)?)
            .timeout(REQUEST_TIMEOUT);

        let response = request.send().await.context("请求解析接口失败")?;
        let status = response.status();
        let content_type = response
            .headers()
            .get(reqwest::header::CONTENT_TYPE)
            .and_then(|value| value.to_str().ok())
            .unwrap_or("unknown")
            .to_string();
        let response_body = response.text().await.context("读取解析响应失败")?;

        if !status.is_success() {
            anyhow::bail!(
                "解析接口返回 HTTP {}，Content-Type: {}，响应: {}",
                status,
                content_type,
                response_preview(&response_body)
            );
        }

        let trimmed_body = response_body.trim();
        if trimmed_body.starts_with("http://") || trimmed_body.starts_with("https://") {
            return Ok(trimmed_body.to_string());
        }

        let response_json: serde_json::Value =
            serde_json::from_str(trimmed_body).with_context(|| {
                format!(
                    "解析响应 JSON 失败，Content-Type: {}，响应: {}",
                    content_type,
                    response_preview(trimmed_body)
                )
            })?;

        extract_url(&response_json).ok_or_else(|| {
            anyhow::anyhow!(
                "解析响应中未找到播放地址，响应: {}",
                response_preview(trimmed_body)
            )
        })
    }

    pub async fn fetch_specified_video_url(
        &self,
        resolve_url: String,
        headers: HashMap<String, String>,
    ) -> Result<String> {
        let video_url = self
            .request_video(resolve_url, &headers)
            .await
            .context("获取解析Url失败")?;
        Ok(video_url)
    }

    pub async fn fetch_home_recommend(&self) -> Result<HomeRecommendData> {
        let response = self
            .request::<serde_json::Value, BaseResponse<HomeRecommendData>>(
                "index_recommend",
                serde_json::json!({"token": ""}),
            )
            .await?;
        Ok(response.data)
    }

    pub async fn search(&self, req: SearchRequest) -> Result<Vec<SearchVodItem>> {
        let response = self
            .request::<SearchRequest, PageResponse<Vec<SearchVodItem>>>("search", req)
            .await?;
        Ok(response.data)
    }

    pub async fn fetch_video_list(&self, req: VideoListRequest) -> Result<Vec<VodListItem>> {
        let response = self
            .request::<VideoListRequest, PageResponse<Vec<VodListItem>>>("video_list", req)
            .await?;
        Ok(response.data)
    }

    pub async fn fetch_video_detail(&self, video_id: i32) -> Result<FrontendVideoDetail> {
        let mut response = self
            .request::<serde_json::Value, BaseResponse<BackendVideoDetail>>(
                "video_detail",
                serde_json::json!({
                    "id": video_id,
                    "sign_md5": SIGN_MD5,
                    "apk_path": APK_PATH,
                    "apk_length": APK_LENGTH,
                    "token": "",
                }),
            )
            .await?;
        let play_sources = parse_and_strip_play_sources(response.data.clone());
        response.data.vod_info.vod_url_with_player = None;
        Ok(FrontendVideoDetail {
            play_sources,
            video_info: response.data,
        })
    }

    #[allow(unused)]
    pub async fn fetch_danmaku_list(&self, group_key: &str) -> Result<Vec<DanmakuItem>> {
        let response = self
            .request::<serde_json::Value, BaseResponse<Vec<DanmakuItem>>>(
                "dm_list",
                serde_json::json!({
                    "group_key": group_key,
                    "token": "",
                }),
            )
            .await?;
        Ok(response.data)
    }

    pub async fn fetch_danmaku_list_by_ids(
        &self,
        vod_id: i64,
        current_episode: i64,
    ) -> Result<Vec<DanmakuItem>> {
        let group_key = make_group_key(vod_id, current_episode);
        self.fetch_danmaku_list(&group_key).await
    }

    pub async fn resolve_episode_url(&self, parse_api: &str, code: &str) -> Result<Option<String>> {
        let url = format!("{}{}", parse_api, code);
        let response = self
            .client
            .get(&url)
            .timeout(std::time::Duration::from_secs(15))
            .send()
            .await?;
        let response_body = response.text().await?;
        let data: serde_json::Value = serde_json::from_str(&response_body)?;
        Ok(extract_url(&data))
    }
}

fn make_group_key(vod_id: i64, current_episode: i64) -> String {
    let raw = format!("{}:{}", vod_id, current_episode);
    let digest = format!("{:x}", md5::compute(raw.as_bytes()));
    digest[12..].to_string()
}

fn response_preview(body: &str) -> String {
    const MAX_CHARS: usize = 200;
    let preview: String = body.chars().take(MAX_CHARS).collect();
    if body.chars().count() > MAX_CHARS {
        format!("{}...", preview)
    } else if preview.is_empty() {
        "<empty>".to_string()
    } else {
        preview
    }
}

fn to_header_map(header_values: &HashMap<String, String>) -> Result<HeaderMap> {
    let mut headers = HeaderMap::new();

    for (name, value) in header_values {
        let name = HeaderName::from_bytes(name.as_bytes())
            .with_context(|| format!("无效请求头名称: {name}"))?;
        let value =
            HeaderValue::from_str(value).with_context(|| format!("无效请求头内容: {value}"))?;
        headers.insert(name, value);
    }

    Ok(headers)
}

fn extract_url(data: &serde_json::Value) -> Option<String> {
    match data {
        serde_json::Value::String(s) if s.starts_with("http") => Some(s.clone()),
        serde_json::Value::String(s) => {
            if let Ok(parsed) = serde_json::from_str::<serde_json::Value>(s) {
                return extract_url(&parsed);
            }
            None
        }
        serde_json::Value::Object(map) => {
            for key in &["url", "link", "play_url", "video", "src"] {
                if let Some(serde_json::Value::String(s)) = map.get(*key) {
                    if s.starts_with("http") {
                        return Some(s.clone());
                    }
                }
            }
            for v in map.values() {
                if let Some(url) = extract_url(v) {
                    return Some(url);
                }
            }
            None
        }
        serde_json::Value::Array(arr) => {
            for item in arr {
                if let Some(url) = extract_url(item) {
                    return Some(url);
                }
            }
            None
        }
        _ => None,
    }
}

impl CryptoService {
    pub fn response_magic() -> &'static str {
        crate::crypto::RESPONSE_MAGIC
    }
}
