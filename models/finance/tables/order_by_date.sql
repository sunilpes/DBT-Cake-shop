{{ 
	config(
	    materialized = 'table',
	    partition_by = 'order_date'
	)
}}

select * from {{ source('dbt_cake_shop', 'orders') }}