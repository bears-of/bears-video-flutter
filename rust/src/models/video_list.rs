use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[frb(json_serializable)]
pub struct VodListItem {
    pub type_id: i32,
    pub vod_id: i64,
    pub vod_name: String,
    pub vod_pic: String,
    pub vod_remarks: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[frb(json_serializable)]
pub struct VideoListRequest {
    pub pg: usize,
    pub tid: usize,
    pub class: String,
    pub area: String,
    pub lang: String,
    pub year: String,
    pub order: String,
    pub token: String,
}
