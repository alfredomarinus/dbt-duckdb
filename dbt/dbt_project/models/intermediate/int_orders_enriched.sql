-- Intermediate model: Enrich order data with customer information
select
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.country,
    o.product,
    o.amount,
    o.order_date,
    extract(year from o.order_date) as order_year,
    extract(month from o.order_date) as order_month,
    o.created_at
from {{ ref('stg_orders') }} o
left join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id
