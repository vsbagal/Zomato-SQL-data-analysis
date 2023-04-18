-- QUE1. What is the total amount each customer spent on zomato?
SELECT s.userid, sum(p.price) as total_amount
FROM sales s INNER JOIN product p
ON s.product_id = p.product_id
GROUP BY s.userid;
