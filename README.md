SQL Analysis:  High-Value Customers with Multiple Products
Assessment_Q1.sql Overview
This project contains a SQL query designed to summarize user savings data by aggregating total deposits, counting savings plans, and counting investment plans per user. It uses Common Table Expressions (CTEs) for clarity and modularity.

Approach:
The core of the query is a CTE named SavingsSummary. It joins three tables:
savings_savingsaccount (alias SS) to get account balances and owner IDs,
users_customuser (alias UC) to retrieve user names,
plans_plan (alias PP) to identify plan types (regularsavings or investment funds).

Aggregations:
Within the CTE, we use:
SUM(SS.[amount]) to calculate total deposits per user.
Conditional COUNT(CASE WHEN ...) expressions to count how many plans per user are regular savings or investment funds.

Grouping:
The aggregation groups results by user name and owner ID to ensure accurate per-user summaries.

Filtering Users Based on Plan Counts
After defining the CTE, the final query filters out users who do not have at least one regular savings plan and one investment plan by using:
WHERE savings_count > 0 AND investment_count > 0;
This ensures the output only includes users actively participating in both types of financial plans.

Challenges
Aggregating Conditional Counts Issue:
Counting specific plan types conditionally required careful use of COUNT(CASE WHEN ... THEN 1 END) syntax. Misuse could lead to incorrect counts or syntax errors.

Resolution:
Applied standard SQL pattern for conditional aggregation, ensuring counts correctly reflected plans with is_regular_savings = 1 and is_a_fund = 1.

 Proper Syntax and Formatting in CTEsIssue:
Some syntax errors appeared, such as misplaced commas and aliasing mistakes, especially when transforming the base query into a CTE structure.

Resolution:
Reviewed SQL Server syntax rules carefully and applied consistent formatting and indentation to improve readability and maintainability.




SQL Analysis: User Transaction Frequency Categorization
Assessment_Q2.sql Overview
This SQL script analyzes user transaction behavior by calculating how frequently users perform successful transactions, categorizing them into "High", "Medium", or "Low Frequency" groups. The process uses Common Table Expressions (CTEs) to structure the logic clearly and modularly.

1. Filter Users With Exactly One Successful Transaction
CTE: UserTransactionSummary

Goal: Select users who have exactly one successful transaction.

Approach:
Joined [users_customuser] with [savings_savingsaccount] on id.
Counted only transactions where:
transaction_date and transaction_reference are not null.
transaction_status (case-insensitive) is 'success'.
Used DATEDIFF to compute the number of months the user has been active.
Applied a HAVING clause to filter users with exactly one successful transaction.

2. Calculate Average Transactions Per Month & Categorize
CTE: UserFrequencyCategory

Goal: For users with 1 transaction, calculate how frequent it is per month.

Approach:
Divided successful_transaction_count by months_active to get average transactions per month.
Used NULLIF(months_active, 0) to prevent divide-by-zero errors.
Applied a CASE expression to categorize:
>= 10 → High Frequency
> 2 and < 10 → Medium Frequency
<= 2 → Low Frequency

3. Summarize Users by Frequency Category
Final SELECT
Goal: Report number of users in each frequency category and their average transaction rate.
Approach:
Grouped by transaction_frequency_category.
Counted users and averaged their avg_transactions_per_month.

Challenges & Resolutions
1. Preventing Division by Zero
Problem: Some users might have months_active = 0, which causes division errors.
Solution: Used NULLIF(months_active, 0) to safely avoid division by zero.

2. Counting Conditional Success Transactions
Problem: Not all transactions are valid (missing references or not marked "success").
Solution: Used CASE within COUNT to selectively count only valid success transactions.

3. CTE Output Reuse and Aliasing
Problem: Needed to compute and reuse intermediate calculations across steps.
Solution: Used chained CTEs to break the query into readable steps and reuse derived columns like avg_transactions_per_month.



Feel free to reach out for clarifications or further optimizations!
