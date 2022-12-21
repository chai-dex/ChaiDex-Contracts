// SPDX-License-Identifier: MIT
// CHAIDEX Version 1
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract INRChai is ERC20, Ownable {
    event Issue(uint256 amount);
    event Redeem(uint256 amount, address redeemer);

    constructor() ERC20("INR Chai", "INRC") {
    }

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }

    function issue(address to, uint256 amount) public onlyOwner {
        require(amount > 0, "Amount cannot be 0");
        _mint(to, amount);
        emit Issue(amount);
    }

    function redeem(uint256 amount) public virtual {
        require(amount > 0, "Amount cannot be 0");
        _burn(_msgSender(), amount);
        emit Redeem(amount, msg.sender);
    }
}