USE adashi_staging;

-- Question 1
SELECT 
    uc.id AS owner_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    -- Using a case statement as condition to return all records of savings and invesement plan, then count the distinct records
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    -- Using a case statement as condition to return all records of confirmed inflows, and therby aggregating with a sum function
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
FROM 
	users_customuser uc
	-- Joining the users_customers table to the plans_plan table using their common primary and foreign keys
JOIN 
	plans_plan p ON p.owner_id = uc.id
	-- Joining the plans_plan table to the savings_savingsaccount table using their common primary and foreign keys
JOIN 
	savings_savingsaccount s ON s.plan_id = p.id
	-- filtering our result to only return savings and investmnet plans and to ensure we have inflow of funds
WHERE 
	(p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND s.confirmed_amount > 0
GROUP BY 
	uc.id, uc.first_name, uc.last_name
ORDER BY 
	total_deposits DESC;