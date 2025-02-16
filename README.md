# Pizza_Sales_SQL
This project is a great example of how to design and manage a relational database for a real-world application like Pizza Hut. It demonstrates the use of SQL for data analysis, reporting, and decision-making. 

Q1. Retrive the total number of orders placed

Select * from orders

![image](https://github.com/user-attachments/assets/736bf1b7-cad1-4fff-bbad-01b50d69c44b)

Select max(order_id) AS total_orders
from orders
![image](https://github.com/user-attachments/assets/7f5f9bd9-e50f-474d-bdcc-7fdac9304b0e)

Q2. Calculate the total revenue from the pizza sales 

SELECT 
    SUM(order_details.quantity * CAST(pizzas.price AS DECIMAL(10, 2))) AS total_sales
FROM 
    order_details
JOIN 
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
![image](https://github.com/user-attachments/assets/2f5308f4-2dcf-4255-b8ad-10332db0eb4d)

Q3. Identify the higest-priced pizza

Select top 1 pizzas.price, pizza_types.name
from pizza_types
join pizzas on  pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc

![image](https://github.com/user-attachments/assets/eca0c8d7-59f1-48d8-b9dd-6acfa53564ba)

Q4. Identify the most common pizza size ordered

Select top 1 pizzas.size, COUNT(order_details.order_details_id) as most_common_pizzas_ordered
from pizzas
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size

![image](https://github.com/user-attachments/assets/4a10de36-a8c0-4b06-9fc7-a3f76265a065)


Q5. List the top 5 most ordered pizzas along with their quantity

Select top 5 pizza_types.name,sum (order_details.quantity) as quantity
from pizza_types
join pizzas on  pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by quantity desc

![image](https://github.com/user-attachments/assets/2ee71af6-620e-41be-9c23-c0c21cf00bde)

Q6. Join the necessary tables to find the total quantity of each pizza category ordered.

Select top 5 pizza_types.category,sum (order_details.quantity) as quantity
from pizza_types
join pizzas on  pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc

![image](https://github.com/user-attachments/assets/928f3a65-21a5-42cc-81fb-4eef55f40f25)


Q7. Determine the distribution of orders by hour of the day.

SELECT 
    DATEPART(HOUR, time) AS Hour, 
    COUNT(order_id) AS order_count
FROM 
    orders
GROUP BY 
    DATEPART(HOUR, time)
ORDER BY 
    Hour;

![image](https://github.com/user-attachments/assets/58716927-e47e-4aaa-928c-ed6295eea9d6)

Q8. Join relevant tables to find the category wise distribution of pizzas

Select category, count(name)
from pizza_types
group by category

![image](https://github.com/user-attachments/assets/4bbd8525-1151-46b2-bf0a-7740746c720d)

Q9. Group the orders by date and calculate the sum number of pizzas ordered per day

Select avg(quantity) from
 (Select orders.date, sum(order_details.quantity) as Quantity
From orders
Join order_details on order_details.order_id = orders.order_id
group by orders.date) as ordered_quantity

![image](https://github.com/user-attachments/assets/cce1a9db-ade7-4181-acc5-bcf5979bf1fd)

Q10. Determine the top 3 most ordered pizzas types based on revenue


Select top 3 pizza_types.name,sum (order_details.quantity * pizzas.price) as total_revenue
from pizza_types
join pizzas on  pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_revenue desc

![image](https://github.com/user-attachments/assets/86cb66f0-ea4d-4cb1-bf66-e3ee0571bba5)

Q11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.name,
    ROUND((SUM(order_details.quantity * pizzas.price) / 
        (SELECT SUM(order_details.quantity * pizzas.price)
         FROM pizzas
         JOIN order_details ON order_details.pizza_id = pizzas.pizza_id)
    ) * 100, 2) AS revenue_percentage
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

![image](https://github.com/user-attachments/assets/8d1a44cb-4172-490e-be8e-bc594aaa9d74)

Q12. Analyse the cumulative revenue generated over time. 

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

![image](https://github.com/user-attachments/assets/5e283438-fae8-45f1-ac9e-76c25d628baa)








