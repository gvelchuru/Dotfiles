import heapq

stocks = [
    ("nusc", 54, 29.51, 0.18),
    ("nuem", 7, 25.77, 0.1),
    ("nudm", 22, 26.73, 0.1),
    ("numv", 3, 29.19, 0.09),
    ("numg", 6, 33.13, 0.09),
    ("nulc", 51, 27.69, 0.28),
    ("nuag", 0, 24.81, 0.06),
    ("nure", 26, 31.14, .1)
]
buying_power = 2780.91 * .9
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
    
