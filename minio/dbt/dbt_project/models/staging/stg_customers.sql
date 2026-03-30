-- Staging model: Clean and standardize raw customer data
select
    customer_id,
    customer_name,
    email,
    country,
    current_timestamp as created_at
from {{ seed('raw_customers') }}
where customer_id is not null
