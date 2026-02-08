// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

/**
 * @title VestingWallet
 * @dev Handles the vesting of ERC20 tokens for a specific beneficiary.
 */
contract VestingWallet {
    event TokensReleased(address indexed token, uint256 amount);

    address public immutable beneficiary;
    uint64 public immutable start;
    uint64 public immutable duration;
    uint64 public immutable cliff;

    mapping(address => uint256) private _erc20Released;

    constructor(address _beneficiary, uint64 _start, uint64 _duration, uint64 _cliff) {
        require(_beneficiary != address(0), "Invalid beneficiary");
        require(_cliff <= _duration, "Cliff longer than duration");
        
        beneficiary = _beneficiary;
        start = _start;
        duration = _duration;
        cliff = _cliff;
    }

    /**
     * @dev Release the tokens that have already vested.
     */
    function release(address token) public {
        uint256 releasable = vestedAmount(token, uint64(block.timestamp)) - _erc20Released[token];
        require(releasable > 0, "No tokens to release");

        _erc20Released[token] += releasable;
        emit TokensReleased(token, releasable);
        IERC20(token).transfer(beneficiary, releasable);
    }

    /**
     * @dev Calculates the amount of tokens that has already vested.
     */
    function vestedAmount(address token, uint64 timestamp) public view returns (uint256) {
        uint256 totalAllocation = IERC20(token).balanceOf(address(this)) + _erc20Released[token];

        if (timestamp < start + cliff) {
            return 0;
        } else if (timestamp >= start + duration) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start)) / duration;
        }
    }

    function released(address token) public view returns (uint256) {
        return _erc20Released[token];
    }
}
