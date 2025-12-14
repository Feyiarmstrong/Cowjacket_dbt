with loyalty as (
    select *
    from {{ ref('stg_loyalty_points') }}
)
select
    customer_id,
    sum(points_earned) as total_points,
    max(transaction_date) as last_transaction_date
from loyalty
group by customer_id