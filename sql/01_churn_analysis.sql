-- 1. Отток по сегментам клиентов: в каком сегменте уходят чаще всего
SELECT
  customer_segment AS сегмент,
  COUNT(*) AS всего,
  SUM(CASE WHEN exit THEN 1 ELSE 0 END) AS ушло,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
GROUP BY customer_segment
ORDER BY процент_оттока DESC;

-- 2. Отток по уровню лояльности: помогает ли программа удерживать клиентов
SELECT
  loyalty_level AS уровень,
  COUNT(*) AS всего,
  SUM(CASE WHEN exit THEN 1 ELSE 0 END) AS ушло,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
GROUP BY loyalty_level
ORDER BY процент_оттока DESC;

-- 3. Сегмент и лояльность вместе: проверить, не одно ли это и то же
SELECT
  customer_segment AS сегмент,
  loyalty_level AS лояльность,
  COUNT(*) AS всего,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
GROUP BY customer_segment, loyalty_level
ORDER BY сегмент, лояльность;

-- 4. Пол в массовом сегменте: есть ли разница между мужчинами и женщинами
SELECT
  gender AS пол,
  COUNT(*) AS всего,
  SUM(CASE WHEN exit THEN 1 ELSE 0 END) AS ушло,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
WHERE customer_segment = 'Mass'
GROUP BY gender;

-- 5. Цифровой канал: реже ли уходят те, кто пользуется мобильным приложением
SELECT
  digital_behavior AS канал,
  COUNT(*) AS всего,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
GROUP BY digital_behavior;

-- 6. Возрастные группы: где отток выше
SELECT
  CASE
    WHEN age < 25 THEN '18-24'
    WHEN age < 35 THEN '25-34'
    WHEN age < 45 THEN '35-44'
    WHEN age < 55 THEN '45-54'
    ELSE '55+'
  END AS возраст,
  COUNT(*) AS всего,
  ROUND(100.0 * SUM(CASE WHEN exit THEN 1 ELSE 0 END) / COUNT(*), 2) AS процент_оттока
FROM bank_churn
GROUP BY возраст
ORDER BY возраст;