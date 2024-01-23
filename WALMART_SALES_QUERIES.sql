create database if not exists salesDataWalmart;
create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12, 4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,2) not null,
    rating float(2,1)
);

-- -----------------------------| FEATURE ENGINEERING |---------------------------------------------

-- ------------
-- time_of_day |
-- ------------

select
	time,
	case 
		when time between "00:00:00" and "12:00:00" then "Morning"
		when time between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening"
	end as time_of_day
	from sales;
    
    alter table sales add column time_of_day varchar(20);
    update sales
    set time_of_day = (
    case 
		when time between "00:00:00" and "12:00:00" then "Morning"
		when time between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening"
	end
    );
    
    
    -- ---------
    -- day name |
    -- ---------
    
    
  select
	date,
	dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(20);

update sales
set day_name = dayname(date);


-- -----------
-- month_name |
-- -----------


select
	date,
    monthname(date) as month_name
from sales;

alter table sales add column month_name varchar(20);

update sales
set month_name = monthname(date);


-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------| GENERIC |---------------------------------------------


-- how many unique cities does the data have ?

 select
	distinct city
from sales;

-- In which city each branch present ?

 select
	distinct branch
from sales;

select
	distinct city,
    branch 
from sales;

-- -----------------------------------------------------------------------------------------------------------
-- -------------------------------------------------| PRODUCT |-----------------------------------------------


-- How many unique product lines does the data have ?

select 
	distinct product_line
from sales;

-- What is the most common payment method ?

select
	payment_method,
	count(payment_method) as no_of_transaction
from sales
group by payment_method
order by no_of_transaction desc ;
    
-- What is the most selling product line ?

select
	product_line,
	count(product_line) as cnt
from sales
group by product_line
order by cnt desc ;

-- What is the total revenue by month ?

select 
	month_name as month,
    sum(total) as total_revenue
from sales
    group by month
    order by total_revenue desc ;
    
-- What month had the largest cogs ?
    
select
	month_name as month,
    sum(cogs) as cogs
from sales
group by month 
order by cogs desc;

--  What product line had the largest revenue ?

select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue ?

select
	branch,
	city,
    sum(total) as total_revenue
from sales
group by branch, city
order by total_revenue desc;

-- What product line had the largest VAT ?

select
	product_line,
	sum(VAT) as tax
from sales
group by product_line
order by tax desc ;

-- Which branch sold more products than average product sold ?

select
	branch,
    sum(quantity) as qty
from sales 
group by branch
having qty > avg(quantity) ;

-- What is the most common product line by gender ?

select 
	gender,
    product_line,
    count(gender) as gender_cnt
from sales
group by gender, product_line 
order by gender_cnt desc;

-- What is the average rating of each product line ?

select
	product_line,
    round(avg(rating), 2) as avg_rating
from sales 
group by product_line;
 

-- Fetch each product line and add a column to those product line showing "Good", "bad". Good if its greater than average sales.

select 
	round(avg(total),2) as avg_total
from sales;

select
	product_line,
	case
		when avg(total) >= 322.50 then "Good"
        else  "Bad"
    end as remark
from sales
group by product_line;

    

-- -------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------| SALES |------------------------------------------------------------------
    
    -- No of sales made in each time of the day per weekday 
    
    select
		time_of_day,
        count(*) as total_sales
	from sales
    where day_name = "Monday"
    group by time_of_day
    order by total_sales desc ;
    
    -- Which of the customer types brings the most revenue ?
    
    select 
		customer_type,
        round(sum(total), 2) as rev
	from sales
    group by customer_type
    order by rev desc ;
    
    -- Which city has their largest tax percent/ VAT (Value Added Tax) ?
    
    select 
		city,
        round(sum(VAT), 2) as total_tax
	from sales 
    group by city
    order by total_tax desc;
    
    -- Which customer type pays the most in VAT ?
    
    select 
		customer_type,
        round(avg(VAT),1) as total_tax_paid
	from sales
    group by customer_type
    order by total_tax_paid desc ;
    
    -- --------------------------------------------------------------------------------------------------
    -- ---------------------------------------| CUSTOMER |---------------------------------------------------
    
    
    -- How many unique costomer types does the data have ?
    select 
		distinct customer_type 
	from sales;
    
    -- How many unique payment methods does the data have ?
    
    select 
		distinct payment_method
	from sales;
    
    -- What is the most common customer type /  Which customer type buys the most ?
    
    select 
		customer_type,
        count(*) as cust_cnt
	from sales 
    group by customer_type 
    order by cust_cnt desc;
    
    -- What is the gender of most of the customers ?
    
    select
		gender,
        count(*) as gend_cnt
	from sales
    group by gender
    order by gend_cnt desc ;
    
    -- What is the gender distribution per branch ?
    
    select 
		 gender,
         count(*) as cnt
	from sales 
    where branch = "A"
    group by gender
    order by cnt desc ;
    
    -- Which time of the day that customers give most ratings (out of 10) ?
    
    select
		time_of_day,
        avg(rating) as avg_rtng
	from sales 
    group by time_of_day
    order by avg_rtng desc ;
    
    -- Which time of the day that customers give most ratings per branch ?
    
      select
		time_of_day,
        avg(rating) as avg_rtng
	from sales 
    where branch = "B"
    group by time_of_day
    order by avg_rtng desc ;
    
    -- Which day of the week has the best avg rating ?
    
     select
		day_name,
        avg(rating) as avg_rtng
	from sales 
    group by day_name 
    order by avg_rtng desc ;
    
    -- Which day of the week has the best avg rating per branch ?
    
       select
		day_name,
        avg(rating) as avg_rtng
	from sales 
    where branch = "C"
    group by day_name 
    order by avg_rtng desc ;
    
    -- ----------------------------------------| THANK YOU |----------------------------------------