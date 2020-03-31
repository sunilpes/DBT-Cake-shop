{{
  config(materialized = "table", sort="orders_placed")
}}

# Jinja2 - Python Library

with customers as (
	select id as customer_id, last_name, first_name, email  from {{ source('dbt_cake_shop', 'customers') }}
),
orders as (
	select user_id as customer_id, order_date, status from {{ source('dbt_cake_shop', 'orders') }} where status = 'placed'
),
final as (
	select customers.customer_id as customer_id , 
		customers.first_name as first_name, 
		customers.last_name as last_name, 
		count(orders.customer_id) as orders_placed
	from orders, customers 
	where orders.customer_id = customers.customer_id 
	group by customers.customer_id, customers.first_name, customers.last_name
)

select * from final

