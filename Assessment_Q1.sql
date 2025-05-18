;WITH SavingsSummary AS (
    -- Aggregate savings and investment counts and total deposits per user
    SELECT
        SS.[owner_id]                                                   AS owner_id,        -- User's ID 
        UC.[name]                                                       AS names,           -- User's name
        COUNT(CASE WHEN PP.[is_regular_savings] = 1 THEN 1 END)         AS savings_count,    -- Count of regular savings plans
        COUNT(CASE WHEN PP.[is_a_fund] = 1 THEN 1 END)                  AS investment_count, -- Count of investment/fund plans
        SUM(SS.[amount])                                                AS total_deposits    -- Total amount saved by user
    FROM [savings_savingsaccount] AS SS
    LEFT JOIN [users_customuser] AS UC 
        ON UC.[id] = SS.[id]                                               -- Join users to savings accounts
    LEFT JOIN [plans_plan] AS PP 
        ON SS.[owner_id] = PP.[owner_id]                                  -- Join savings to plans by owner_id
    GROUP BY
        UC.[name],
        SS.[owner_id]
)
-- Select all aggregated results where user has at least one savings and one investment plan
SELECT *
FROM SavingsSummary
WHERE savings_count > 0 
  AND investment_count > 0;
