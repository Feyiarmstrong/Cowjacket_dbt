with source_data as (
    select *
    from {{ source('cowjacket_raw', 'order_items') }}
)

select
    order_item_id,
    order_id,
    product_id,
    quantity,
    line_total
from source_data