README
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


Feel free to reach out for clarifications or further optimizations!
