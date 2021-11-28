{{
  config(
    materialized='table'
    , unique_key = 'order_id'
  )
}}

SELECT 
    o.order_id
    , o.order_guid
    , o.promo_guid           
    , o.user_guid
    , o.address_guid
    , o. order_created_at_utc
    , o.order_cost
    , o.shipping_cost
    , o.order_total
    , o.tracking_guid
    , o.shipping_service
    , o.estimated_delivery_at_utc
    , o.delivered_at_utc
    , o.status                     as order_status 
    , i.product_guid
    , i.quantity                   as unique_product_count
    , p.discount
    , p.status                     as promo_status
FROM {{ref('stg_orders')}} o
LEFT JOIN {{ref('stg_order_items')}} i
    ON o.order_guid = i.order_guid
    LEFT JOIN {{ref('stg_promos')}} p
        ON o.promo_guid = p.promo_guid