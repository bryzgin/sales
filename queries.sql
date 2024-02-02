/* customers_count.csv */
select count(distinct c.customer_id) as customers_count
from customers as c;

/* top_10_total_income.csv */
select
    concat(e.first_name, ' ', e.last_name) as name,
    count(distinct s.sales_id) as operations,
    floor(sum(s.quantity * p.price)) as income
from employees as e
inner join sales as s
    on e.employee_id = s.sales_person_id
inner join products as p
    on s.product_id = p.product_id
group by concat(e.first_name, ' ', e.last_name)
order by income desc
limit 10;

/* lowest_average_income.csv */
select
    concat(e.first_name, ' ', e.last_name) as name,
    floor(avg(s.quantity * p.price)) as average_income
from employees as e
inner join sales as s
    on e.employee_id = s.sales_person_id
inner join products as p
    on s.product_id = p.product_id
group by concat(e.first_name, ' ', e.last_name)
having
    floor(avg(s.quantity * p.price))
    < (
        select avg(s.quantity * p.price)
        from sales as s
        inner join products as p
            on s.product_id = p.product_id
    )
order by average_income;

/* day_of_the_week_income.csv */
select
    concat(e.first_name, ' ', e.last_name) as name,
    to_char(s.sale_date, 'day') as weekday,
    floor(sum(s.quantity * p.price)) as income
from employees as e
inner join sales as s
    on e.employee_id = s.sales_person_id
inner join products as p
    on s.product_id = p.product_id
group by
    concat(e.first_name, ' ', e.last_name),
    to_char(s.sale_date, 'id'),
    to_char(s.sale_date, 'day')
order by to_char(s.sale_date, 'id');

/* age_groups.csv */
select
    case
        when c.age between 16 and 25 then '16-25'
        when c.age between 25 and 40 then '26-40'
        else '40+'
    end as age_category,
    count(*) as count
from customers as c
group by age_category
order by age_category;

/* customers_by_month.csv */
select
    to_char(s.sale_date, 'YYYY-MM') as date,
    count(distinct s.customer_id) as total_customers,
    floor(sum(s.quantity * p.price)) as income
from sales as s
inner join products as p
    on s.product_id = p.product_id
group by to_char(s.sale_date, 'YYYY-MM')
order by to_char(s.sale_date, 'YYYY-MM');

/* special_offer.csv */
select distinct on (c.customer_id)
    concat(c.first_name, ' ', c.last_name) as customer,
    min(s.sale_date) as sale_date,
    concat(e.first_name, ' ', e.last_name) as seller
from customers as c
inner join sales as s
    on c.customer_id = s.customer_id
inner join employees as e
    on s.sales_person_id = e.employee_id
inner join products as p
    on s.product_id = p.product_id
group by
    concat(c.first_name, ' ', c.last_name),
    concat(e.first_name, ' ', e.last_name),
    c.customer_id
having sum(p.price) = 0
order by c.customer_id;
