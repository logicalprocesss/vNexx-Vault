// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MyVault is ERC4626, ReentrancyGuard {
    uint256 public constant DEPOSIT_CAP = 1_000_000e18;

    constructor(IERC20 asset_)
        ERC20("Nexxus Vault Shares", "vNexx")
        ERC4626(asset_)
    {}

    // Protects against the "first depositor" inflation attack
    function _decimalsOffset() internal pure override returns (uint8) {
        return 6;
    }

    // Limits how much money is at risk while you're still testing
    function maxDeposit(address) public view override returns (uint256) {
        uint256 total = totalAssets();
        return total >= DEPOSIT_CAP ? 0 : DEPOSIT_CAP - total;
    }

    function deposit(uint256 assets, address receiver) public override nonReentrant returns (uint256) {
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver) public override nonReentrant returns (uint256) {
        return super.mint(shares, receiver);
    }

    function withdraw(uint256 assets, address receiver, address owner) public override nonReentrant returns (uint256) {
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(uint256 shares, address receiver, address owner) public override nonReentrant returns (uint256) {
        return super.redeem(shares, receiver, owner);

    }

    function maxMint(address receiver) public view override returns (uint256) {
    return convertToShares(maxDeposit(receiver));
    }
 
}