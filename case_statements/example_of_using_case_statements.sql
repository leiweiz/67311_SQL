SELECT name AS "Superhero", to_char(v.for_month,'Month YYYY') AS "Month", (SUM(major) * 3 + SUM(minor)) AS "Score", 
CASE WHEN (SUM(major) * 3 + SUM(minor)) > 25
THEN 'Awesome'
WHEN (SUM(major) * 3 + SUM(minor)) BETWEEN 16 AND 25 
THEN 'Very good'
WHEN (SUM(major) * 3 + SUM(minor)) BETWEEN 10 AND 15 
THEN 'Good; solid'
WHEN (SUM(major) * 3 + SUM(minor)) BETWEEN 5 AND 9 
THEN 'Adequate'
WHEN (SUM(major) * 3 + SUM(minor)) BETWEEN 1 AND 4 
THEN 'Needs improvement'
ELSE 'Are you even trying??'
END AS "Performance"
FROM victories v JOIN heroes h USING (hero_id)
GROUP BY name, for_month
ORDER BY name, for_month;


-- SELECT name AS "Superhero", to_char(v.for_month,'Month YYYY') AS "Month", (SUM(major) * 3 + SUM(minor)) AS "Score", 
-- CASE WHEN "Score" > 25
-- THEN 'Awesome'
-- WHEN "Score" BETWEEN 16 AND 25 
-- THEN 'Very good'
-- WHEN "Score" BETWEEN 10 AND 15 
-- THEN 'Good; solid'
-- WHEN "Score" BETWEEN 5 AND 9 
-- THEN 'Adequate'
-- WHEN "Score" BETWEEN 1 AND 4 
-- THEN 'Needs improvement'
-- ELSE 'Are you even trying??'
-- END AS "Performance"
-- FROM victories v JOIN heroes h USING (hero_id)
-- GROUP BY name, for_month
-- ORDER BY name, for_month;