# DataAnalytics-Assessment

## 📌 Question 1: High-Value Customers with Multiple Products
**Approach**:  
I structured the query using Common Table Expressions (CTEs) for clarity and efficiency. First, I created a user_plans CTE that selects all savings and investment plans from the plans_plan table, tagging each with its type using a CASE statement. Next, I defined a plan_inflows CTE that calculates the total confirmed inflow per plan by filtering and aggregating data from the savings_savingsaccount table. Then, I combined both in a merged_data CTE to associate each plan with its owner, type, and total inflow.

Finally, I joined the merged_data with the users_customuser table to retrieve user details, and in the main query, I used conditional aggregation to count distinct savings and investment plans per user and to compute the total deposits. I grouped the result by the user’s ID and name, and sorted it by the total deposits in descending order.

**Challenges**:  
Initially, when I used a direct subquery to run my query, it took longer to run and I discovered that using CTE helped me break down my codes in chunks where i had to now only join tables with smaller records thereby reducing run time and improving query performance
