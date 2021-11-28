#(Part 1) Models
## What is our user repeat rate?
### repeat rate = users who purchased 2 or more times/users who purchased
Ans: Repeated rate 80%

```sql
--total users
select count(distinct user_id) from dbt_ana.stg_orders where order_id is not null;
-- #128

--repeated users (purchases more than once)
with repeated_users as (
  select user_id, count(order_id) as order_count
  from dbt_ana.stg_orders
  group by 1
  having count(order_id) > 1
)
select count(*)
from repeated_users;
-- # 103
```

## What are good indicators of a user who will purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Customers that would have a good experience would be more likely to return to the website and buy again. For example, estimated delivery date be accurate, number of users that go all the way through the funnel, page view -> add_to_cart ->total checkout -> package shipped.
Also customers that purchase the have more than one order are probably more likely to buy again and be converted in regular customers.
A bad experience could indicate low probability of returning, like customer that didn't visit the website for a long time, customer that has low engagements (low number of sessions). Some metrics that could be used to predict if a user would return would be time since the last purchase, frequency of purchase, if the customer only order promotional items and it's just a seasonal customer.

## Marts folder was created to help answering the questions of the stakeholders in the business. The folder it's organised on the following fashion:
  * Core:
    - int_users
    - dim_products
    - dim_users
    - fact_orders
  * Marketing:
    - fact_user_orders
  * Product:
    - dim_events_avg
    - fact_page_views

### Why the did we organise the models in the way we did?
The model in organised in two main blocks, staging and marts. On the staging block every source has a staging model which is in 1:1 with a source, without complex logic or joint.
Marts the other main models directory stores intermediate and dim/facts models. It's split between core, marketing and products. Core folder contains the centric data of the whole business in a most granular level. They can be used as 'source of intermediate tables in another tables.
In this tables we can have intermediate models that started with int_, dim_ models or fact_ models. Intermediate tables are used to apply business logic and aggregation and contain the granularity in each unit's folder. In this case I created one intermediate model 'int_user' because it made sense to have all the user personal data together. Fact_ and Dim_ tables are usually exposed to the end users. Some of them have been applied aggregation and therefore have lost some granularity of information Their purpose is to answer some business questions.

### Dag image
<p align="center"><img src="images/dag.png" width="800"></p>


## What assumptions are your making about each model? (i.e. why are you adding each test?)
The maining tests are in staging model. I want to make sure that I don't have any duplicated data, don't have events that happen in the future, no negative orders or no null values in the the key parameters.

## Did you find any bad data?
No.
