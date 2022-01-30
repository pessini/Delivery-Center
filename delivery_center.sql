

-- CREATE USER 'tableau'@'localhost' IDENTIFIED BY 'Tableau0430@';
-- GRANT SELECT ON delivery_center.* TO tableau@'localhost';
-- ALTER USER 'tableau'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Tableau0430@';

-- select * from mysql.user;


# 1- How many hubs are on each city?

SELECT hub_city, COUNT(hub_name) AS contagem
FROM delivery_center.hubs
GROUP BY hub_city
ORDER BY contagem DESC;

# 2- Total number of orders by order status.

SELECT order_status, COUNT(order_id) AS num_pedidos
FROM delivery_center.orders
GROUP BY order_status;

# 3- What is the number of stores by hub cities?

SELECT hub_city, COUNT(store_id) AS num_lojas
FROM delivery_center.hubs hubs, delivery_center.stores stores
WHERE hubs.hub_id = stores.hub_id
GROUP BY hub_city
ORDER BY num_lojas DESC;

# 4- What's the maximum and minimum payment amount registered?

SELECT MAX(payment_amount) FROM delivery_center.payments;
SELECT MIN(payment_amount) FROM delivery_center.payments;

# 5- Which driver type have done the higher number of deliveries?

SELECT driver_type, COUNT(delivery_id) AS num_entregas
FROM delivery_center.deliveries deliveries, delivery_center.drivers drivers
WHERE drivers.driver_id = deliveries.driver_id
GROUP BY driver_type
ORDER BY num_entregas DESC;


# 6- Qual a distância média das entregas por tipo de driver (driver_modal)?

# 7- Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?

# 8- Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?

# 9- Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?

# 10- Quantos pagamentos foram cancelados (chargeback)?

# 11- Qual foi o valor médio dos pagamentos cancelados (chargeback)?

# 12- Qual a média do valor de pagamento por método de pagamento (payment_method) em ordem decrescente?

# 13- Quais métodos de pagamento tiveram valor médio superior a 100?

# 14- Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), 
# 	segmento da loja (store_segment) e tipo de canal (channel_type)?

# 15- Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal
#	(channel_type) teve média de valor de pedido (order_amount) maior que 450?

# 16- Qual o valor total de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo 
# 	de canal (channel_type)? Demonstre os totais intermediários e formate o resultado.

# 17- Quando o pedido era do Hub do Rio de Janeiro (hub_state), segmento de loja
#	'FOOD', tipo de canal Marketplace e foi cancelado, qual foi a média de valor do pedido (order_amount)?

# 18- Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi cancelado, algum hub_state 
#	teve total de valor do pedido superior a 100.000?

# 19- Em que data houve a maior média de valor do pedido (order_amount)? 
# Dica:Pesquise e use a função SUBSTRING().

# 20- Em quais datas o valor do pedido foi igual a zero (ou seja, não houve venda)? Dica:
# Use a função SUBSTRING().