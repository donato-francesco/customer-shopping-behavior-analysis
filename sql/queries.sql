-- Q1. Chi spende di più: uomini o donne?
SELECT gender, ROUND(SUM(purchase_amount), 2) AS revenue 
FROM customer 
GROUP BY gender;

--Q2. Quali clienti hanno usato uno sconto ma hanno speso più della media?
SELECT customer_id, purchase_amount 
FROM customer 
WHERE discount_applied = 'Yes' AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer) 
ORDER BY purchase_amount DESC
LIMIT 10;

--Q3. Quali sono i 5 prodotti con il rating medio più alto ?
SELECT item_purchased, ROUND(AVG(review_rating), 2) AS avg_rating 
FROM customer 
GROUP BY item_purchased 
ORDER BY AVG(review_rating) DESC 
LIMIT 5;

--Q4. La spedizione Express genera ordini più alti rispetto alla standard ?
SELECT shipping_type, ROUND(AVG(purchase_amount), 2) AS avg_order_value, COUNT(*) AS transactions 
FROM customer 
WHERE shipping_type IN ('Standard', 'Express') 
GROUP BY shipping_type;

--Q5. I clienti con subscription spendono di più di quelli senza ?
SELECT subscription_status, 
COUNT(customer_id) AS total_customers, 
ROUND(AVG(purchase_amount), 2) AS avg_spend, 
ROUND(SUM(purchase_amount), 2) AS total_revenue 
FROM customer
GROUP BY subscription_status  
ORDER BY total_revenue DESC;

--Q6. Quali prodotti hanno la percentuale più alta di acquisti con sconto ?
SELECT item_purchased, 
ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate 
FROM customer 
GROUP BY item_purchased 
ORDER BY discount_rate DESC 
LIMIT 5;

--Q7. Come si distribuiscono i clienti per livello di fedeltà ? (New, Returning, Repeat Buyer)
WITH customer_type AS (SELECT customer_id, previous_purchases, 
            CASE WHEN previous_purchases = 1 THEN 'New' 
			WHEN previous_purchases BETWEEN 2 AND 5 THEN 'Returning' 
			ELSE 'Loyal' END AS customer_segment 
			FROM customer) 
SELECT customer_segment, COUNT(*) AS number_of_customers 
FROM customer_type
GROUP BY customer_segment;

--Q8. Quali sono i 5 prodotti più venduti?
SELECT item_purchased, COUNT(*) AS total_orders 
FROM customer 
GROUP BY item_purchased
ORDER BY total_orders DESC 
LIMIT 5;

--Q9. I clienti con acquisti ripetuti sono più propensi ad avere una subscription ?
SELECT subscription_status, COUNT(customer_id) AS repeat_buyers 
FROM customer 
WHERE previous_purchases > 5
GROUP BY subscription_status;

--Q10. Quale fascia d'età genera più revenue ?
SELECT age_group, 
ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer 
GROUP BY age_group 
ORDER BY total_revenue DESC;