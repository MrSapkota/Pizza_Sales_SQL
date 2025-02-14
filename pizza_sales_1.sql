Select * from order_details
Select * from orders
Select * from pizza_types
Select * from pizzas
Q1. Retrive the total number of orders placed 

Select max(order_id) AS total_orders
from orders

Q2. Calculate the total revenue from the pizza sales 

SELECT 
    SUM(order_details.quantity * CAST(pizzas.price AS DECIMAL(10, 2))) AS total_sales
FROM 
    order_details
JOIN 
    pizzas ON pizzas.pizza_id = order_details.pizza_id;


Q3. Identify the higest-priced pizza

Select top 1 pizzas.price, pizza_types.name
from pizza_types
join pizzas on  pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc

Q4. Identify the most common pizza size ordered


Select top 1 pizzas.size, COUNT(order_details.order_details_id) as most_common_pizzas_ordered
from pizzas
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size

Q5. List the top 5 most ordered pizzas along with their quantity

Select top 5 pizza_types.name,sum (order_details.quantity) as quantity
from pizza_types
join pizzas on  pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by quantity desc


Q6. Join the necessary tables to find the total quantity of each pizza category ordered.


Select top 5 pizza_types.category,sum (order_details.quantity) as quantity
from pizza_types
join pizzas on  pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc

Q7. Determine the distribution of orders by hour of the day.

Select hour(time) as Hour , count(order_id) as order_count
From orders
group by hour(time)

SELECT 
    DATEPART(HOUR, time) AS Hour, 
    COUNT(order_id) AS order_count
FROM 
    orders
GROUP BY 
    DATEPART(HOUR, time)
ORDER BY 
    Hour;


Q8. Join relevant tables to find the category wise distribution of pizzas

Select category, count(name)
from pizza_types
group by category


Q9. Group the orders by date and calculate the average number of pizzas ordered per day

Select avg(quantity) from
(Select orders.date, sum(order_details.quantity) as Quantity
From orders
Join order_details on order_details.order_id = orders.order_id
group by orders.date) as ordered_quantity


Q10. Determine the top 3 most ordered pizzas types based on revenue

Select top 3 pizza_types.name,sum (order_details.quantity * pizzas.price) as total_revenue
from pizza_types
join pizzas on  pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_revenue desc

Q11. Calculate the percentage contribution of each pizza type to total revenue.


Select pizza_types.name,
(sum (order_details.quantity * pizzas.price) / (Select 
(sum (order_details.quantity * pizzas.price)) as total_sales
from pizza_types
join pizzas on  pizzas.pizza_type_id = pizza_types.pizza_type_id)) * 100 as revenue
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name)
order by revenue desc

SELECT 
    pizza_types.name,
    ((SUM(order_details.quantity * pizzas.price) / 
        (SELECT SUM(order_details.quantity * pizzas.price)
         FROM pizzas
         JOIN order_details ON order_details.pizza_id = pizzas.pizza_id)
    ) * 100) AS revenue_percentage
FROM 
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.name
ORDER BY 
    revenue_percentage DESC;


Q12. Analyse the cumulative revenue generated over time. 

Select date, 
sum(revenue) over(order by date) as cum_revenue
from 
(select orders.date,
sum(order_details.quantity * pizzas.price) as revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on orders.date = order_details.order_id
group by orders.date) as sales


SELECT 
    date,
    ROUND(SUM(revenue) OVER (ORDER BY date), 2) AS cum_revenue
FROM 
    (
        SELECT 
            orders.date,
            SUM(order_details.quantity * pizzas.price) AS revenue
        FROM 
            orders
        JOIN 
            order_details ON orders.order_id = order_details.order_id
        JOIN 
            pizzas ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY 
            orders.date
    ) AS sales
ORDER BY 
    date;