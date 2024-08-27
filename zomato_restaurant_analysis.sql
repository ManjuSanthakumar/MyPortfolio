/* --------------------
   Case Study Questions
   --------------------*/
   --1.what type of restaurant do the majority of customers order from?
   --2.How many votes has each type of restaurant received from customers?
   --3.What are the ratings that majority of restuarants have received?
   --4.Which mode (online/offline) has received maximum rating?
   --5.Which type of restaurant received more offline order, so zomato can provide customer with good offer
   
select * from zomato_data;

--what type of restaurant do the majority of customers order from?
with cte as
(select restaurant_type,rank() over( order by count(id) desc) n
from zomato_data
group by restaurant_type
)
select restaurant_type
from cte
where n=1;

--How many votes has each type of restaurant received from customers?
select restaurant_type,sum(num_of_ratings)
from zomato_data
group by restaurant_type
order by sum(num_of_ratings) desc;

--What are the ratings that majority of restuarants have received?
select restaurant_type,max(rating)
from zomato_data
group by restaurant_type
order by max(rating) desc;

--Which mode (online/offline) has received maximum rating?
select max(rating), order_mode
from
(select rating,
CASE 
when online_order='Yes' then 'online'
Else 'offline' 
END as order_mode
from zomato_data)
group by order_mode;

--Which type of restaurant received more offline order, so zomato can provide customer with good offer
with cte as
(select restaurant_type,order_mode,
rank() over(order by count(id) desc) n,count(id)
from
(select id,restaurant_type,
CASE 
when online_order='Yes' then 'online'
Else 'offline' 
END as order_mode
from zomato_data
)
where order_mode='offline'
group by restaurant_type,order_mode
)
select restaurant_type, order_mode
from cte
where n=1
;
