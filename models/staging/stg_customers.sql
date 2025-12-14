with source_data as (
    select *
    from {{ source('cowjacket_raw', 'customers') }}
)

select
    customer_id,
    full_name,
    email,
    join_date
from source_data