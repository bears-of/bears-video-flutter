use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct SearchVodItem {
    pub type_id: i32,
    pub vod_id: i64,
    pub vod_name: String,
    pub vod_actor: String,
    pub vod_area: String,
    pub vod_lang: String,
    pub vod_pic: String,
    pub vod_remarks: String,
    pub vod_year: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct SearchRequest {
    pub pg: usize,
    pub tid: Option<usize>,
    pub text: String,
    pub token: String,
}
