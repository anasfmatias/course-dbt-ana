{{
  config(
    materialized='table'
    , unique_key = 'user_guid'
  )
}}


SELECT DISTINCT
     user_guid
    , count(order_guid)                                           as total_orders_count 
    , sum(order_cost)                                             as total_value_spent
    , min(order_created_at_utc)                                   as first_purchase_date
    , case when count(order_guid) > 1 then 1
        else 0 end                                                as is_repeated_customer
FROM {{ ref('stg_orders')}}
GROUP BY 1