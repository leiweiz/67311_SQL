---------------------
-- JOINING TWO TABLES
---------------------
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i ON h.hero_id=i.hero_id;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h INNER JOIN identities i ON h.hero_id=i.hero_id;

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h NATURAL JOIN identities i;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i USING (hero_id);

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h LEFT JOIN identities i ON h.hero_id=i.hero_id;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h LEFT OUTER JOIN identities i ON h.hero_id=i.hero_id;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h NATURAL LEFT JOIN identities i;

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h RIGHT OUTER JOIN identities i ON h.hero_id=i.hero_id;

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h FULL OUTER JOIN identities i ON h.hero_id=i.hero_id;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h FULL JOIN identities i ON h.hero_id=i.hero_id;

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h CROSS JOIN identities i;


-----------------------
-- JOINING THREE TABLES
-----------------------
SELECT name, first_name, last_name FROM heroes h JOIN identities i ON h.hero_id=i.hero_id JOIN people p ON p.person_id=i.person_id;
SELECT name, first_name, last_name FROM (heroes h JOIN identities i ON h.hero_id=i.hero_id) JOIN people p ON p.person_id=i.person_id;

SELECT name, first_name, last_name FROM heroes h LEFT JOIN identities i ON h.hero_id=i.hero_id JOIN people p ON p.person_id=i.person_id;
SELECT name, first_name, last_name FROM (heroes h LEFT JOIN identities i ON h.hero_id=i.hero_id) JOIN people p ON p.person_id=i.person_id;
SELECT name, first_name, last_name FROM heroes h LEFT JOIN (identities i JOIN people p ON p.person_id=i.person_id) AS i2 ON h.hero_id=i2.hero_id ;

SELECT name, first_name, last_name FROM heroes h LEFT JOIN identities i ON h.hero_id=i.hero_id LEFT JOIN people p ON p.person_id=i.person_id;
SELECT name, first_name, last_name FROM heroes h FULL OUTER JOIN identities i ON h.hero_id=i.hero_id JOIN people p ON p.person_id=i.person_id;
SELECT name, first_name, last_name FROM heroes h JOIN identities i ON h.hero_id=i.hero_id FULL OUTER JOIN people p ON p.person_id=i.person_id;
SELECT name, first_name, last_name FROM heroes h FULL OUTER JOIN identities i ON h.hero_id=i.hero_id FULL OUTER JOIN people p ON p.person_id=i.person_id;


---------------------------
-- GETTING EXCLUDED RECORDS
---------------------------
SELECT * FROM heroes h LEFT OUTER JOIN identities i ON h.hero_id=i.hero_id WHERE i.hero_id IS NULL;
SELECT * FROM heroes h FULL OUTER JOIN identities i ON h.hero_id=i.hero_id WHERE i.hero_id IS NULL;
SELECT * FROM heroes h FULL OUTER JOIN identities i ON h.hero_id=i.hero_id WHERE i.hero_id IS NULL OR h.hero_id IS NULL;


---------------------------------------------------------
-- SELF JOINS  (switch to advising db; \connect advising)
---------------------------------------------------------
SELECT students.first_name || ' ' || students.last_name AS student
  , advisors.first_name || ' ' || advisors.last_name AS advisor
FROM people AS students 
JOIN people AS advisors 
ON students.advisor_id=advisors.person_id
ORDER BY students.last_name, students.first_name;

SELECT *
FROM people AS students 
JOIN people AS advisors 
ON students.advisor_id=advisors.person_id
ORDER BY students.last_name, students.first_name;


-------------------------
-- NON-EQUI (THETA) JOINS
-------------------------
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i ON h.hero_id < 3 ORDER BY h.hero_id, i.hero_id;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i ON h.hero_id < 3 AND i.hero_id < 3 ORDER BY h.hero_id, i.hero_id;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i ON name LIKE '%man' ORDER BY h.hero_id, i.hero_id;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i ON power LIKE '%flys%' ORDER BY h.hero_id, i.hero_id;
SELECT p.last_name, p.first_name, i.hero_id, i.person_id FROM people p JOIN identities i ON p.last_name IS NULL ORDER BY p.last_name, p.first_name;

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h LEFT JOIN identities i ON h.hero_id=i.hero_id WHERE name LIKE '%man';
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h LEFT JOIN identities i ON h.hero_id=i.hero_id AND name LIKE '%man';

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h CROSS JOIN identities i;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h, identities i;
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i ON 1=1;

SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h JOIN identities i; -- FAIL b/c need ON clause
SELECT h.hero_id, h.name, i.hero_id, i.person_id FROM heroes h FULL JOIN identities i; -- FAIL b/c need ON clause for full joins too

SELECT COUNT(*) FROM heroes h, identities i;
SELECT COUNT(*) FROM heroes h JOIN identities i ON 1=1;

-- throwing in a self-joins to boot ...
SELECT p1.first_name AS longer, p2. first_name AS shorter
FROM people p1 JOIN people p2 
ON length(p1.first_name) > length(p2.first_name);
-- FYI ...
SELECT p1.first_name, COUNT(*) AS "number shorter"
FROM people p1 JOIN people p2 
ON length(p1.first_name) > length(p2.first_name)
GROUP BY p1.first_name;

-- Bottom line: be very careful doing non-equi joins; lots of people screw these up badly


----------------------------------
-- DATA COMING FROM ANOTHER SELECT
----------------------------------
SELECT first_name, last_name, name 
FROM (
	SELECT * FROM heroes h 
	JOIN identities i ON h.hero_id=i.hero_id 
	JOIN people p ON p.person_id=i.person_id 
	WHERE power LIKE '%flys%') AS hero_identities;
	
SELECT p.first_name, p.last_name, h.name 
FROM (
	SELECT * FROM heroes h 
	JOIN identities i ON h.hero_id=i.hero_id 
	JOIN people p ON p.person_id=i.person_id 
	WHERE power LIKE '%flys%') AS hero_identities; -- FAIL b/c p, h not known
	
SELECT first_name, last_name, name 
FROM (
	SELECT * FROM heroes h 
	JOIN identities i ON h.hero_id=i.hero_id 
	JOIN people p ON p.person_id=i.person_id 
	WHERE power LIKE '%flys%'); -- FAIL b/c no AS alias