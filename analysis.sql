# QUE1. What is the total amount each customer spent on zomato?
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


-- QUE5. Which item was most popular for each customer?
SELECT * FROM
  (
    SELECT *, RANK() OVER(
        partition by userid 
        ORDER BY cnt desc
      ) rnk 
    FROM
      (
       SELECT userid, product_id, count(product_id) cnt 
        FROM sales GROUP BY userid, product_id
      ) s
  ) p
WHERE rnk = 1;


-- QUE6. Which item was purchased first by customers after they become a member?
SELECT * FROM  (SELECT c. *, RANK() OVER (
                   partition BY userid
                   ORDER BY created_date ) rnk
        FROM (SELECT s.userid, s.created_date, s.product_id, gs.gold_signup_date
                FROM sales s
                       INNER JOIN goldusers_signup gs
                               ON s.userid = gs.userid
                                  AND created_date >= gold_signup_date) c)d
WHERE  rnk = 1; 


-- QUE7. Which item was purchased just before the customer became a member?
SELECT * FROM (SELECT c.*, RANK() OVER (
                   PARTITION BY userid
                   ORDER BY created_date DESC ) rnk
        FROM   (SELECT s.userid,
                       s.created_date,
                       s.product_id,
                       gs.gold_signup_date
                FROM   sales s
                       INNER JOIN goldusers_signup gs
                               ON s.userid = gs.userid
                                  AND created_date <= gold_signup_date) c) gsd
WHERE  rnk = 1; 


-- QUE8. What are the total orders and amount spent for each member before they become a member?
SELECT userid, COUNT(created_date) order_purchased, SUM(price) total_amt_spent
FROM   (SELECT c.* , d.price
        FROM   (SELECT s.userid, s.created_date, s.product_id, gsd.gold_signup_date
					FROM sales s JOIN goldusers_signup gsd 
					ON s.userid = gsd.userid
					AND created_date <= gold_signup_date) c
					JOIN product d
					ON c.product_id = d.product_id)e
GROUP  BY userid; 
