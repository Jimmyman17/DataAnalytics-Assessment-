;WITH UserTransactionSummary AS (
    SELECT 
        UC.[id],
        
        -- Calculate the number of months since the user joined
        DATEDIFF(month, UC.[date_joined], GETDATE()) AS months_active,
        
        -- Count only successful transactions that have both date and reference
        COUNT(CASE 
                 WHEN SS.[transaction_date] IS NOT NULL 
                      AND SS.[transaction_reference] IS NOT NULL 
                      AND LOWER(SS.[transaction_status]) = 'success'
                 THEN 1 
             END) AS successful_transaction_count
    FROM [users_customuser] AS UC 
    LEFT JOIN [savings_savingsaccount] AS SS 
        ON UC.[id] = SS.[id]  -- Note: assumes SS.id is same as UC.id
    GROUP BY 
        UC.[id],
        UC.[date_joined]
    
    -- Only include users who have exactly 1 successful transaction
    HAVING 
        COUNT(CASE 
                 WHEN SS.[transaction_date] IS NOT NULL 
                      AND SS.[transaction_reference] IS NOT NULL 
                      AND LOWER(SS.[transaction_status]) = 'success'
                 THEN 1 
             END) = 1  
),

UserFrequencyCategory AS (
    SELECT 
        id,
        
        -- Compute the average transactions per month; guard against division by zero
        CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) AS avg_transactions_per_month,
        
        -- Categorize user based on transaction frequency
        CASE 
            WHEN CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) >= 10 THEN 'High Frequency'
            WHEN CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) > 2 
                 AND CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) < 10 THEN 'Medium Frequency'
            WHEN CAST(successful_transaction_count AS FLOAT) / NULLIF(months_active, 0) <= 2 THEN 'Low Frequency'
        END AS transaction_frequency_category 
    FROM UserTransactionSummary
)

-- Final aggregation: count users and average their transaction rates by frequency category
SELECT  
    transaction_frequency_category AS frequency_category,
    COUNT(id) AS customer_count,
    AVG(avg_transactions_per_month) AS avg_transactions_per_month
FROM UserFrequencyCategory
GROUP BY transaction_frequency_category;
