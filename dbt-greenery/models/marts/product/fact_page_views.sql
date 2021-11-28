{{
  config(
    materialized='table'
  )
}}

SELECT *
FROM {{ ref('stg_events')}}
WHERE event_type = 'page_view'
