from collections import deque

liquidity = {
    ("tokenA", "tokenB"): (17, 10),
    ("tokenA", "tokenC"): (11, 7),
    ("tokenA", "tokenD"): (15, 9),
    ("tokenA", "tokenE"): (21, 5),
    ("tokenB", "tokenC"): (36, 4),
    ("tokenB", "tokenD"): (13, 6),
    ("tokenB", "tokenE"): (25, 3),
    ("tokenC", "tokenD"): (30, 12),
    ("tokenC", "tokenE"): (10, 8),
    ("tokenD", "tokenE"): (60, 25),
}

start_token = "tokenB"
initial_amount = 5

graph = {}
for (token1, token2), (amount1, amount2) in liquidity.items():
    if token1 not in graph:
        graph[token1] = []
    if token2 not in graph:
        graph[token2] = []
    graph[token1].append((token2, amount2 / amount1))
    graph[token2].append((token1, amount1 / amount2))

def find_profitable_path(start_token, initial_amount):
    queue = deque([(start_token, initial_amount, [start_token])])
    while queue:
        current_token, current_amount, path = queue.popleft()
        for next_token, exchange_rate in graph[current_token]:
            next_amount = current_amount * exchange_rate
            next_path = path + [next_token]
            if next_token == start_token and next_amount > initial_amount:
                return next_path, next_amount
            elif next_token not in path:  # 避免循环
                queue.append((next_token, next_amount, next_path))
    return None, None

path, final_amount = find_profitable_path(start_token, initial_amount)

if path and final_amount:
    result_path = "->".join(path)
    print(f"path: {result_path}, tokenB balance={final_amount:.6f}")
else:
    print("No profitable path found.")
