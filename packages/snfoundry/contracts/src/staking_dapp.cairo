use starknet::ContractAddress;

#[starknet::interface]
pub trait IStakingContract<TContractState> {
    fn set_allowed_tokens(ref self: TContractState, token_address: ContractAddress) -> bool;
}

#[starknet::contract]
pub mod StakingContract {
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapWriteAccess, StorageMapReadAccess};
    use super::IStakingContract;
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        allowed_tokens: Map<ContractAddress, bool>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {

    }

    #[abi(embed_v0)]
    impl StakingContractImpl of IStakingContract<ContractState> {
        fn set_allowed_tokens(ref self: ContractState, token_address: ContractAddress) -> bool {
            assert!(!token_address.is_zero(), "Token address cannot be zero.");
            self.allowed_tokens.write(token_address, true);
            true
        }
    }
}
