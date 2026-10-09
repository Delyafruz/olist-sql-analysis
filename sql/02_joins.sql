-- Выручка по месяцам (только доставленные заказы)
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
       ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;
-- Топ-10 категорий товаров по выручке
SELECT COALESCE(t.product_category_name_english, 'unknown') AS category,
       ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation t
       ON p.product_category_name = t.product_category_name
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;

-- Среднее время доставки в днях (только доставленные заказы)
SELECT ROUND(AVG(
         EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
       )::numeric, 1) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- Доля заказов, доставленных позже обещанной даты
WITH delivered AS (
    SELECT order_id,
           CASE WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1 ELSE 0 END AS is_late
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
)
SELECT ROUND(100.0 * SUM(is_late) / COUNT(*), 1) AS late_pct
FROM delivered;
