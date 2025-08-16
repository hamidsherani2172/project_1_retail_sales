--create table
drop table if exists retail_sales;
create table retail_sales
		(			
			transactions_id	int primary key,
			sale_date date,
			sale_time time,
			customer_id	int,
			gender varchar(15),
			age	int,
			category varchar(15),	
			quantiy	int,
			price_per_unit float,	
			cogs float,
			total_sale float
		);

select * from retail_sales;
select count(*) from retail_sales;



--Exploration & Cleaning
--How many customers do we have?
select count(distinct customer_id) from retail_sales;

--How many categories do we have?
select distinct category from retail_sales;

--Cleaning
select * from retail_sales
where 
    sale_date is null
	or sale_time is null
	or customer_id is null  
    or gender is null
	or age is null
	or category is null 
    or quantiy is null
	or price_per_unit is null
	or cogs is null;

delete from retail_sales
where 
    sale_date is null
	or sale_time is null
	or customer_id is null  
    or gender is null
	or age is null
	or category is null 
    or quantiy is null
	or price_per_unit is null
	or cogs is null;
	

--BUSINESS PROBLEMS AND THEIR ANSWERS

--1)Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date = '2022-11-05';

--2)Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales
	where 
	category = 'Clothing'
	and
	quantiy >= 4
	and
	to_char(sale_date, 'YYYY-MM') = '2022-11';

--3)Write a SQL query to calculate the total sales (total_sale) for each category.:
select 
	category,
	sum (total_sale) as total_sales,
	count(*) as total_orders
	from retail_sales
group by 1;

--4)Write a SQL query to find the average age of customers who purchased 
--items from the 'Beauty' category.:
select round(avg(age), 2) as avg_age from retail_sales where category = 'Beauty';

--5)Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales where total_sale > 1000;

--6)Write a SQL query to find the total number of transactions 
--(transaction_id) made by each gender in each category.:
select category, gender, count(*) from retail_sales
group by 1,2
order by 1;
 

--7)Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year:
select year, month, avg_sale from
		(
			select 
				extract (Year from sale_date) as Year,
				extract (Month from sale_date) as Month,
				avg(total_sale) avg_sale,
				rank() over(partition by extract (Year from sale_date) order by avg(total_sale) desc) as rank
				from retail_sales
				group by 1, 2 
		)	as t1
where rank = 1;


--8)Write a SQL query to find the top 5 customers based on the highest total sales **:
--select * from retail_sales order by total_sale desc limit 5;
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;


--9)Write a SQL query to find the number of unique customers who purchased 
--items from each category.:
select count(distinct customer_id) from retail_sales;
select 
	category,
	count(distinct customer_id) as cnt_unique
	from retail_sales
group by 1;

--10)Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select * from retail_sales;

With hourly_sale
as
(
select *,
	case
		when extract (hour from sale_time) < 12 then 'Morning'
		when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)

select shift, count(*) as total_orders from hourly_sale
group by shift;
--select extract(hour from current_time);

--End of project
