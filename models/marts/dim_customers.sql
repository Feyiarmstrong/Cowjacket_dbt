{{ config(
    materialized='table',
    schema='analytics_marts' if target.name == 'production' else target.schema
) }}

{% if target.name != 'production' and config.get('schema') == 'analytics_marts' %}
  {{ exceptions.raise_compiler_error("analytics_marts is PROD-ONLY") }}
{% endif %}


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
