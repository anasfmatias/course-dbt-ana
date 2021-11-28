{{
  config(
    materialized='table'
    , unique_key = 'product_guid'
  )
}}


SELECT 
  product_id
  , product_guid
  , name             as product_name    
  , price            as product_price   
  , quantity         as product_stock_count             
FROM {{ ref('stg_products')}}
