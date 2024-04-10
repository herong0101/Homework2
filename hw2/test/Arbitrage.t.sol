// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ISwapV2Router02} from "../src/Arbitrage.sol";

contract Token is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialMint) ERC20(name, symbol) {
        _mint(msg.sender, initialMint);
    }
}

contract Arbitrage is Test {
    Token tokenA;
    Token tokenB;
    Token tokenC;
    Token tokenD;
    Token tokenE;
    address owner = makeAddr("owner");
    address arbitrager = makeAddr("arbitrageMan");
    ISwapV2Router02 router = ISwapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    function _addLiquidity(address token0, address token1, uint256 token0Amount, uint256 token1Amount) internal {
        router.addLiquidity(
            token0,
            token1,
            token0Amount,
            token1Amount,
            token0Amount,
            token1Amount,
            owner,
            block.timestamp
        );
    }

    function setUp() public {
        vm.createSelectFork(vm.envString("RPC_URL"));
        vm.startPrank(owner);

        uint256 initialSupply = 100 ether;

        tokenA = new Token("tokenA", "A", initialSupply);
        tokenB = new Token("tokenB", "B", initialSupply);
        tokenC = new Token("tokenC", "C", initialSupply);
        tokenD = new Token("tokenD", "D", initialSupply);
        tokenE = new Token("tokenE", "E", initialSupply);

        tokenA.approve(address(router), initialSupply);
        tokenB.approve(address(router), initialSupply);
        tokenC.approve(address(router), initialSupply);
        tokenD.approve(address(router), initialSupply);
        tokenE.approve(address(router), initialSupply);

        _addLiquidity(address(tokenA), address(tokenB), 17 ether, 10 ether);
        _addLiquidity(address(tokenA), address(tokenC), 11 ether, 7 ether);
        _addLiquidity(address(tokenA), address(tokenD), 15 ether, 9 ether);
        _addLiquidity(address(tokenA), address(tokenE), 21 ether, 5 ether);
        _addLiquidity(address(tokenB), address(tokenC), 36 ether, 4 ether);
        _addLiquidity(address(tokenB), address(tokenD), 13 ether, 6 ether);
        _addLiquidity(address(tokenB), address(tokenE), 25 ether, 3 ether);
        _addLiquidity(address(tokenC), address(tokenD), 30 ether, 12 ether);
        _addLiquidity(address(tokenC), address(tokenE), 10 ether, 8 ether);
        _addLiquidity(address(tokenD), address(tokenE), 60 ether, 25 ether);

        tokenB.transfer(arbitrager, 5 ether);
        vm.stopPrank();
    }

    function testHack() public pure {
        console2.log("Happy Hacking!");
    }

function testExploit() public {
    vm.startPrank(arbitrager);
    uint256 tokensBefore = tokenB.balanceOf(arbitrager);
    console.log("Before Arbitrage tokenB Balance: %s", tokensBefore);

    // 确保首次授权成功，授权足够数量的tokenB给router
    tokenB.approve(address(router), 5 ether);

    uint256 deadline = block.timestamp + 300; // 设置期限

    // tokenB -> tokenA
    address[] memory pathBA = new address[](2);
    pathBA[0] = address(tokenB);
    pathBA[1] = address(tokenA);
    router.swapExactTokensForTokens(5 ether, 0, pathBA, arbitrager, deadline);

    // 获取交换后的tokenA余额，并授权给router
    uint256 tokenABalance = tokenA.balanceOf(arbitrager);
    tokenA.approve(address(router), tokenABalance);

    // tokenA -> tokenD
    address[] memory pathAD = new address[](2);
    pathAD[0] = address(tokenA);
    pathAD[1] = address(tokenD);
    router.swapExactTokensForTokens(tokenABalance, 0, pathAD, arbitrager, deadline);

    // 获取交换后的tokenD余额，并授权给router
    uint256 tokenDBalance = tokenD.balanceOf(arbitrager);
    tokenD.approve(address(router), tokenDBalance);

    // tokenD -> tokenC
    address[] memory pathDC = new address[](2);
    pathDC[0] = address(tokenD);
    pathDC[1] = address(tokenC);
    router.swapExactTokensForTokens(tokenDBalance, 0, pathDC, arbitrager, deadline);

    // 获取交换后的tokenC余额，并授权给router
    uint256 tokenCBalance = tokenC.balanceOf(arbitrager);
    tokenC.approve(address(router), tokenCBalance);
    
    // tokenC -> tokenB
    address[] memory pathCB = new address[](2);
    pathCB[0] = address(tokenC);
    pathCB[1] = address(tokenB);
    router.swapExactTokensForTokens(tokenCBalance, 0, pathCB, arbitrager, deadline);

    uint256 tokensAfter = tokenB.balanceOf(arbitrager);
    assertGt(tokensAfter, 20 ether);
    console.log("After Arbitrage tokenB Balance: %s", tokensAfter);
    vm.stopPrank();
}


}