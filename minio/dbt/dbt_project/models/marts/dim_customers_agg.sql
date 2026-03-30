-- Mart model: Customer aggregated metrics
select
    customer_id,
    customer_name,
    country,
    count(distinct order_id) as total_orders,
    sum(amount) as total_revenue,
    avg(amount) as avg_order_value,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    current_timestamp as loaded_at
from {{ ref('int_orders_enriched') }}
group by customer_id, customer_name, country
order by total_revenue desc
