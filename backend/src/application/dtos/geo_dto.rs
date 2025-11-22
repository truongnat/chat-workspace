use serde::{Deserialize, Serialize};
use uuid::Uuid;
use validator::Validate;

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct UpdateLocationRequest {
    #[validate(range(min = -90.0, max = 90.0))]
    pub latitude: f64,
    
    #[validate(range(min = -180.0, max = 180.0))]
    pub longitude: f64,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct FindNearbyRequest {
    #[validate(range(min = -90.0, max = 90.0))]
    pub latitude: f64,
    
    #[validate(range(min = -180.0, max = 180.0))]
    pub longitude: f64,
    
    #[validate(range(min = 0.1, max = 1000.0))]
    pub radius_km: f64,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UserLocationResponse {
    pub user_id: Uuid,
    pub name: String,
    pub username: String,
    pub avatar_url: Option<String>,
    pub latitude: f64,
    pub longitude: f64,
    pub distance_km: Option<f64>, // Calculated distance
}
