SELECT
  customer_segment AS сегмент,
  COUNT(*) AS всего,
  SUM(CASE WHEN exit THEN 1 ELSE 0 END) AS ушло,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
GROUP BY customer_segment
ORDER BY процент_оттока DESC;

SELECT
  loyalty_level AS уровень,
  COUNT(*) AS всего,
  SUM(CASE WHEN exit THEN 1 ELSE 0 END) AS ушло,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
GROUP BY loyalty_level
ORDER BY процент_оттока DESC;
