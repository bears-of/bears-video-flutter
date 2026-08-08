use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(json_serializable)]
pub struct DanmakuItem {
    pub id: i32,
    pub user_id: i32,
    pub content: String,
    pub color: String,

    // 注意：接口返回的是字符串，比如 "1770.886"
    pub v_time: String,
}
