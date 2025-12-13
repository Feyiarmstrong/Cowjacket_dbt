with source_data as (
    select *
    from {{ source('cowjacket_raw', 'orders') }}
)

select
    order_id,
    customer_id,
    order_date,
    total_amount
from source_data