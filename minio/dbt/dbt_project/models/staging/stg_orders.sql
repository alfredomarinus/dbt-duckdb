-- Staging model: Clean and standardize raw order data
select
    order_id,
    customer_id,
    product,
    amount,
    order_date,
    current_timestamp as created_at
from {{ seed('raw_orders') }}
where order_id is not null
