use async_trait::async_trait;
use ethers::prelude::*;
use std::str::FromStr;
use std::sync::Arc;
use anyhow::{Result, anyhow};

#[async_trait]
pub trait BlockchainService: Send + Sync {
    /// Verifies that a message was signed by the given address.
    /// Returns true if valid, false otherwise.
    fn verify_signature(&self, message: &str, signature: &str, address: &str) -> Result<bool>;

    /// Checks if the given address owns at least one token of the specified NFT contract.
    async fn check_nft_ownership(&self, user_address: &str, contract_address: &str) -> Result<bool>;
}

pub struct EvmBlockchainService {
    provider: Provider<Http>,
}

impl EvmBlockchainService {
    pub fn new(rpc_url: &str) -> Result<Self> {
        let provider = Provider::<Http>::try_from(rpc_url)?;
        Ok(Self { provider })
    }
}

#[async_trait]
impl BlockchainService for EvmBlockchainService {
    fn verify_signature(&self, message: &str, signature: &str, address: &str) -> Result<bool> {
        let sig = Signature::from_str(signature).map_err(|e| anyhow!("Invalid signature: {}", e))?;
        let addr = Address::from_str(address).map_err(|e| anyhow!("Invalid address: {}", e))?;
        
        // Recover the address from the signature and message
        let recovered_addr = sig.recover(message).map_err(|e| anyhow!("Recovery failed: {}", e))?;
        
        Ok(recovered_addr == addr)
    }

    async fn check_nft_ownership(&self, user_address: &str, contract_address: &str) -> Result<bool> {
        let user_addr = Address::from_str(user_address).map_err(|e| anyhow!("Invalid user address: {}", e))?;
        let contract_addr = Address::from_str(contract_address).map_err(|e| anyhow!("Invalid contract address: {}", e))?;

        // Minimal ABI for balanceOf
        abigen!(
            ERC721,
            r#"[
                function balanceOf(address owner) external view returns (uint256)
            ]"#,
        );

        let contract = ERC721::new(contract_addr, Arc::new(self.provider.clone()));
        let balance = contract.balance_of(user_addr).call().await?;

        Ok(balance > U256::zero())
    }
}
