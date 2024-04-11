function testExploit() public {
    vm.startPrank(arbitrager);
    uint256 tokensBefore = tokenB.balanceOf(arbitrager);
    console.log("Before Arbitrage tokenB Balance: %s", tokensBefore);

    uint256 tokenABalanceBefore;
    uint256 tokenABalanceAfter;
    uint256 tokenDBalanceBefore;
    uint256 tokenDBalanceAfter;
    uint256 tokenCBalanceBefore;
    uint256 tokenCBalanceAfter;
    uint256 tokensAfter;

    tokenB.approve(address(router), 5 ether);
    uint256 deadline = block.timestamp + 300; 

    // tokenB -> tokenA
    tokenABalanceBefore = tokenA.balanceOf(arbitrager);
    address[] memory pathBA = new address[](2);
    pathBA[0] = address(tokenB);
    pathBA[1] = address(tokenA);
    router.swapExactTokensForTokens(5 ether, 0, pathBA, arbitrager, deadline);
    tokenABalanceAfter = tokenA.balanceOf(arbitrager);
    console.log("tokenB -> tokenA: amountIn = 5 ether, amountOut = %s", tokenABalanceAfter - tokenABalanceBefore);

    // tokenA -> tokenD
    tokenDBalanceBefore = tokenD.balanceOf(arbitrager);
    uint256 tokenABalance = tokenA.balanceOf(arbitrager);
    tokenA.approve(address(router), tokenABalance);
    address[] memory pathAD = new address[](2);
    pathAD[0] = address(tokenA);
    pathAD[1] = address(tokenD);
    router.swapExactTokensForTokens(tokenABalance, 0, pathAD, arbitrager, deadline);
    tokenDBalanceAfter = tokenD.balanceOf(arbitrager);
    console.log("tokenA -> tokenD: amountIn = %s, amountOut = %s", tokenABalance, tokenDBalanceAfter - tokenDBalanceBefore);

    // tokenD -> tokenC
    tokenCBalanceBefore = tokenC.balanceOf(arbitrager);
    uint256 tokenDBalance = tokenD.balanceOf(arbitrager);
    tokenD.approve(address(router), tokenDBalance);
    address[] memory pathDC = new address[](2);
    pathDC[0] = address(tokenD);
    pathDC[1] = address(tokenC);
    router.swapExactTokensForTokens(tokenDBalance, 0, pathDC, arbitrager, deadline);
    tokenCBalanceAfter = tokenC.balanceOf(arbitrager);
    console.log("tokenD -> tokenC: amountIn = %s, amountOut = %s", tokenDBalance, tokenCBalanceAfter - tokenCBalanceBefore);
    
    // tokenC -> tokenB
    uint256 tokenCBalance = tokenC.balanceOf(arbitrager);
    tokenC.approve(address(router), tokenCBalance);
    address[] memory pathCB = new address[](2);
    pathCB[0] = address(tokenC);
    pathCB[1] = address(tokenB);
    router.swapExactTokensForTokens(tokenCBalance, 0, pathCB, arbitrager, deadline);

    tokensAfter = tokenB.balanceOf(arbitrager);
    console.log("tokenC -> tokenB: amountIn = %s, amountOut = %s", tokenCBalance, tokensAfter - tokensBefore);
    assertGt(tokensAfter, 20 ether);
    console.log("After Arbitrage tokenB Balance: %s", tokensAfter);

    vm.stopPrank();
}
