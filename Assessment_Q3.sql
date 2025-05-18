-- Question 3

-- Generating active accounts with inflow transactions
WITH inflow_transactions AS 
(
    SELECT 
        s.plan_id,
        s.owner_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0
        AND s.transaction_status IN ('success', 'successful', 'monnify_success')
    GROUP BY s.plan_id, s.owner_id
),
-- Filtering the qualified accounts based on investment or savings plan = 1
qualified_accounts AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        p.start_date,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE NULL
        END AS type
    FROM plans_plan p
    WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
),
final_accounts AS
(
SELECT 
    qa.plan_id,
    qa.owner_id,
    qa.type,
    it.last_transaction_date,
    DATEDIFF(CURDATE(), COALESCE(it.last_transaction_date, qa.start_date)) AS inactivity_days
    -- To account for cases with las_transaction_date is null, we result to the day the user created an account
FROM qualified_accounts qa
LEFT JOIN inflow_transactions it ON qa.plan_id = it.plan_id
WHERE 
	-- No inflow ever
	it.last_transaction_date IS NULL
	-- last inflow is more than 365 days ago
     OR DATEDIFF(CURDATE(), it.last_transaction_date) > 365
)
-- Ensuring our results show no inflow transactions for over one year.
SELECT *
FROM final_accounts
WHERE inactivity_days >365
ORDER BY inactivity_days DESC;
