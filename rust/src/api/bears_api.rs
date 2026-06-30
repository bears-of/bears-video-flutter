use crate::{crypto::CryptoService, models::recommend_video::{BaseResponse, HomeRecommendData}};
use anyhow::Result;
use md5;
use reqwest;

const BASE_URL: &str = "http://110.42.3.218:37256/naiqiyi.php/v7/logs";
const BUILD_TIME: &str = "1774333081066";
const PK_ID: &str = "com.CDAStudio.ReinforcingBarAndroid.aqya";
const SIGN_MD5: &str = "26059c965b457c38ea0b0f07a5a32c2d";
const APK_PATH: &str =
    "/data/app/com.CDAStudio.ReinforcingBarAndroid.aqya-ETaGpo5WPzI7Yy0RxlursQ==/base.apk";
const APK_LENGTH: i64 = 54322697;

pub struct ApiService {
    client: reqwest::Client,
    crypto: CryptoService,
}

impl ApiService {
    pub fn new() -> Self {
        Self {
            client: reqwest::Client::new(),
            crypto: CryptoService::new(BUILD_TIME, PK_ID),
        }
    }

    async fn request(&self, method: &str, data: serde_json::Value) -> Result<serde_json::Value> {
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
            .header("user-agent", "Dart/3.11 (dart:io)")
            .header("version", "2.0.1")
            .header("accept-encoding", "gzip")
            .header("host", "110.42.3.218:37256")
            .header("version-number", "101")
            .header("pk-id", PK_ID)
            .header("build-time", BUILD_TIME)
            .header("platform", "android")
            .header("platform-version", "PQ3B.190801.04221524 release-keys")
            .header("content-type", "text/plain")
            .body(encrypted)
            .send()
            .await?;

        let response_body = response.text().await?;

        if response_body.is_empty() {
            return Ok(serde_json::Value::Null);
        }

        if response_body.contains(CryptoService::response_magic()) {
            let decrypted = self.crypto.decrypt_response(&response_body)?;
            Ok(serde_json::from_str(&decrypted)?)
        } else {
            Ok(serde_json::from_str(&response_body)?)
        }
    }

    pub async fn fetch_home_recommend(&self) -> Result<HomeRecommendData> {
        let json_value = self.request("index_recommend", serde_json::json!({"token": ""}))
            .await?;
        let response = serde_json::from_value::<BaseResponse<HomeRecommendData>>(json_value)?;
        Ok(response.data)
    }

    pub async fn search(&self, keyword: &str, page: i32) -> Result<serde_json::Value> {
        self.request(
            "search",
            serde_json::json!({"pg": page, "text": keyword, "token": ""}),
        )
        .await
    }

    pub async fn fetch_video_list(&self, tid: i32, page: i32) -> Result<serde_json::Value> {
        self.request(
            "video_list",
            serde_json::json!({
                "pg": page,
                "tid": tid,
                "class": "",
                "area": "",
                "lang": "",
                "year": "",
                "order": "最新",
                "token": "",
            }),
        )
        .await
    }

    pub async fn fetch_video_detail(&self, video_id: i32) -> Result<serde_json::Value> {
        self.request(
            "video_detail",
            serde_json::json!({
                "id": video_id,
                "sign_md5": SIGN_MD5,
                "apk_path": APK_PATH,
                "apk_length": APK_LENGTH,
                "token": "",
            }),
        )
        .await
    }

    pub async fn fetch_danmaku_list(&self, group_key: &str) -> Result<serde_json::Value> {
        self.request(
            "dm_list",
            serde_json::json!({
                "group_key": group_key,
                "token": "",
            }),
        )
        .await
    }

    pub async fn fetch_danmaku_list_by_ids(
        &self,
        vod_id: i64,
        group_id: i64,
    ) -> Result<serde_json::Value> {
        let group_key = make_group_key(vod_id, group_id);
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

fn make_group_key(vod_id: i64, group_id: i64) -> String {
    let raw = format!("{}:{}", vod_id, group_id);
    let digest = format!("{:x}", md5::compute(raw.as_bytes()));
    digest[12..].to_string()
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
