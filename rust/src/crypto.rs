use aes::Aes128;
use base64::{engine::general_purpose::URL_SAFE_NO_PAD, Engine as _};
use cbc::cipher::{block_padding::Pkcs7, BlockDecryptMut, BlockEncryptMut, KeyIvInit};
use md5;
use rand::RngExt;
use regex::Regex;
use anyhow::{Result, anyhow};

type Aes128CbcEnc = cbc::Encryptor<Aes128>;
type Aes128CbcDec = cbc::Decryptor<Aes128>;

pub const RESPONSE_MAGIC: &str = "eGRkYXBwc2VjcmV0a2V5";
const MAGIC: &str = "^~!@#[-";

pub struct CryptoService {
    pub build_time: String,
    pub pk_id: String,
}

impl CryptoService {
    pub fn new(build_time: &str, pk_id: &str) -> Self {
        Self {
            build_time: build_time.to_string(),
            pk_id: pk_id.to_string(),
        }
    }

    fn derive_request_key(&self) -> [u8; 16] {
        let seed = format!("{}{}{}", self.build_time, MAGIC, self.pk_id);
        md5::compute(seed.as_bytes()).into()
    }

    pub fn encrypt(&self, plaintext: &str) -> Result<String> {
        let key = self.derive_request_key();
        let mut iv = [0u8; 16];
        rand::rng().fill(&mut iv);

        let data = plaintext.as_bytes();
        let mut buf = vec![0u8; data.len() + 16];
        buf[..data.len()].copy_from_slice(data);

        let ciphertext = Aes128CbcEnc::new(&key.into(), &iv.into())
            .encrypt_padded_mut::<Pkcs7>(&mut buf, data.len())
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let mut combined = Vec::with_capacity(16 + ciphertext.len());
        combined.extend_from_slice(&iv);
        combined.extend_from_slice(ciphertext);

        Ok(URL_SAFE_NO_PAD.encode(&combined))
    }

    pub fn decrypt_response(&self, response_text: &str) -> Result<String> {
        let magic_pos = response_text
            .rfind(RESPONSE_MAGIC)
            .ok_or("MAGIC not found in response").map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let suffix_text = &response_text[magic_pos + RESPONSE_MAGIC.len()..];
        let suffix_raw = String::from_utf8(
            base64::engine::general_purpose::STANDARD.decode(auto_pad(suffix_text))?,
        )?;
        let suffix: usize = Regex::new(r"\d+")
            .unwrap()
            .find(&suffix_raw)
            .and_then(|m| m.as_str().parse().ok())
            .unwrap_or(0);

        let encrypted = &response_text[..magic_pos];
        let prefix_b64 = &encrypted[..suffix];
        let body_b64 = &encrypted[suffix..];

        let restored = restore(prefix_b64)?;
        let body = base64::engine::general_purpose::STANDARD.decode(auto_pad(body_b64))?;

        let mut combined = Vec::with_capacity(restored.len() + body.len());
        combined.extend_from_slice(&restored);
        combined.extend_from_slice(&body);

        if combined.len() < 32 || combined.len() % 16 != 0 {
            return Result::Err(anyhow::anyhow!("Bad AES payload length"));
        }

        let iv: [u8; 16] = combined[..16]
            .try_into()
            .map_err(|_| anyhow!("invalid AES IV length"))?;
        let ct = &combined[16..];
        let key = self.derive_request_key();

        let mut buf = ct.to_vec();
        let pt = Aes128CbcDec::new(&key.into(), &iv.into())
            .decrypt_padded_mut::<Pkcs7>(&mut buf)
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(String::from_utf8(pt.to_vec())?)
    }
}

fn restore(prefix_b64: &str) -> Result<Vec<u8>> {
    let text =
        String::from_utf8(base64::engine::general_purpose::STANDARD.decode(auto_pad(prefix_b64))?)?;

    let mut nums = Vec::new();
    for part in text.split("0x") {
        if part.is_empty() {
            continue;
        }
        if let Some(digits) = Regex::new(r"^\d+").unwrap().find(part) {
            if let Ok(n) = digits.as_str().parse::<i32>() {
                nums.push(n);
            }
        }
    }

    nums.reverse();

    let mut out = Vec::with_capacity(nums.len());
    for (i, &v) in nums.iter().enumerate() {
        let b = if i % 2 == 0 {
            v - 11
        } else if i % 3 == 0 {
            v - 4
        } else if i % 5 == 0 {
            v - 2
        } else {
            v - 3
        };
        out.push((b & 0xFF) as u8);
    }

    Ok(out)
}

fn auto_pad(s: &str) -> String {
    let s = s.trim();
    let pad_len = (4 - s.len() % 4) % 4;
    format!("{}{}", s, "=".repeat(pad_len))
}
