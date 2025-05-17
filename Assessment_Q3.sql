-- Detect inactive funded plans without recent inflows
WITH recent_activity AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS latest_txn_date
    FROM savings_savingsaccount
    GROUP BY plan_id
)

SELECT 
    pp.id AS plan_id,
    pp.owner_id,
    
    -- Distinguish plan type
    CASE 
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unspecified'
    END AS type,
    
    -- Date of the most recent transaction
    DATE(ra.latest_txn_date) AS last_transaction_date,
    
    -- Days since last transaction (or full age of plan if no txn)
    DATEDIFF(CURDATE(), ra.latest_txn_date) AS inactivity_days

FROM plans_plan pp
LEFT JOIN recent_activity ra ON ra.plan_id = pp.id

-- Only consider plans that are marked active
WHERE 
    pp.is_deleted = 0 
    AND pp.is_archived = 0
    AND (pp.is_regular_savings = 1 OR pp.is_a_fund = 1)

-- Either no transactions OR last transaction was over a year ago
AND (
    ra.latest_txn_date IS NULL 
    OR DATEDIFF(CURDATE(), ra.latest_txn_date) > 365
)

ORDER BY inactivity_days DESC;
