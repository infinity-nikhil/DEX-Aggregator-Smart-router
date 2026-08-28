// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Aggregator {
    address public owner;
    address public pendingOwner;
    address public feeWallet;

    uint16 public feeBps;
    uint16 public constant HARD_CAP = 100;

    IERC20 public immutable usdg;

    struct Leg {
        PoolKey v4Key;
        uint256 portionBps;
    }

    mapping(bytes32 => bool) public allowedV4Pool;

    error NotOwner();
    error NotPendingOwner();
    error FeeTooHigh();

    constructor(address _usdg) {
        owner = msg.sender;
        feeWallet = msg.sender;
        usdg = IERC20(_usdg); 
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        pendingOwner = newOwner;
    }

    function acceptOwnership() external {
        if (msg.sender != pendingOwner) revert NotPendingOwner();

        owner = pendingOwner;
        pendingOwner = address(0);
    }

    function setFee(uint16 feeBps_) external onlyOwner{
        if (feeBps_ > HARD_CAP) revert FeeTooHigh();

        feeBps = feeBps_;
    }

    function _split(uint256 usdgLeg) internal view returns (uint256 fee, uint256 rest) {
        fee = (usdgLeg * feeBps) / 10_000;
        rest = usdgLeg - fee;
    }

    function _skim(uint256 fee) internal {
        if (fee > 0) {
            usdg.safeTransfer(feeWallet, fee);
        }
    }

    function setV4PoolAllowed(PoolKey calldata key, bool ok) external onlyOwner {
    address c0 = Currency.unwrap(key.currency0);
    address c1 = Currency.unwrap(key.currency1);
    if (c0 != address(usdg) && c1 != address(usdg)) revert NotUsdgPool();
    bytes32 h = keccak256(abi.encode(key));
    allowedV4Pool[h] = ok;
    }

    function _checkLegs(Leg[] calldata legs) internal view {
        uint256 n = legs.length;
        if (n == 0 || n > MAX_LEGS) revert BadLegCount();
        uint256 sum;
        for (uint256 i; i < n; ++i) {
            sum += legs[i].portionBps;
            if (!allowedV4Pool[keccak256(abi.encode(legs[i].v4Key))]) revert PoolNotAllowed();
        }
        if (sum != 10_000) revert BadSplit();
    }
}