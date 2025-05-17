-- Analyze customer activity based on monthly transaction patterns
WITH monthly_activity AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS month,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount
    WHERE transaction_date IS NOT NULL
    GROUP BY owner_id, month
),

customer_avg_activity AS (
    SELECT 
        owner_id,
        AVG(transactions_in_month) AS average_monthly_txns
    FROM monthly_activity
    GROUP BY owner_id
),

categorized_customers AS (
    SELECT 
        owner_id,
        average_monthly_txns,
        CASE
            WHEN average_monthly_txns >= 10 THEN 'High Frequency'
            WHEN average_monthly_txns >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_avg_activity
)

SELECT 
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(average_monthly_txns), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
