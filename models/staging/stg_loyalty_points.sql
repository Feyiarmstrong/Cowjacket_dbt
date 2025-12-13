with source_data as (
    select *
    from {{ source('cowjacket_raw', 'loyalty_points') }}
)

select
    customer_id,
    points_earned,
    transaction_date,
    source
from source_data