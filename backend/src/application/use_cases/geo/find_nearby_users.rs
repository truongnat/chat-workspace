use std::sync::Arc;

use crate::domain::{
    repositories::UserRepository,
    DomainResult,
};
use crate::application::UserLocationResponse;

pub struct FindNearbyUsers {
    user_repo: Arc<dyn UserRepository>,
}

impl FindNearbyUsers {
    pub fn new(user_repo: Arc<dyn UserRepository>) -> Self {
        Self { user_repo }
    }

    pub async fn execute(&self, latitude: f64, longitude: f64, radius_km: f64) -> DomainResult<Vec<UserLocationResponse>> {
        let users = self.user_repo.find_nearby(latitude, longitude, radius_km).await?;

        // Convert to DTO
        Ok(users
            .into_iter()
            .filter_map(|u| {
                if let Some((lat, lon)) = u.location {
                    // Calculate rough distance (optional, or let frontend do it)
                    // For now just return the data
                    Some(UserLocationResponse {
                        user_id: u.id,
                        name: u.name,
                        username: u.username,
                        avatar_url: u.avatar_url,
                        latitude: lat,
                        longitude: lon,
                        distance_km: None, // Could calculate Haversine here if needed
                    })
                } else {
                    None
                }
            })
            .collect())
    }
}
