select
    c.customer_id,
    c.full_name,
    c.email,
    c.join_date,
    coalesce(l.total_points, 0) as total_loyalty_points,
    l.last_transaction_date
from {{ ref('stg_customers') }} c
left join {{ ref('int_loyalty_summary') }} l
    on c.customer_id = l.customer_id