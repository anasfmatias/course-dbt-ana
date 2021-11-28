{{
  config(
    materialized='table'
    , unique_key = 'event_id'
  )
}}

with events_source as (
    select * from {{ source('tutorial', 'events')}}
)
, renamed_casted as (
    select
        event_id
        , event_id                     as event_guid           
        , session_id                   as session_guid
        , user_id                      as user_guid
        , event_type
        , page_url
        , created_at::timestamp        as events_created_at_utc
    from events_source
)
select * from renamed_casted