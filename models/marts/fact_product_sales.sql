select
    p.product_id,
    p.product_name,
    p.category,
    sum(od.quantity) as total_quantity_sold,
    sum(od.line_total) as total_revenue
from {{ ref('int_order_details') }} od
join {{ ref('stg_products') }} p
    on od.product_id = p.product_id
group by
    p.product_id,
    p.product_name,
    p.category