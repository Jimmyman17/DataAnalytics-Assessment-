-- Common Table Expression (CTE) to get the latest transaction date per plan and classify the plan type
;WITH account_inactivity AS (
    SELECT  
        SS.[plan_id],
        PP.[owner_id],
        
        -- Determine the type of plan based on flags
        CASE 
            WHEN PP.[is_regular_savings] = 1 THEN 'Saving'
            WHEN PP.[is_a_fund] = 1 THEN 'Investment'
        END AS [type],
        
        -- Get the most recent transaction date for each plan
        MAX([transaction_date]) AS [last_transaction_date]
    
    FROM [savings_savingsaccount] AS SS 
    LEFT JOIN [plans_plan] AS PP 
        ON SS.[owner_id] = PP.[owner_id]
    
    -- Only consider confirmed transactions
    WHERE SS.[confirmed_amount] IS NOT NULL
    
    -- Group by necessary fields to use aggregation
    GROUP BY 
        SS.[plan_id], 
        PP.[owner_id],
        CASE 
            WHEN PP.[is_regular_savings] = 1 THEN 'Saving'
            WHEN PP.[is_a_fund] = 1 THEN 'Investment'
        END
)

-- Final query to calculate inactivity in days from the last transaction date to today
SELECT 
    *,
    DATEDIFF(DAY, [last_transaction_date], GETDATE()) AS [inactive_days]
FROM [account_inactivity];
