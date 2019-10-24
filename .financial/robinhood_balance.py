import heapq

stocks = [
    ("nusc", 22, 29.58, 0.2),
    ("nuem", 7, 25.5, 0.1),
    ("nudm", 22, 26.68, 0.1),
    ("numv", 3, 29.36, 0.1),
    ("numg", 6, 32.91, 0.1),
    ("nulc", 51, 27.69, 0.3),
    ("nuag", 0, 24.75, 0.1),
]
buying_power = .16 
total = sum(count * price for _, count, price, _ in stocks)

print("SUM" + str(sum(x[3] for x in stocks)))


def get_percent_diff(count, price, percent):
    return (count * price / total) - percent


heap = []

for stock, count, price, ideal_percent in stocks:
    heapq.heappush(heap, (get_percent_diff(count, price, ideal_percent), (stock, count, price, ideal_percent)))
while buying_power > 0:
    percent_diff, stock_tuple = heapq.heappop(heap) 
    stock, count, price, ideal_percent = stock_tuple
    count += 1
    total += price
    buying_power -= price
    heapq.heappush(heap, (get_percent_diff(count, price, ideal_percent), (stock, count, price, ideal_percent)))

print(heap)
    
