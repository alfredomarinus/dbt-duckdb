-- Test: Ensure fct_sales has no negative amounts
select count(*) as record_count
from {{ ref('fct_sales') }}
where amount < 0
having count(*) > 0
