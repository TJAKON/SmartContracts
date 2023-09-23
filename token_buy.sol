// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IPancakeRouter {
    function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
        external
        payable
        returns (uint256[] memory amounts);
}

contract AutomatedTokenBuy is Ownable {
    address private pancakeRouterAddress = 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F; //change this your account // PancakeSwap Router V2 address
    address private tokenAddress; // change this according to Address of the TokenA contract
    address private wbnbAddress = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; //change this your account // WBNB address on BSC

    IPancakeRouter private pancakeRouter;
    IERC20 private token;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
        pancakeRouter = IPancakeRouter(pancakeRouterAddress);
        token = IERC20(tokenAddress);
    }

    function buyTokens(uint256 amountToBuy) external onlyOwner payable {
        require(amountToBuy > 0, "Amount must be greater than 0");

        address[] memory path = new address[](2);
        path[0] = wbnbAddress;
        path[1] = tokenAddress;

        pancakeRouter.swapExactETHForTokens{value: msg.value}(
            0,
            path,
            address(this),
            block.timestamp + 15 minutes
        );

    }

    receive() external payable {}
}
