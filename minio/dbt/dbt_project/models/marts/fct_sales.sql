-- Mart model: Sales fact table with key metrics
select
    order_id,
    customer_id,
    customer_name,
    country,
    product,
    amount,
    order_date,
    order_year,
    order_month,
    current_timestamp as loaded_at,
    row_number() over (order by order_id) as row_num
from {{ ref('int_orders_enriched') }}
order by order_id
