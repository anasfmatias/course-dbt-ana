{{
  config(
    materialized='table'
    , unique_key = 'address_id'
  )
}}

with addresses_source as (
    select * from {{ source('tutorial', 'addresses')}}
)
, renamed_casted as (
    select
        address_id
        , address_id        as address_guid           
        , address
        , zipcode
        , state
        , country
    from addresses_source
)
select * from renamed_casted