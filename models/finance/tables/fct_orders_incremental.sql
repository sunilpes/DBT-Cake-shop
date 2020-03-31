{{
	config(materialized='incremental')
}}

select * from {{ ref('fct_orders') }} 

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where order_date = '2018-01-{{ range(10, 30) | random }}'

{% endif %}

-- The is_incremental() macro will return True if:

-- the destination table already exists in the database
-- dbt is not running in full-refresh mode (dbt run --full-refresh --models fct_orders_incremental)
-- the running model is configured with materialized='incremental'
