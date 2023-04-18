-- QUE1. What is the total amount each customer spent on zomato?
SELECT s.userid, sum(p.price) as total_amount
FROM sales s INNER JOIN product p
ON s.product_id = p.product_id
GROUP BY s.userid;

-- QUE2. How many days has each customer visited zomato?
SELECT userid, count(distinct created_date) distinct_days
FROM sales GROUP BY userid;

-- QUE3. What was the first product purchased by each customer?
SELECT * FROM (
SELECT *, RANK() OVER (partition by userid order by created_date)
RNK FROM sales ) s where 
RNK = 1;

-- QUE4. What is the most purchased item on the menu & how many times was it purchased by all customers?
SELECT userid, count(product_id) AS most_purchased_items from sales 
WHERE product_id = (
SELECT  product_id FROM sales GROUP BY product_id
ORDER BY COUNT(product_id)  DESC LIMIT 1
  ) 
  GROUP BY userid;
