use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct BaseResponse<T> {
    pub code: i32,
    pub msg: String,
    pub data: T,
}
