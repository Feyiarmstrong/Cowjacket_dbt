{{ config(
    materialized='table',
    schema='analytics_marts' if target.name == 'production' else target.schema
) }}

{% if target.name != 'production' and config.get('schema') == 'analytics_marts' %}
  {{ exceptions.raise_compiler_error("analytics_marts is PROD-ONLY") }}
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

