use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct HomeRecommendData {
    pub banners: Vec<BannerItem>,
    pub videos: Vec<HomeVideoSection>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct BannerItem {
    pub id: i32,
    pub name: String,
    pub content: String,

    pub req_type: i32,
    pub req_content: String,

    pub real_package_id: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct HomeVideoSection {
    pub id: i32,
    pub name: String,
    pub type_id: i32,
    pub has_more: bool,
    pub more_req_type: i32,
    pub more_text: String,
    pub vlist: Vec<RecommendVodItem>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct RecommendVodItem {
    pub vod_id: i32,
    pub vod_name: String,
    pub vod_pic: String,
    pub vod_remarks: String,
    pub type_id: i32,
}
