-- Question 4

-- completed transactions in naira (since all amount fields are in kobo) 
WITH transactions AS
(
SELECT 
	owner_id,
    COUNT(*) AS total_transaction,
    ROUND(SUM(confirmed_amount/100), 2) AS total_value
FROM
	savings_savingsaccount
WHERE 
	-- Filtering condition to only return valid transations
    transaction_status IN ('success', 'successful', 'monnify_success')
GROUP BY 1
),
-- CTE to derive user tenure
tenure AS
(
SELECT 
	id AS customer_id,
    CONCAT(first_name, ' ', last_name) AS name,
    -- Using the Timestampdiff function to get the difference between the date a customer joined and the current date in months
    TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
FROM users_customuser
)
-- Final CLV Calculation for each curstomer
SELECT 
	t.customer_id,
    t.name,
    t.tenure_months,
    COALESCE(tr.total_transaction, 0) AS total_transaction,
    -- CLV formula after ensuring our total transaction and tenure_months isnt zero
    CASE WHEN tr.total_transaction > 0 AND t.tenure_months > 0
		 THEN ROUND(((tr.total_transaction/t.tenure_months)* 12 * (tr.total_value*0.001)/tr.total_transaction), 2)
         ELSE 0
         END AS estimated_clv
FROM 
	tenure AS t
LEFT JOIN 
	transactions AS tr ON t.customer_id = tr.owner_id
ORDER BY estimated_clv DESC;

