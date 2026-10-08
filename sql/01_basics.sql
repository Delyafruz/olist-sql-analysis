-- Сколько всего заказов
SELECT COUNT(*) FROM orders;

-- Заказы по статусам
SELECT order_status, COUNT(*) AS orders_cnt
FROM orders
GROUP BY order_status
ORDER BY orders_cnt DESC;

-- Заказы по месяцам
SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month,
       COUNT(*) AS orders_cnt
FROM orders
GROUP BY 1
ORDER BY 1;

-- Общая выручка
SELECT ROUND(SUM(price)::numeric, 2) AS total_revenue
FROM order_items;