{{
  config(
    materialized='table'
    , unique_key = 'product_guid'
  )
}}


SELECT 
  product_guid
  , name             as product_name    
  , quantity         as product_in_stock            
FROM {{ ref('stg_products')}}
