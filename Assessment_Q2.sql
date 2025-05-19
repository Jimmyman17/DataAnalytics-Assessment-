/***************************************************************
  Query: User Transaction Frequency Categorization
  -------------------------------------------------------------
  This query calculates:
    • total number of successful transactions per user
    • months active since joining
    • average transactions per month
    • frequency category based on activity
    • count and average rate of users by frequency category
***************************************************************/

WITH UserTransactionSummary AS (
    SELECT 
        -- Unique user ID
        UC.[id] AS user_id,

        -- Calculate the number of months since the user joined
        DATEDIFF(month, UC.[date_joined], GETDATE()) AS months_active,

        -- Count of successful transactions (with both date and reference)
        COUNT(
            CASE 
                WHEN SS.[transaction_date] IS NOT NULL 
                     AND SS.[transaction_reference] IS NOT NULL 
                     AND LOWER(SS.[transaction_status]) = 'success'
                THEN 1 
            END
        ) AS successful_transaction_count

    FROM [users_customuser] AS UC
    LEFT JOIN [savings_savingsaccount] AS SS
        ON UC.[id] = SS.[id]  -- Assumes SS.id refers to customer ID

    -- Group by user and join date for aggregation
    GROUP BY 
        UC.[id],
        UC.[date_joined]

    -- Include only users with exactly one successful transaction
    HAVING 
        COUNT(
            CASE 
                WHEN SS.[transaction_date] IS NOT NULL 
                     AND SS.[transaction_reference] IS NOT NULL 
                     AND LOWER(SS.[transaction_status]) = 'success'
                THEN 1 
            END
        ) = 1
),

UserFrequencyCategory AS (
    SELECT 
        user_id,

        -- Average successful transactions per month
        CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) AS avg_transactions_per_month,

        -- Categorize users by transaction frequency
        CASE 
            WHEN CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) >= 10 THEN 'High Frequency'
            WHEN CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) > 2 
                 AND CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) < 10 THEN 'Medium Frequency'
            WHEN CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) <= 2 THEN 'Low Frequency'
        END AS transaction_frequency_category
    FROM UserTransactionSummary
)

-- Final aggregation by frequency category
SELECT  
    transaction_frequency_category AS frequency_category,
    COUNT(user_id) AS customer_count,
    AVG(avg_transactions_per_month) AS avg_transactions_per_month
FROM UserFrequencyCategory
GROUP BY transaction_frequency_category;
