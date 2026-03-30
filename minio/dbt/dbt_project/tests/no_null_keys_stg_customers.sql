-- Test: Ensure no null primary keys in stg_customers
select count(*) as record_count
from {{ ref('stg_customers') }}
where customer_id is null
having count(*) > 0
