-- Delivery Center - SQL Project

# 1- How many hubs are on each city?

SELECT hub_city, COUNT(hub_name) AS hubs_count
FROM delivery_center.hubs
GROUP BY hub_city
ORDER BY hubs_count DESC;

# 2- Total number of orders by order status.

SELECT order_status, COUNT(order_id) AS num_orders
FROM delivery_center.orders
GROUP BY order_status;

# 3- What is the number of stores by hub cities?

SELECT hub_city, COUNT(store_id) AS num_stores
FROM delivery_center.hubs hubs, delivery_center.stores stores
WHERE hubs.hub_id = stores.hub_id
GROUP BY hub_city
ORDER BY num_stores DESC;

# 4- What's the maximum and minimum payment amount registered?

SELECT MAX(payment_amount) FROM delivery_center.payments;
SELECT MIN(payment_amount) FROM delivery_center.payments;

# 5- Which driver type have done the higher number of deliveries?

SELECT driver_type, COUNT(delivery_id) AS total_deliveries
FROM delivery_center.deliveries deliveries, delivery_center.drivers drivers
WHERE drivers.driver_id = deliveries.driver_id
GROUP BY driver_type
ORDER BY total_deliveries DESC;

# 6- What is the average distance in deliveries for each driver type (driver_modal)?

SELECT driver_modal, ROUND(AVG(delivery_distance_meters),2) AS avg_distance
FROM delivery_center.deliveries deliveries, delivery_center.drivers drivers
WHERE drivers.driver_id = deliveries.driver_id
GROUP BY driver_modal; 

# 7- What is the average order amount by store? TOP 10 stores

SELECT store_name, ROUND(AVG(order_amount),2) AS avg_order_amount
FROM delivery_center.orders orders, delivery_center.stores stores
WHERE stores.store_id = orders.store_id
GROUP BY store_name
ORDER BY avg_order_amount DESC LIMIT 10;

# 8- Is there any order not associated with a store? If yes, which stores?

SELECT COALESCE(store_name, "NO STORE ASSOCIATED") AS store, COUNT(order_id) AS orders_count
FROM delivery_center.orders orders LEFT JOIN delivery_center.stores stores
ON stores.store_id = orders.store_id
GROUP BY store_name
HAVING store = "NO STORE ASSOCIATED"
ORDER BY orders_count DESC;

# 9- What is the total order amount on the channel 'FOOD PLACE'?

SELECT ROUND(sum(order_amount),2) AS Food_Place_Total_Orders_Amount
FROM delivery_center.orders orders, delivery_center.channels channels
WHERE channels.channel_id = orders.channel_id
AND channel_name = 'FOOD PLACE';

# 10- How many payments were chargeback?

SELECT payment_status, COUNT(payment_status) AS payment_count
FROM delivery_center.payments payments
WHERE payment_status = 'CHARGEBACK'
GROUP BY payment_status;

# 11- What was the average amount of chargeback payments?

SELECT payment_status, ROUND(AVG(payment_amount),2) AS average_payment
FROM delivery_center.payments payments
WHERE payment_status = 'CHARGEBACK'
GROUP BY payment_status;

# 12- What is the average amount paid by payment method, considering at least 5k transactions registered?

SELECT payment_method, ROUND(AVG(payment_amount),2) AS avg_payment, COUNT(payment_amount) AS total_payments
FROM delivery_center.payments
GROUP BY payment_method
HAVING total_payments > 5000
ORDER BY avg_payment DESC;

# 13- Which payment methods had the average amount spent greater than 100?

SELECT payment_method, ROUND(AVG(payment_amount),2) AS avg_payment
FROM delivery_center.payments
GROUP BY payment_method
HAVING avg_payment > 100
ORDER BY avg_payment DESC;

# 14- What is average order amount by hub state, store segment and channel type?

SELECT hub_state, store_segment, channel_type, ROUND(AVG(order_amount),2) AS avg_order_amount
FROM delivery_center.orders orders, delivery_center.stores stores, delivery_center.channels channels, delivery_center.hubs hubs
WHERE stores.store_id = orders.store_id
AND channels.channel_id = orders.channel_id
AND hubs.hub_id = stores.hub_id
GROUP BY hub_state, store_segment, channel_type
ORDER BY hub_state;

# 15- Which hub state, store segment and channel type had an average order amount greater than 450?

SELECT hub_state, store_segment, channel_type, ROUND(AVG(order_amount),2) AS avg_order_amount
FROM delivery_center.orders orders, delivery_center.stores stores, delivery_center.channels channels, delivery_center.hubs hubs
WHERE stores.store_id = orders.store_id
AND channels.channel_id = orders.channel_id
AND hubs.hub_id = stores.hub_id
GROUP BY hub_state, store_segment, channel_type
HAVING avg_order_amount > 450
ORDER BY hub_state;

# 16- What is the total order amount by hub state, store segment and channel type?

-- Optimize this query

SELECT 
	IF(GROUPING(hub_state), 'Total Hub State', hub_state) AS hub_state,
    IF(GROUPING(store_segment), 'Total Store Segment', store_segment) AS store_segment,
    IF(GROUPING(channel_type), 'Total Channel Type', channel_type) AS channel_type,
    ROUND(SUM(order_amount),2) total_order_amount
FROM delivery_center.orders orders, delivery_center.stores stores, delivery_center.channels channels, delivery_center.hubs hubs
WHERE stores.store_id = orders.store_id
AND channels.channel_id = orders.channel_id
AND hubs.hub_id = stores.hub_id
GROUP BY hub_state, store_segment, channel_type WITH ROLLUP;

# 17- What is the average order amount for the Rio de Janeiro Hub, segment store FOOD and Markplace channel with status of Canceled?

SELECT hub_state, store_segment, channel_type, ROUND(AVG(order_amount),2) AS avg_order_amount
FROM delivery_center.orders orders, delivery_center.stores stores, delivery_center.channels channels, delivery_center.hubs hubs
WHERE stores.store_id = orders.store_id
AND channels.channel_id = orders.channel_id
AND hubs.hub_id = stores.hub_id
AND order_status = 'CANCELED'
AND store_segment = 'FOOD'
AND channel_type = 'MARKETPLACE'
AND hub_state = 'RJ'
GROUP BY hub_state, store_segment, channel_type;

# 18- With store segment GOOD and Marketplace channel with order status Canceled, is there any hub state with total order amount over 100k?

SELECT hub_state, store_segment, channel_type, ROUND(SUM(order_amount),2) AS total_order_amount
FROM delivery_center.orders orders, delivery_center.stores stores, delivery_center.channels channels, delivery_center.hubs hubs
WHERE stores.store_id = orders.store_id
AND channels.channel_id = orders.channel_id
AND hubs.hub_id = stores.hub_id
AND order_status = 'CANCELED'
AND store_segment = 'GOOD'
AND channel_type = 'MARKETPLACE'
GROUP BY hub_state, store_segment, channel_type
HAVING total_order_amount > 100000;

# 19- On which date the average order amount was the highest?

SELECT SUBSTRING(order_moment_created, 1, 9) AS order_date, ROUND(AVG(order_amount),2) AS avg_order_amount
FROM delivery_center.orders orders
GROUP BY order_date
ORDER BY avg_order_amount DESC LIMIT 5;

# 20- On which dates the average order amount was 0, meaning no sale?

SELECT SUBSTRING(order_moment_created, 1, 9) AS order_date, MIN(order_amount) AS min_order_amount
FROM delivery_center.orders orders
GROUP BY order_date
HAVING min_order_amount = 0
ORDER BY order_date ASC;