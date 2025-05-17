SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    ROUND(COALESCE(dep.total_deposits, 0) / 100.0, 2) AS total_deposits
FROM users_customuser u
LEFT JOIN (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings IN (1, '1', true, 'True')
    GROUP BY owner_id
) s ON s.owner_id = u.id
LEFT JOIN (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund IN (1, '1', true, 'True')
    GROUP BY owner_id
) i ON i.owner_id = u.id
LEFT JOIN (
    SELECT owner_id, SUM(confirmed_amount) AS total_deposits
    FROM savings_savingsaccount
    WHERE confirmed_amount IS NOT NULL
    GROUP BY owner_id
) dep ON dep.owner_id = u.id
WHERE s.savings_count IS NOT NULL AND i.investment_count IS NOT NULL
ORDER BY total_deposits DESC;
