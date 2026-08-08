use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[frb(json_serializable)]
pub struct PageResponse<T> {
    pub code: i32,
    pub msg: String,
    pub data: T,
    pub limit: i32,
    pub page: i32,
    pub pagecount: i32,
    pub total: i32,
}
