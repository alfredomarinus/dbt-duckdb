-- Test: Ensure no null primary keys in stg_orders
select count(*) as record_count
from {{ ref('stg_orders') }}
where order_id is null or customer_id is null
having count(*) > 0
