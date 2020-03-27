{{
  config(
    materialized = "table",
    post_hook=[
    "CREATE TABLE IF NOT EXISTS {{this.schema}}.audit (total_records INT64, created_on TIMESTAMP, schema STRING, model STRING)",
    "insert into {{this.schema}}.audit (total_records, created_on, schema, model) select count(*) as total_records, current_timestamp() as created_on, \"{{this.schema}}\" as schema, \"{{this.name}}\" as model from {{ this }} "
    ]
  )
}}

{% set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

with orders as (

    select id as order_id, user_id as customer_id, order_date, status from {{ source('dbt_cake_shop', 'orders') }}

),

order_payments as (

    select * from {{ ref('order_payments') }}

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,

        {% for payment_method in payment_methods -%}

        order_payments.{{payment_method}}_amount,

        {% endfor -%}

        order_payments.total_amount as amount

    from orders

    left join order_payments using (order_id)

)

select * from final