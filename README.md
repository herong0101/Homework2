# 2024-Spring-HW2

Please complete the report problem below:

## Problem 1
Provide your profitable path, the amountIn, amountOut value for each swap, and your final reward (your tokenB balance).

>  profitable path:tokenB -> tokenA -> tokenD -> tokenC -> tokenB，tokenB balance:20129888944077446732

## Problem 2
What is slippage in AMM, and how does Uniswap V2 address this issue? Please illustrate with a function as an example.

> 大量交易時所發生的價格與預期間產生落差。鼓勵大家進入，增加流動性，同時高於用戶能接受的比例的時候暫停用戶交易。

## Problem 3
Please examine the mint function in the UniswapV2Pair contract. Upon initial liquidity minting, a minimum liquidity is subtracted. What is the rationale behind this design?

> 標記資產、避免所有被提取後，可能的被重複創建、避免在流動性低的狀況下被操縱價格。

## Problem 4
Investigate the minting function in the UniswapV2Pair contract. When depositing tokens (not for the first time), liquidity can only be obtained using a specific formula. What is the intention behind this?

> 要確保池中價值可以保持恆定與平衡，而不會發生稀釋等等的狀況。

## Problem 5
What is a sandwich attack, and how might it impact you when initiating a swap?

>攻擊者會在一個大交易的前後執行兩筆交易，第一筆交易為了抬高價格，第二筆交易在大交易後，因此可以以較高的價格賣出因此獲利。因為第一次交易的抬價會導致我們的損失。

