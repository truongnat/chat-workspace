use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize)]
pub struct WebRtcSignal {
    pub type_: String, // "offer", "answer", "candidate", "bye"
    pub sdp: Option<String>,
    pub candidate: Option<String>,
    pub sdp_mid: Option<String>,
    pub sdp_m_line_index: Option<i32>,
    pub target_user_id: Uuid,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CallRequest {
    pub target_user_id: Uuid,
    pub offer: String, // SDP
    pub is_video: bool,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CallResponse {
    pub caller_id: Uuid,
    pub answer: String, // SDP
}

#[derive(Debug, Serialize, Deserialize)]
pub struct IceCandidate {
    pub target_user_id: Uuid,
    pub candidate: String,
    pub sdp_mid: Option<String>,
    pub sdp_m_line_index: Option<i32>,
}
