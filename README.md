# DataAnalytics-Assessment

## 📌 Question 1: High-Value Customers with Multiple Products
**Approach**:  
I structured the query using Common Table Expressions (CTEs) for clarity and efficiency. First, I created a user_plans CTE that selects all savings and investment plans from the plans_plan table, tagging each with its type using a CASE statement. Next, I defined a plan_inflows CTE that calculates the total confirmed inflow per plan by filtering and aggregating data from the savings_savingsaccount table. Then, I combined both in a merged_data CTE to associate each plan with its owner, type, and total inflow.

Finally, I joined the merged_data with the users_customuser table to retrieve user details, and in the main query, I used conditional aggregation to count distinct savings and investment plans per user and to compute the total deposits. I grouped the result by the user’s ID and name, and sorted it by the total deposits in descending order.

**Challenges**:  
Initially, when I used a direct subquery to run my query, it took longer to run and I discovered that using CTE helped me break down my codes in chunks where I had to now only join tables with smaller records thereby reducing run time and improving query performance

## 📌 Question 2: Transaction Frequency Analysis

**Approach**:  
For this question, I structured the query using Common Table Expressions (CTEs) by creating 2 CTEs. The first CTE was used to generate the number of monthly transactions by each customer from the savings_savingsaccount table, the Group BY function was employed here to properly aggregate the records by the owner_id and the year_month fields. The second CTE was used to generate the average monthly transaction. I used the average function to generate this, selected the owner_id from the first CTE, and Grouped results by the owner_id for proper aggregation.

Finally, I used a case statement to Categorize customer transaction frequency, counted the number of all records for each of these categories and utilized the average function to return the average transactions per month for each of these transaction frequency. I finally used the GROUP BY function to aggregate each frequency category.

**Challenges**:  
Initially, I didn't aggregate the average monthly transaction at the final outer query. I only did that with the avg_transaction CTE. After running my query, I discovered I got multiple records of average monthly transactions for each category which didn't meet the stakeholder's criteria. I had to critically look at the question and found out where the mistake was  not taking note of the average of those customer-level averages for each frequency group. 

## 📌 Question 3: Account Inactivity Alert

**Approach**:  
For this question, I structured the query using Common Table Expressions (CTEs) by creating 3 CTEs. I started by creating a user_plans CTE to filter only relevant plans—savings and investment—using a CASE statement to assign a type label based on the conditions is_regular_savings = 1 or is_a_fund = 1. This helped to easily categorize the plans for each user. I also created a filter using the Where clause in this first CTE to only return transaction_status that were only successful/valid, and confirmed_amount been greater than zero. This was to ensure the condition of the inflow of funds was met. I used the second CTE to filter the qualified accounts based on when investment or savings plan = 1 in the case statement I utilized in this CTE. The third CTE I created was used to return the final accounts.
Here, I used the DATEDIFF function to return the difference between the current date and either the last_transaction date or the start_date. This was done to account for cases with las_transaction_date is null, we result to the day the user created an account. 

I created a third CTE that joined the qualified accounts temp table I created as the second CTE to first CTE (inflow_transactions) using the common keys between them (plan_id).
Next, I created a Where clause condition to filter results to only include transactions over a year ago or transactions with no inflow ever. 
Finally, I selected all records from the 3rd CTE and created a WHERE clause to only include transactions beyond 365 days/1 year

**Challenges**:  
At first, without the final outer query, I still got records with inactive days below 365 or with negative value. Seeing this, I went ahead to create a further condition in the where clause of my final outer query to only include transactions beyond 365 days/1 year

## 📌 Question 4: Customer Lifetime Value (CLV) Estimation

**Approach**:  
For this question, I structured the query using Common Table Expressions (CTEs) by creating 2 CTEs.I started by creating a transactions CTE to calculate the total number of successful transactions and their total monetary value. Since the confirmed_amount field is in kobo, I converted it to naira by dividing by 100 and used ROUND to format the result to two decimal places. I also filtered the records to only include transactions with valid statuses ('success', 'successful', 'monnify_success'), ensuring only confirmed inflows were counted. The results were grouped by owner_id. 

Next, I created a tenure CTE to calculate how long each customer has been active. I used TIMESTAMPDIFF to compute the number of months between the date_joined field and the current date. This gave me each user's tenure_months value. I also combined their first and last names for clearer identification in the output.

For the final Customer Lifetime Value (CLV) estimation, I then joined the tenure CTE with the transactions CTE using the customer ID (customer_id = owner_id). In the final SELECT statement, I calculated the CLV using the formula:
CLV=(total transactions/tenure in months)×12×(total value ×0.001/total transactions)
​
 )
**Challenges**:  
The main challenge was ensuring the accuracy of the CLV formula while preventing divide-by-zero errors. I solved this by using a CASE statement to return zero for users with no transactions or zero tenure. Additionally, working with values in kobo required careful conversion to naira for correct financial reporting. Using CTEs made it easier to organize the steps logically and isolate different parts of the calculation for validation and debugging.
