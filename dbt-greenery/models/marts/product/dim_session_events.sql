{{
  config(
    materialized='table'
  )
}}

{%
    set events_types = [
        'delete_from_cart'
        , 'checkout'
        , 'page_view'
        , 'add_to_cart'
        , 'package_shipped'
        , 'account_created'
        , 'referral'
    ]
%}

SELECT
    session_guid
    , user_guid
    {% for event_type in event_types %}
    , sum(case when event_type = '{{event_type}}' then 1 else 0 end) AS {{event_type}}
    {% endfor %}
FROM {{ ref('stg_events')}}

{{dbt_utils.group_by(2)}}
