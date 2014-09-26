SELECT * FROM victories ORDER BY hero_id, for_month;

SELECT * FROM victories GROUP BY hero_id ORDER BY for_month; -- fail
SELECT hero_id, COUNT(*) FROM victories GROUP BY hero_id ORDER BY hero_id; -- not particularly interesting
SELECT hero_id, SUM(major), SUM(minor) FROM victories GROUP BY hero_id ORDER BY hero_id; 
SELECT hero_id, SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" FROM victories GROUP BY hero_id ORDER BY hero_id; 
SELECT h.name AS "Hero", SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" FROM victories v JOIN heroes h USING (hero_id) GROUP BY h.name ORDER BY h.name; 
SELECT h.name AS "Hero", SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" FROM victories v NATURAL JOIN heroes h GROUP BY h.name ORDER BY h.name; -- alt since only hero_id in common

-- -- wanting to add in for_month (how is this different from first select * query?  ...limit of grouping)
-- SELECT hero_id, for_month, SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" FROM victories GROUP BY hero_id, for_month ORDER BY hero_id, for_month; 


-- Using column aliases
SELECT for_month, SUM(minor) AS "Minor Victories" 
FROM victories 
GROUP BY for_month 
HAVING SUM(minor) > 50 
ORDER BY for_month;

SELECT for_month, SUM(minor) AS "Minor Victories" 
FROM victories 
GROUP BY for_month 
HAVING "Minor Victories" > 50 
ORDER BY for_month;

SELECT for_month, SUM(minor) AS "Minor Victories" 
FROM victories 
GROUP BY for_month 
HAVING SUM(minor) > 50 
ORDER BY "Minor Victories";

-- Skewering Superman
SELECT hero_id, SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" 
FROM victories 
GROUP BY hero_id
ORDER BY hero_id;

SELECT name, SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" 
FROM victories v JOIN heroes h USING (hero_id)
GROUP BY name
ORDER BY name;

SELECT name, SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" 
FROM victories v JOIN heroes h USING (hero_id)
GROUP BY name, major
ORDER BY name;

SELECT name, SUM(major) AS "Major Victories", SUM(minor) AS "Minor Victories" 
FROM victories v JOIN heroes h USING (hero_id)
GROUP BY name, major, minor
ORDER BY name;

SELECT name, COUNT(major) AS "Months w/o Major Victory" 
FROM victories v JOIN heroes h USING (hero_id)
WHERE major = 0
GROUP BY name
ORDER BY name;

SELECT name, COUNT(major) AS "Months w/o Major Victory", COUNT(minor) AS "Months w/o Minor Victory" 
FROM victories v JOIN heroes h USING (hero_id)
GROUP BY name
HAVING major = 0 OR minor = 0
ORDER BY name;



-- try with subquery ... 
SELECT DISTINCT name, (
	SELECT COUNT(*) FROM victories v1 WHERE v1.hero_id=v.hero_id AND v1.major = 0
	) AS "Months w/o Major Victory", (
	SELECT COUNT(*) FROM victories v2 WHERE v2.hero_id=v.hero_id AND v2.minor = 0
	) AS "Months w/o Minor Victory"
FROM victories v JOIN heroes h USING (hero_id)
ORDER BY name;

-- w/o the joins, we get all the heroes including those not in the victories table
SELECT DISTINCT name, (
	SELECT COUNT(*) FROM victories v1 WHERE v1.hero_id=h.hero_id AND v1.major = 0
	) AS "Months w/o Major Victory", (
	SELECT COUNT(*) FROM victories v2 WHERE v2.hero_id=h.hero_id AND v2.minor = 0
	) AS "Months w/o Minor Victory"
FROM heroes h
ORDER BY name;



-- why DISTINCT?  Compare with...
SELECT *
FROM victories v JOIN heroes h USING (hero_id)
ORDER BY name;