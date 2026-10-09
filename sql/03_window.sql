-- Рост выручки месяц к месяцу (оконная функция LAG)
WITH monthly AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
           SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
    GROUP BY 1
)
SELECT month,
       ROUND(revenue::numeric, 2) AS revenue,
       ROUND((100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month))::numeric, 1) AS growth_pct
FROM monthly
ORDER BY month;