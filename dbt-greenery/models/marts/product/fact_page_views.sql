{{
  config(
    materialized='table'
  )
}}

SELECT
  event_guid
  , events_created_at_utc
  , session_guid
  , user_guid
  , page_url
FROM {{ ref('stg_events')}}
WHERE event_type = 'page_view'
