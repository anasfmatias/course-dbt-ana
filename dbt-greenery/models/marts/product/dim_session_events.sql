
{{
  config(
    materialized='view'
  )
}}

{% set event_types = [ 
    'delete_from_cart'
    ,'checkout'
    ,'page_view'
    ,'add_to_cart'
    ,'package_shipped'
    ,'account_created'
]
%}

WITH all_events AS (

                SELECT  *
                FROM {{ref('stg_events')}} 
                WHERE events_created_at_utc IS NOT NULL )

, products AS ( SELECT  *
                FROM {{ref('stg_products')}}  )

, first_user AS (SELECT 
                      DISTINCT session_guid
                      , FIRST_VALUE(user_guid) OVER (PARTITION BY session_guid ORDER BY events_created_at_utc ROWS between unbounded preceding and unbounded following ) as user_guid -- sessions have multiple users ( data qyality issue)
                FROM all_events AS ev)
SELECT 
       ev.session_guid
     , events_created_at_utc::date as event_date
     , u.user_guid 
       {%for event_type in event_types %}
     , SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) as {{event_type}}_events
      {%endfor%}

FROM all_events AS ev
JOIN first_user u ON ev.session_guid = u.session_guid
{{dbt_utils.group_by(3)}}