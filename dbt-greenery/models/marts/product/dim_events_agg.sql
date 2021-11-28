{{
  config(
    materialized='table'
  )
}}

SELECT 
    user_guid
    , COUNT(DISTINCT session_guid)                                                        AS total_sessions
    , COUNT(DISTINCT case when event_type = 'add_to_cart' then event_guid end)            AS total_add_cart
    , COUNT(DISTINCT case when event_type = 'page_view' then event_guid end)              AS total_page_view
    , COUNT(DISTINCT case when event_type = 'delete_from_cart' then event_guid end)       AS total_delet_from_cart
    , COUNT(DISTINCT case when event_type = 'total_checkout' then event_guid end)         AS total_checkout
    , COUNT(DISTINCT case when event_type = 'package_shipped'then event_guid end)         AS total_package_shipped
FROM {{ ref('stg_events')}}
GROUP BY 1