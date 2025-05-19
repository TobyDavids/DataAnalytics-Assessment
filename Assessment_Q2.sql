-- Question 2 - 

-- CTE to generate No of monthly transaction by each customer
WITH monthly_transaction_per_cust AS
(
SELECT 
	owner_id,
    	DATE_FORMAT(transaction_date, '%Y-%M') As yr_month,
    	COUNT(*) AS no_transactions
FROM
	savings_savingsaccount
WHERE transaction_status IN ('success', 'successful', 'monnify_success')
GROUP BY 1,2
),
-- Avg Monthly transaction
avg_transaction AS
(
SELECT 
	mt.owner_id,
    	ROUND(AVG(mt.no_transactions), 2) As avg_mnthly_trnsction
FROM  
	monthly_transaction_per_cust AS mt
GROUP BY 1
)
-- Categorizing customer transaction frequency and their avg monthly transaction
SELECT 
	CASE WHEN avg_mnthly_trnsction >= 10 THEN 'High Frequency'
	     WHEN avg_mnthly_trnsction >= 3 AND avg_mnthly_trnsction <= 9 THEN 'Medium Frequency'
             ELSE 'Low Frequency' 
             END AS frequency_category,
	COUNT(*) AS 'customer_count',
    	ROUND(AVG(avg_mnthly_trnsction), 2) AS avg_transactions_per_month
FROM 
	avg_transaction
GROUP BY 1;
    
