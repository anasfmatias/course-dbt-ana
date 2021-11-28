{{
  config(
    materialized='table'
    , unique_key = 'user_guid'
  )
}}

SELECT DISTINCT
    u.user_guid
    , u.first_name
    , u.last_name
    , u.email
    , u.phone_number                                           
    , u.created_at_utc                                              as user_created_at_utc
    , u.updated_at_utc                                              as user_updated_at_utc
    , u.created_at_utc - current_date                               as customer_tenure
    , u.address_guid
    , a.zipcode
    , a.address
    , a.state
    , a.country
FROM {{ ref('stg_users')}} u
LEFT JOIN {{ ref('stg_addresses')}} a
    USING(address_guid)