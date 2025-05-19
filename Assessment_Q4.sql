/***************************************************************
  Query: Customer Estimated CLV using CTE
  -------------------------------------------------------------
  This query calculates:
    • tenure in months
    • total confirmed transaction value
    • count of successful transactions
    • average profit per successful transaction
    • estimated annual CLV
***************************************************************/

WITH UserTransactionSummary AS (
    SELECT
        -- Customer basic information
        UC.[id] AS customer_id,
        UC.[name] AS [name],

        -- Months since the customer joined the platform
        DATEDIFF(month, UC.[date_joined], GETDATE()) AS tenure_months,

        -- Total value of transactions that were fully confirmed
        SUM(
            CASE
                WHEN SS.[amount] = SS.[confirmed_amount]
                THEN SS.[confirmed_amount]
                ELSE 0
            END
        ) AS [total_transactions],

        -- Number of transactions that are successful (date, reference present, status = 'success')
        COUNT(
            CASE
                WHEN SS.[transaction_date] IS NOT NULL
                     AND SS.[transaction_reference] IS NOT NULL
                     AND LOWER(SS.[transaction_status]) = 'success'
                THEN 1
            END
        ) AS successful_transaction_count,

        -- Average profit per successful transaction (10% margin)
        SUM(0.1 * SS.[confirmed_amount])
        / NULLIF(
            COUNT(
                CASE
                    WHEN SS.[transaction_date] IS NOT NULL
                         AND SS.[transaction_reference] IS NOT NULL
                         AND LOWER(SS.[transaction_status]) = 'success'
                    THEN 1
                END
            ), 0
        ) AS profit_per_transaction

    FROM [users_customuser] AS UC
    LEFT JOIN [savings_savingsaccount] AS SS
        ON UC.[id] = SS.[id]

    -- Group by unique customer and their join date
    GROUP BY
        UC.[id],
        UC.[name],
        UC.[date_joined]

    -- Include only customers with exactly one successful transaction
    HAVING
        COUNT(
            CASE
                WHEN SS.[transaction_date] IS NOT NULL
                     AND SS.[transaction_reference] IS NOT NULL
                     AND LOWER(SS.[transaction_status]) = 'success'
                THEN 1
            END
        ) = 1
)

-- Final projection with estimated annual CLV
SELECT
    customer_id,
    [name],
    tenure_months,
    total_transactions,
    (CAST(total_transactions AS FLOAT) / NULLIF(tenure_months, 0)) * 12 * profit_per_transaction AS estimated_clv
FROM UserTransactionSummary
ORDER BY estimated_clv DESC;
