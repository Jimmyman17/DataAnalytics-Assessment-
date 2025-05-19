SQL Project Analysis and Summary
Question 1: High-Value Customers with Multiple Products
File: Assessment_Q1.sql

Overview
This query summarizes user savings data by aggregating total deposits, counting savings plans, and counting investment plans per user. It uses Common Table Expressions (CTEs) for clarity and modularity.

Approach
Join three tables:

savings_savingsaccount (alias SS) for account balances and owner IDs

users_customuser (alias UC) for user names

plans_plan (alias PP) to identify plan types (regular savings or investment funds)

Aggregate total deposits (SUM(SS.[amount])), count savings plans, and count investment plans using conditional COUNT(CASE WHEN ...) statements.

Group results by user name and owner ID for per-user summaries.

Filter users to include only those with at least one savings and one investment plan.

Challenges & Resolutions
Conditional Aggregation: Properly used COUNT(CASE WHEN ...) syntax to avoid incorrect counts.

CTE Syntax: Ensured correct formatting and aliasing to prevent syntax errors.

Question 2: User Transaction Frequency Categorization
File: Assessment_Q2.sql

Overview
Analyzes user transaction behavior to categorize users into "High", "Medium", or "Low Frequency" groups based on the frequency of successful transactions.

Steps
Filter users with exactly one successful transaction (UserTransactionSummary CTE)

Calculate average transactions per month and categorize users (UserFrequencyCategory CTE)

Summarize user counts and average rates by frequency category (final SELECT)

Key Points
Use of DATEDIFF to calculate months active.

Use of NULLIF to prevent division by zero.

Use of chained CTEs for modular logic and reusability.

Challenges & Resolutions
Handling division by zero safely.

Accurate counting of valid successful transactions using conditional aggregation.

Question 3: Account Inactivity Analysis
File: Assessment_Q3.sql

Overview
Identifies inactive savings accounts by calculating the number of days since each account’s last confirmed transaction.

Approach
Use a CTE account_inactivity joining savings_savingsaccount and plans_plan on owner_id.

Filter out records with NULL confirmed amounts to consider only completed transactions.

Categorize plans as 'Saving' or 'Investment' using a CASE expression.

Determine the latest transaction date per plan and calculate inactivity duration with DATEDIFF.

Challenges & Resolutions
Repeating CASE expression in GROUP BY to satisfy SQL Server syntax.

Formatting and indentation to improve readability without changing logic.

Question 4: Customer Basic Information & Tenure
File: Assessment_Q4.sql

Overview
Calculates customer tenure in months, total confirmed transaction value, count of successful transactions, average profit per successful transaction (assuming a 10% margin), and estimated annual Customer Lifetime Value (CLV).

Approach
Use DATEDIFF to calculate tenure.

Sum confirmed transactions where full amount matches confirmed amount.

Count transactions that are successful with valid date and reference.

Compute average profit per transaction and annualize it to estimate CLV.

Challenges & Resolutions
Fixing invalid object name errors by verifying table names.

Removing extraneous commas in CTE syntax.

Correct aggregation of profit values to avoid miscalculation.

Preventing division by zero with NULLIF.

Contact
For any clarifications or further optimization suggestions, feel free to reach out!

Author: Nwadim Chukwuma Nestor
Email: nwadimnestor@gmail.com






NOTE FOR THIS ASSESSMENT I HAD TO CLONED THE DATABASE DUE TO SOME ISSUES 
If you want to see it clink on this link below
https://github.com/Jimmyman17/Database-Creation-using-DDL-statement
Thank you.
