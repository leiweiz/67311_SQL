-- GROUP BY vs ORDER BY; Refining GROUP BY in steps
SELECT project_id, reporter_id, resolver_id FROM defects ORDER BY project_id;

SELECT COUNT(*) FROM defects;

SELECT project_id, COUNT(*) FROM defects; -- fails

SELECT project_id, COUNT(*) FROM defects GROUP BY project_id;

SELECT project_id, COUNT(*) FROM defects GROUP BY project_id ORDER BY project_id;

SELECT p.name, COUNT(*) FROM defects d JOIN projects p ON p.id=d.project_id GROUP BY p.name ORDER BY p.name;	

SELECT project_id, reporter_id, COUNT(*) FROM defects GROUP BY project_id, reporter_id ORDER BY project_id, reporter_id;
-- SELECT project_id, reporter_id, COUNT(*) FROM defects GROUP BY project_id ORDER BY project_id, reporter_id; -- fails
SELECT project_id, COUNT(*) FROM defects WHERE reporter_id = 13 GROUP BY project_id ORDER BY project_id;
SELECT project_id, ARRAY_AGG(id) FROM defects WHERE reporter_id = 13 GROUP BY project_id ORDER BY project_id;
SELECT project_id, ARRAY_AGG(reporter_id), COUNT(*) FROM defects GROUP BY project_id ORDER BY project_id;


-- GROUP BY with three components (more fragmented)
SELECT project_id, reporter_id, resolver_id, COUNT(*) 
FROM defects 
GROUP BY project_id, reporter_id, resolver_id 
ORDER BY project_id, reporter_id, resolver_id;



-- not as informative..
SELECT ranking, reporter_id, resolver_id 
FROM defects d JOIN severities s ON d.severity_id = s.id 
WHERE d.project_id = 4 
ORDER BY ranking;

-- better with correlated subquery
SELECT resolver_id, 
(SELECT ROUND(AVG(s1.ranking),2) FROM defects d1 JOIN severities s1 ON d1.severity_id=s1.id WHERE d1.resolver_id=d.resolver_id) AS "Avg Ranking" 
FROM defects d JOIN severities s ON d.severity_id = s.id 
WHERE d.project_id = 4 
GROUP BY resolver_id 
ORDER BY resolver_id;

-- didn't really need to still join defects to severities in the main query...
SELECT resolver_id, 
(SELECT ROUND(AVG(s1.ranking),2) FROM defects d1 JOIN severities s1 ON d1.severity_id=s1.id WHERE d1.resolver_id=d.resolver_id) AS "Avg Ranking" 
FROM defects d
WHERE d.project_id = 4 
GROUP BY resolver_id 
ORDER BY resolver_id;
