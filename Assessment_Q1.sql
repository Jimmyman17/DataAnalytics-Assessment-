/***************************************************************
  Query: Savings and Investment Summary by User
  -------------------------------------------------------------
  This query calculates:
    • number of savings plans per user
    • number of investment (fund) plans per user
    • total deposits across all plans
    • filters for users with both savings and investment plans
***************************************************************/

WITH SavingsSummary AS (
    SELECT
        -- User identification
        SS.[owner_id] AS owner_id,
        UC.[name] AS [name],

        -- Count of regular savings plans
        COUNT(
            CASE 
                WHEN PP.[is_regular_savings] = 1 THEN 1 
            END
        ) AS savings_count,

        -- Count of investment (fund) plans
        COUNT(
            CASE 
                WHEN PP.[is_a_fund] = 1 THEN 1 
            END
        ) AS investment_count,

        -- Total amount deposited by the user
        SUM(SS.[amount]) AS total_deposits

    FROM [savings_savingsaccount] AS SS
    LEFT JOIN [users_customuser] AS UC
        ON UC.[id] = SS.[id]  -- Join savings account to user by ID

    LEFT JOIN [plans_plan] AS PP
        ON SS.[owner_id] = PP.[owner_id]  -- Join savings account to plan by owner ID

    -- Group by user to aggregate per individual
    GROUP BY
        SS.[owner_id],
        UC.[name]
)

-- Final selection: users who have both savings and investment plans
SELECT *
FROM SavingsSummary
WHERE savings_count > 0
  AND investment_count > 0;
