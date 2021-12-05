{{
  config(
    materialized='table'
    , unique_key = 'user_guid'
  )
}}

SELECT DISTINCT
    user_guid
    , first_name
    , last_name
    , email
    , phone_number                                           
    , zipcode
    , address
    , state
    , country
FROM {{ ref('stg_users')}} u
LEFT JOIN {{ ref('stg_addresses')}} a
    USING(address_guid)