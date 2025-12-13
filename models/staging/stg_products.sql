with source_data as (
    select *
    from {{ source('cowjacket_raw', 'products') }}
)

select
    product_id,
    product_name,
    category,
    price
from source_data