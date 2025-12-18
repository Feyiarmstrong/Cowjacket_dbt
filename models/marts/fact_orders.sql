{{ config(
    materialized='table',
    schema='dbt_production' if target.name == 'production' else target.schema
) }}

{% if target.name != 'production' and config.get('schema') == 'dbt_production' %}
  {{ exceptions.raise_compiler_error("dbt_production is PROD-ONLY") }}
{% endif %}

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
