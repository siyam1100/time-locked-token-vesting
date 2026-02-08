# Time-Locked Token Vesting

This repository provides a secure, industry-standard implementation for token vesting. It is designed for blockchain startups to manage token allocations for founders, employees, and advisors, ensuring long-term alignment and preventing immediate sell-offs.

### Features
* **Cliff Period:** A set duration before any tokens can be claimed.
* **Linear Release:** Continuous, per-second token unlocking after the cliff.
* **Revocable:** Optional feature allowing the owner to cancel vesting for terminated employees.
* **Transparent Tracking:** On-chain visibility of total, released, and remaining balances.

### How it Works
1. **Deployment:** The contract is initialized with the beneficiary address, start time, cliff duration, and total vesting duration.
2. **Funding:** The project sends the full amount of ERC-20 tokens to the contract.
3. **Vesting:** As time passes, the `vestedAmount()` increases.
4. **Release:** The beneficiary calls `release()` to transfer the currently unlocked tokens to their wallet.
