use anyhow::{anyhow, Context, Result};
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ParseVideoResult {
    pub url: String,
    pub media_type: String,
}

pub fn parse_video_url(json_text: &str) -> Result<ParseVideoResult> {
    let value: Value = serde_json::from_str(json_text).context("JSON解析失败")?;

    // 判断 code 是否为 200
    let code_ok = value
        .get("code")
        .and_then(|v| v.as_i64())
        .map(|code| code == 200)
        .unwrap_or(true);

    // 判断 success 是否为 1
    let success_ok = value
        .get("success")
        .and_then(|v| v.as_i64())
        .map(|success| success == 1)
        .unwrap_or(true);

    if !code_ok || !success_ok {
        let msg = value
            .get("msg")
            .and_then(|v| v.as_str())
            .unwrap_or("接口返回失败");

        return Err(anyhow!(msg.to_string()));
    }

    // 提取 url
    let url = value
        .get("url")
        .and_then(|v| v.as_str())
        .ok_or_else(|| anyhow!("未找到 url 字段"))?
        .trim()
        .to_string();

    // 提取 type
    let media_type = value
        .get("type")
        .and_then(|v| v.as_str())
        .unwrap_or("unknown")
        .to_string();

    Ok(ParseVideoResult { url, media_type })
}
