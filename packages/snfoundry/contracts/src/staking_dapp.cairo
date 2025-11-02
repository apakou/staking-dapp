use starknet::ContractAddress;

#[starknet::interface]
pub trait IStakingContract<TContractState> {
    fn set_allowed_tokens(ref self: TContractState, token_address: ContractAddress) -> bool;
    fn remove_allowed_token(ref self: TContractState, token_address: ContractAddress) -> bool;
    fn set_reward_rate(ref self: TContractState, rate: u128) -> bool;
}

#[starknet::contract]
pub mod StakingContract {
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapWriteAccess, StorageMapReadAccess, StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::IStakingContract;
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        allowed_tokens: Map<ContractAddress, bool>,
        reward_rate: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_reward_rate: u128) {
        self.reward_rate.write(initial_reward_rate);
    }

    #[abi(embed_v0)]
    impl StakingContractImpl of IStakingContract<ContractState> {
        fn set_allowed_tokens(ref self: ContractState, token_address: ContractAddress) -> bool {
            assert!(!token_address.is_zero(), "Token address cannot be zero.");
            self.allowed_tokens.write(token_address, true);
            true
        }

        fn remove_allowed_token(ref self: ContractState, token_address: ContractAddress) -> bool {
            assert!(!token_address.is_zero(), "Token address cannot be zero.");

            let is_allowed = self.allowed_tokens.read(token_address);
            assert!(is_allowed, "Token address is not in the allowed list.");
            
            self.allowed_tokens.write(token_address, false);
            true
        }

        fn set_reward_rate(ref self: ContractState, rate: u128) -> bool {
            assert!(rate > 0, "Reward rate must be greater than zero.");

            self.reward_rate.write(rate);
            true
        }
    }
}
