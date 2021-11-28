{{
  config(
    materialized='table'
    , unique_key = 'user_id'
  )
}}

WITH users AS(
    SELECT
      user_guid
      , first_name
      , last_name
      , email
      , phone_number
      , address_guid                                         
      , user_created_at_utc
      , user_updated_at_utc
      , customer_tenure                            
      , zipcode
      , address
      , state
      , country
    FROM {{ ref('int_users')}}
)
, order_values AS(
    SELECT DISTINCT
        user_guid
        , count(order_guid)                                           as total_orders_count 
        , sum(order_cost)                                             as total_value_spent
        , min(order_created_at_utc)                                   as first_purchase_date
    FROM {{ ref('stg_orders')}} u
    WHERE status = 'delivered'
    GROUP BY 1
)
, user_orders AS(
    SELECT
        u.user_guid
        , u.first_name
        , u.last_name
        , u.email
        , u.phone_number
        , u.address_guid 
        , u.zipcode
        , u.address
        , u.state
        , u.country
        , u.user_created_at_utc
        , u.user_updated_at_utc
        , u.customer_tenure
        , o.total_orders_count
        , o.total_value_spent
        , o.first_purchase_date - u.user_created_at_utc             as time_first_purchase
    FROM users u
    LEFT JOIN order_values o
    USING(user_guid)
)
SELECT *
FROM user_orders