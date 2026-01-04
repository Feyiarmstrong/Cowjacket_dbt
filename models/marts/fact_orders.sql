select
    order_id,
    customer_id,
    full_name,
    email,
    product_id,
    quantity,
    line_total,
    order_date

from {{ ref('int_customer_orders') }}


