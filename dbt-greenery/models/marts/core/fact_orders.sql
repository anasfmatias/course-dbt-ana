{{
  config(
    materialized='table'
    , unique_key = 'order_guid'
  )
}}

SELECT 
    order_guid
    , user_guid           
    , order_created_at_utc
    , order_cost
    , order_total
    , shipping_cost
    , shipping_service
    , tracking_guid
    , estimated_delivery_at_utc
    , delivered_at_utc
    , status                       as order_status 
    , count(product_guid)            as product_count
FROM {{ref('stg_orders')}}
LEFT JOIN {{ref('stg_order_items')}}
  Using(order_guid)
{{ dbt_utils.group_by(n=11) }}


