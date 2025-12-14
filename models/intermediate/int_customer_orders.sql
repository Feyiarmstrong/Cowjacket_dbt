with order_details as (
    select *
    from {{ ref('int_order_details') }}
),
customers as (
    select *
    from {{ ref('stg_customers') }}
)
select
    od.order_id,
    od.customer_id,
    c.full_name,
    c.email,
    od.product_id,
    od.quantity,
    od.line_total,
    od.order_date
from order_details od
left join customers c
    on od.customer_id = c.customer_id
