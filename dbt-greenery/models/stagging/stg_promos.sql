{{
  config(
    materialized='table'
    , unique_key = 'promo_id'
  )
}}

with promos_source as (
    select * from {{ source('tutorial', 'promos')}}
)
, renamed_casted as (
    select
        promo_id
        , promo_id        as promo_guid
        , discout         as discount
        , status         
    from promos_source
)
select * from renamed_casted