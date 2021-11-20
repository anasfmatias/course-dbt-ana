{{
  config(
    materialized='table'
    , unique_key = 'product_id'
  )
}}

with products_source as (
    select * from {{ source('tutorial', 'products')}}
)
, renamed_casted as (
    select
        product_id
        , product_id        as product_guid
        , name         
        , price
        , quantity
    from products_source
)
select * from renamed_casted