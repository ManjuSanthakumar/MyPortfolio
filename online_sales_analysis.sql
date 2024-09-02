/* --------------------
   Case Study Questions
   --------------------*/
   --1.most sold category of products
   --2.most sold product in electronic category
   --3.Month with highest revenue
   --4.For each category which month had highest sales
   
select * from df_orders;
select * from df_details;

--most sold category of products
with cte as(
select category,sum(amount),rank() over (order by sum(amount) desc) as n
from df_details
group by category
)
select category from cte
where n=1;

--most sold product in electronic category
with cte as (
select sub_category, sum(amount),
rank() over ( order by sum(amount) desc) as n
from df_details
where category='Electronics'
group by sub_category)
select sub_category
from cte
where n=1;

--Month with highest revenue
with cte as (
select (extract(month from o.order_date)) as month,
sum(d.amount) as total,
rank () over(order by sum(d.amount) desc) as n
from df_orders o
JOIN df_details d ON
o.order_id=d.order_id
group by extract (month from o.order_date)
)select to_char(to_date(month,'MM'),'Month')as Month from cte
where n=1;

--For each category which month had highest sales
with cte as (
select d.category as category, (extract(month from o.order_date)) as month,
sum(d.amount) as total,
rank () over(partition by category order by sum(d.amount) desc) as n
from df_orders o
JOIN df_details d ON
o.order_id=d.order_id
group by d.category,extract (month from o.order_date)
)select category, to_char(to_date(month,'MM'),'Month')as Month from cte
where n=1; 


