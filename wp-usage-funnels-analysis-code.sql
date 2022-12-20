/*2022-12-02*/
/* WARBY PARKER USAGE FUNNELS ANALYSIS CODE */


-- PAGE 5: Survey Funnel: Query

SELECT question, COUNT(user_id) AS 'response count'
FROM survey
WHERE response IS NOT NULL
GROUP BY question
ORDER BY question ASC;

-- PAGE 10: Purchase Funnel: Query

SELECT DISTINCT q.user_id
    , q.user_id IS NOT NULL AS quiz_complete
    , h.user_id IS NOT NULL AS is_home_try_on
    , h.number_of_pairs
    , p.user_id IS NOT NULL AS is_purchase
FROM quiz q
LEFT JOIN home_try_on h 
    ON q.user_id = h.user_id
LEFT JOIN purchase p
    ON p.user_id = q.user_id;

-- PAGE 12: Conversion Rate: Quiz -> home_try_on

WITH quiz_to_hto AS (
    SELECT DISTINCT q.user_id
    , q.user_id IS NOT NULL AS quiz_complete
    , h.user_id IS NOT NULL AS is_home_try_on
    , h.number_of_pairs
    , p.user_id IS NOT NULL AS is_purchase
FROM quiz q
LEFT JOIN home_try_on h 
    ON q.user_id = h.user_id
LEFT JOIN purchase p
    ON p.user_id = q.user_id
)
SELECT (1.0 * SUM(is_home_try_on) / SUM(quiz_complete)) AS quiz_to_hto_conversion_rate
FROM quiz_to_hto;

-- PAGE 14: Conversion Rate: home_try_on -> purchase

WITH ab_test AS (
    SELECT DISTINCT q.user_id
    , q.user_id IS NOT NULL AS quiz_complete
    , h.user_id IS NOT NULL AS is_home_try_on
    , h.number_of_pairs
    , p.user_id IS NOT NULL AS is_purchase
FROM quiz q
LEFT JOIN home_try_on h 
    ON q.user_id = h.user_id
LEFT JOIN purchase p
    ON p.user_id = q.user_id
)
SELECT (1.0 * SUM(is_purchase) / SUM(is_home_try_on)) AS HTO_to_purchase_rate
FROM ab_test;

-- PAGE 17: A/B Test Purchase Rate (2)

WITH ab_test AS (
  SELECT DISTINCT q.user_id
    , h.number_of_pairs
    , q.user_id IS NOT NULL AS quiz_complete
    , h.user_id IS NOT NULL AS is_home_try_on
    , p.user_id IS NOT NULL AS is_purchase
  FROM quiz q
  LEFT JOIN home_try_on h ON q.user_id = h.user_id
  LEFT JOIN purchase p ON p.user_id = q.user_id
)
SELECT
  CASE WHEN number_of_pairs = '3 pairs' THEN 'group_a'
       WHEN number_of_pairs = '5 pairs' THEN 'group_b' END AS group_name
  , SUM(is_purchase) as purchased_users
  , SUM(is_home_try_on) as home_try_on_users
  , CASE WHEN SUM(is_home_try_on) = 0 THEN 0 ELSE ROUND((CAST(SUM(is_purchase) AS FLOAT) / CAST(SUM(is_home_try_on) AS FLOAT)), 2) END AS purchase_rate
FROM ab_test
GROUP BY group_name
HAVING group_name IS NOT NULL;