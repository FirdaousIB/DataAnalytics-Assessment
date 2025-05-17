SELECT
    u.id AS customer_id,
    u.name,
    TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()), 0))
        * 12 * AVG(s.confirmed_amount * 0.001),
        2
    ) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON s.owner_id = u.id
GROUP BY u.id, u.name, u.created_on
HAVING tenure_months > 0 AND total_transactions > 0
ORDER BY estimated_clv DESC;
