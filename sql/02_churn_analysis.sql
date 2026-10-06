-- Общий churn rate
SELECT 
    ROUND(AVG(CASE WHEN exit THEN 1 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM bank_churn;

--Churn rate по сегментам
SELECT 
    customer_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exit THEN 1 ELSE 0 END) AS churned,
    ROUND(AVG(CASE WHEN exit THEN 1 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM bank_churn
GROUP BY customer_segment
ORDER BY churn_rate_pct DESC;

-- Churn rate по цифровому каналу
SELECT 
    digital_behavior,
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN exit THEN 1 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM bank_churn
GROUP BY digital_behavior
ORDER BY churn_rate_pct DESC;

--Топ-10 сегмент × возраст с самым высоким churn
SELECT 
    customer_segment,
    CASE 
        WHEN age <= 24 THEN '18-24'
        WHEN age <= 34 THEN '25-34'
        WHEN age <= 44 THEN '35-44'
        WHEN age <= 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN exit THEN 1 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM bank_churn
GROUP BY customer_segment, age_group
HAVING COUNT(*) > 100
ORDER BY churn_rate_pct DESC
LIMIT 10;

--Churn rate по уровню лояльности и каналу
SELECT 
    loyalty_level,
    digital_behavior,
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN exit THEN 1 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM bank_churn
GROUP BY loyalty_level, digital_behavior
ORDER BY loyalty_level, churn_rate_pct DESC;

-- Средняя вовлеченность у ушедших vs оставшихся
SELECT 
    exit,
    COUNT(*) AS total,
    ROUND(AVG(engagement_score), 2) AS avg_engagement,
    ROUND(AVG(risk_score), 3) AS avg_risk
FROM bank_churn
GROUP BY exit;

--Анализ по tenure
SELECT 
    tenure_ye AS years_with_bank,
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN exit THEN 1 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM bank_churn
GROUP BY tenure_ye
ORDER BY tenure_ye;

--Клиенты с churn выше среднего по своему сегменту
WITH segment_avg AS (
    SELECT 
        customer_segment,
        AVG(CASE WHEN exit THEN 1 ELSE 0 END) AS avg_churn
    FROM bank_churn
    GROUP BY customer_segment
)
SELECT 
    b.customer_segment,
    b.age,
    b.engagement_score,
    ROUND(s.avg_churn * 100, 2) AS segment_avg_churn_pct,
    CASE 
        WHEN b.engagement_score < 20 THEN 'High risk'
        WHEN b.engagement_score < 40 THEN 'Medium risk'
        ELSE 'Low risk'
    END AS risk_category
FROM bank_churn b
JOIN segment_avg s ON b.customer_segment = s.customer_segment
WHERE b.exit = TRUE
LIMIT 20;