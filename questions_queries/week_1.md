## How many users do we have?
Ans: We have a total of 130 users.

'''sql
select count(distinct user_id)
from users;
'''

## On average, how many orders do we receive per hour?
Ans: We receive an average of 8 orders per hour.
'''sql
with orders_by_hour as (
  select date_part('doy', created_at) as dof
    , date_part('hour', created_at) as hod
    , count(distinct order_id) as orders_hour
  from orders
  where created_at is not null
  group by 1, 2
  )
select avg(orders_hour)
from orders_by_hour
'''

## On average, how long does an order take from being placed to being delivered?
Ans: 3 days and 22hours
'''sql
with delivery_orders as (
  select (delivered_at - created_at) as delivery_time
  from orders
  where status = 'delivered'
  )
  select avg(delivery_time)
  from delivery_orders
'''


## How many users only made one purchase? Two purchases? Three + purchases?

Ans: 25 users only made one purchase, 22 users do two purchases, 81 users do three or more purchases.

one_purchase | two_purchases | three_more_purchases
-------------|---------------|---------------------
    25       |       22      |         81

'''sql
with total_orders as (
  select user_id, count( distinct order_id) as orders
  from orders_hour
  group by 1
  )
  select
    count (distinct case when orders = 1 then user_id else null end) as one_purchase
    , count (distinct case when orders = 2 then user_id else null end) as two_purchases
    , count (distinct case when orders > 2 then user_id else null end) as three_more_purchases
  from total_orders;
'''

## On average, how many unique sessions do we have per hour?

Ans: On average he have 7 sessions per hour.

'''sql
with sessions_hour as (
  select
    date_trunc('hour', created_at) as hour_session
    , count(distinct session_id) as total_hour_sessions
    from events
    where created_at is not null
    group by 1
  )
  select avg(total_hour_sessions) as avg_session_hour
  from sessions_hour;
  '''
