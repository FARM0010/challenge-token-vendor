// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YourToken is ERC20 {
    constructor() ERC20("YourToken", "YTK") {
        // Mint 1000 * 10**18 to the deployer (msg.sender)
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}