{{
    config(
        materialized = 'table'
        )
}}

WITH products_convertion_rate AS (
    SELECT
        p.product_name
        , o.product_guid
        , round((
            count(distinct order_guid)::decimal
            /
            (
                select count(distinct session_guid)
                from {{ ref('stg_events') }}
                where split_part(page_url, '/', 5) = o.product_guid
            )::decimal
        ) * 100, 2) as product_convertion_rate
    FROM {{ ref('stg_order_items') }} o
    JOIN {{ ref('dim_products') }} p
        USING(product_guid)
    GROUP BY 1, 2
)
select *
from products_convertion_rate