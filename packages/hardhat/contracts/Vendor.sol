// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vendor is Ownable {
    IERC20 public yourToken;
    uint256 public constant tokensPerEth = 100; // required by challenge

    event BuyTokens(address indexed buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address indexed seller, uint256 amountOfTokens, uint256 amountOfETH);
    event Withdraw(address indexed owner, uint256 amount);

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = IERC20(tokenAddress);
    }

    // Buy tokens with ETH
    function buyTokens() external payable {
        require(msg.value > 0, "Send ETH to buy tokens");
        uint256 amountToBuy = msg.value * tokensPerEth;
        uint256 vendorBalance = yourToken.balanceOf(address(this));
        require(vendorBalance >= amountToBuy, "Vendor has insufficient tokens");
        bool sent = yourToken.transfer(msg.sender, amountToBuy);
        require(sent, "Token transfer failed");
        emit BuyTokens(msg.sender, msg.value, amountToBuy);
    }

    // Sell tokens back to vendor (requires prior approve on YourToken)
    function sellTokens(uint256 amount) external {
        require(amount > 0, "Specify token amount to sell");

        // Transfer tokens from user to vendor
        bool received = yourToken.transferFrom(msg.sender, address(this), amount);
        require(received, "Token transferFrom failed");

        // Calculate ETH to return
        uint256 ethToReturn = amount / tokensPerEth;
        require(address(this).balance >= ethToReturn, "Vendor has insufficient ETH");

        (bool ok, ) = payable(msg.sender).call{value: ethToReturn}("");
        require(ok, "ETH transfer failed");

        emit SellTokens(msg.sender, amount, ethToReturn);
    }

    // Owner can withdraw all ETH
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        (bool ok, ) = payable(owner()).call{value: balance}("");
        require(ok, "Withdraw failed");
        emit Withdraw(owner(), balance);
    }

    // Accept ETH (e.g., for funding the vendor)
    receive() external payable {}
}