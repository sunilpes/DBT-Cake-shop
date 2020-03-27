
with orders as (
	select count(*) as order_count from {{ source('dbt_cake_shop', 'orders') }} where status = 'placed'
),
final as (
	select count(*) as total_count from {{ ref('total_order_by_customer') }}
),
row_count as (
	select (order_count - total_count) as count from final, orders
)

select * from row_count where count != 0