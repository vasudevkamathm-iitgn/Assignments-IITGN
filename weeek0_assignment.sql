-- Question 1
-- event_id, store_id, campaign_id, product_code, base_price, promo_type, quantity_sold(before_promo), quantity_sold(after_promo)
select 
	event_id as EventID,
    product_code as ProductNumber,
    store_id as StoreNumber,
    product_code as ProductNumber,
	base_price as BasePrice,
     promo_type as Promotion_types
from fact_events 
where base_price >1000;

-- Question 02

select 
	event_id as EventID,
    product_code as ProductNumber,
	promo_type as Promotion_types,
    `quantity_sold(before_promo)`as sales_before,
    `quantity_sold(after_promo)`as sales_after
from fact_events 
where `quantity_sold(after_promo)` >100
Order By `quantity_sold(after_promo)` desc;

-- Question 03

select distinct promo_type as Promotion_types
from fact_events ;

-- Question 04

select
count(event_id) as TotalEvents,
sum(`quantity_sold(before_promo)`)as total_sales_before,
sum(`quantity_sold(after_promo)`) as total_sales_after,
avg(base_price) as AVgBasePrice,
max(base_price) as maxBasePrice,
min(base_price) as minBasePrice
from fact_events;

-- Question 05

select 
	promo_type as Promotion_types,
	count(event_id) as NumberofEvents,
    sum(`quantity_sold(before_promo)`)as total_sales_before,
	sum(`quantity_sold(after_promo)`) as total_sales_after
from fact_events
group by promo_type
order by total_sales_after desc;

-- Question 06

select 
	promo_type as Promotion_types,
    sum(`quantity_sold(before_promo)`)as total_sales_before,
	sum(`quantity_sold(after_promo)`) as total_sales_after,
    sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`) as quantity_change
from fact_events
group by promo_type
order by quantity_change desc;

-- Question 07

-- event_id, store_id, campaign_id, product_code, base_price, 
-- promo_type, quantity_sold(before_promo), quantity_sold(after_promo)

-- product_code, product_name, category

select 
	f.product_code as ProductNumber,
    d.product_name as ProductName,
    d.category as Category,
sum(f.`quantity_sold(after_promo)`) as total_sales_after,

from fact_events as f
join dim_products as d  on f.product_code =d.product_code
group by f.product_name
order by  total_sales_after desc;

-- Question 08

-- event_id, store_id, campaign_id, product_code, base_price, 
-- promo_type, quantity_sold(before_promo), quantity_sold(after_promo)


select
 d.category as Category,
count(f.event_id) as Number_of_events,
sum(f.`quantity_sold(before_promo)`)as total_sales_before,
sum(f.`quantity_sold(after_promo)`) as total_sales_after,
(sum(f.`quantity_sold(after_promo)`) - sum(f.`quantity_sold(before_promo)`)) as Quality_change
from fact_events as f
join dim_products as d  on f.product_code =d.product_code
group by d.category
order by  total_sales_after desc;

-- Question 09

use retail_events_db;
select 
d.city as city ,
count(f.event_id) as total_event,
sum(f.`quantity_sold(before_promo)`) as before_promo ,
sum(f.`quantity_sold(after_promo)`) as after_promo
from retail_events_db.fact_events as f
join retail_events_db.dim_stores as d on f.store_id=d.store_id
group by d.city 
order by d.city  desc;

-- Question 10

use retail_events_db;
select 
c.campaign_name as Name,
c.start_date as `starting date`,
c.end_date as `End date`,
count(f.event_id) as total_event,
sum(f.`quantity_sold(before_promo)`) as before_promo ,
sum(f.`quantity_sold(after_promo)`) as after_promo
from  fact_events as f
join dim_campaigns as c on f.campaign_id=c.campaign_id
group by f.campaign_id
order by sum(f.`quantity_sold(after_promo)`) desc;

-- Question 11

select 
p.category as Category,
sum(f.`quantity_sold(after_promo)`) as after_promo,
avg(f.base_price) as Avg_Price
from fact_events as f
join dim_products as p on f.product_code=p.product_code
group by p.category
having after_promo > 1000
order by sum(f.`quantity_sold(after_promo)`) desc;

-- Question 12

-- event_id, store_id, campaign_id, product_code, base_price, promo_type, quantity_sold(before_promo), quantity_sold(after_promo)
-- store_id, city
-- product_code, product_name, category

select 
	s.city as city,
	p.category,
    sum(f.`quantity_sold(after_promo)`)
from fact_events as f
left join dim_stores as s on f.store_id=s.store_id
left join dim_products as p on f.product_code=p.product_code
group by s.city,p.category
order by s.city desc,sum(f.`quantity_sold(after_promo)`) desc;

-- Question 13 

-- product_code, product_name, category
-- event_id, store_id, campaign_id, product_code, base_price, promo_type, quantity_sold(before_promo), quantity_sold(after_promo)
select 
p.product_name as ProductName,
p.category as Category,
sum(f.`quantity_sold(before_promo)`) as before_promotion,
sum(f.`quantity_sold(after_promo)`) as afterpromotion,
sum(f.`quantity_sold(after_promo)`)-sum(f.`quantity_sold(before_promo)`) as qualityChange,
(sum(f.`quantity_sold(after_promo)`)-sum(f.`quantity_sold(before_promo)`))/nullif(sum(f.`quantity_sold(before_promo)`),0) * 100 as percentage
from fact_events as f
join dim_products as p on f.product_code=p.product_code
group by p.product_code,p.product_name, p.category
order by percentage desc;
    
    
-- Question 14

-- campaign_id, campaign_name, start_date, end_date

-- event_id, store_id, campaign_id, product_code, base_price,
-- promo_type, quantity_sold(before_promo), quantity_sold(after_promo)

use retail_events_db;
select 
p.campaign_name as CampaignName,
f.promo_type as Type,
count(f.event_id) as EventCount,
sum(f.`quantity_sold(before_promo)`) as beforepromotion,
sum(f.`quantity_sold(after_promo)`) as afterpromotion,
sum(f.`quantity_sold(after_promo)`)-sum(f.`quantity_sold(before_promo)`) as qualityChange
from fact_events as f
join dim_campaigns as p on f.campaign_id=p.campaign_id
group by p.campaign_name,f.promo_type
order by p.campaign_name desc,qualityChange desc;

-- Question 15

-- product_code, product_name, category

select 
p.product_name as Name,
p.category as Category,
sum((f.base_price) * f.`quantity_sold(before_promo)`) as revenue_before,
sum((f.base_price) * f.`quantity_sold(after_promo)`) as revenue_after,
sum(f.base_price * f.`quantity_sold(after_promo)`)- sum(f.base_price * f.`quantity_sold(before_promo)`) AS revenue_difference
from fact_events as f
join dim_products as p on f.product_code=p.product_code
group by p.product_code, p.product_name, p.category
order by revenue_difference desc;

-- The rule: every column in the SELECT that isn't inside SUM/COUNT/etc. must also be in the GROUP BY.

-- Question 16

