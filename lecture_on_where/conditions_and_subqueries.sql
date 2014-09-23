-----------------------
-- WHERE CONDITIONS
-----------------------
-- NOT
SELECT * FROM people WHERE NOT height = 71;
SELECT * FROM people WHERE height <> 71;
SELECT * FROM people WHERE height != 71;
SELECT * FROM people WHERE NOT height != 71;
	-- most people use != or <> instead of NOT

-- BETWEEN
SELECT * FROM people WHERE height BETWEEN 68 AND 71;
SELECT * FROM people WHERE height >= 68 AND <= 71; -- fail
SELECT * FROM people WHERE height >= 68 AND height <= 71;

-- LIKE
SELECT * FROM people WHERE last_name LIKE 'Gr_yson';
SELECT * FROM people WHERE last_name LIKE 'Gr%yson';
SELECT * FROM people WHERE last_name LIKE 'G%';
SELECT * FROM people WHERE last_name LIKE 'g%';
SELECT * FROM people WHERE last_name LIKE '%G%';

SELECT * FROM people WHERE last_name SIMILAR TO 'G%';
SELECT * FROM people WHERE last_name SIMILAR TO '(G|J)%';

-- regex
SELECT * FROM people WHERE last_name ~ 'G';
SELECT * FROM people WHERE last_name ~* 'G';
SELECT * FROM people WHERE last_name !~* 'G';
SELECT * FROM people WHERE last_name ~* '^g';
SELECT * FROM people WHERE last_name ~* 'k$';
SELECT * FROM people WHERE last_name ~* '[uo]';
SELECT * FROM people WHERE height ~ '[7]'; -- fail b/c data type
SELECT * FROM heroes WHERE name ~* 'man$';
SELECT * FROM heroes WHERE name ~* 'man$' AND name !~* '^w';

SELECT * FROM heroes WHERE power ~* 'co+';
SELECT * FROM heroes WHERE power ~* 't';
SELECT * FROM heroes WHERE power ~* '\mt'; -- \m matches only at the beginning of a word (\M matches end of word)
SELECT * FROM heroes WHERE power ~* '\At'; -- \A matches only at the beginning of the string
SELECT * FROM heroes WHERE power ~* '\ys'; -- \y matches only at the beginning or end of a word
SELECT * FROM heroes WHERE power ~* '\Ys'; -- \Y matches only at a point that is not the beginning or end of a word

-- 
SELECT regexp_replace(power, 'flys', 'flies') FROM heroes;
SELECT regexp_replace(power, 'flys', 'flies') FROM heroes WHERE power ~ '\yf';

SELECT SUBSTRING(email, 1, 5) FROM people; 
SELECT SUBSTRING(email, 1) FROM people; 
SELECT SUBSTRING(email, 5) FROM people; 
SELECT SUBSTR(email, 5) FROM people; -- short-cut also works (try not to use in class)

SELECT SUBSTRING(email, POSITION('@' IN email)+1) FROM people;
SELECT SUBSTRING(email, 1, POSITION('@' IN email)-1) FROM people;
-- alt version (longer)
SELECT SUBSTRING(email FROM position('@' IN email)+1) FROM people;
SELECT SUBSTRING(email FROM 1 FOR position('@' IN email)-1) FROM people;


-- <, dates
SELECT * FROM heroes WHERE name < 'H';
SELECT * FROM heroes WHERE name < 'h';
	-- searching for dates (\connect creamery_311c)
SELECT * FROM employees WHERE date_of_birth < '1990-01-01';
	-- works widely; some treat as pure string (not postgres though)
	select substring(date_of_birth, 1, 4) from employees where last_name='Heimann'; -- fail
	select substring(to_char(date_of_birth,'YYYY-MM-DD'), 1, 4) from employees where last_name='Heimann';
	select extract(year from date_of_birth) from employees where last_name='Heimann'; -- just use date functions


-- AND / OR
SELECT * FROM people WHERE is_male = true AND height < 72 AND weight < 180;
SELECT * FROM people WHERE is_male = true AND height > 72 OR weight < 180;
SELECT * FROM people WHERE (is_male = true AND height > 72) OR weight < 180;
SELECT * FROM people WHERE is_male = true AND (height > 72 OR weight < 180);
  -- make it explicitly clear with parens

  -- interesting shortcut with AND in where...
	SELECT * FROM people WHERE CONCAT(last_name,first_name) LIKE 'W%';
	-- works if searching multiple fields for same string

-----------------------
-- BAISC SUBQUERIES
-----------------------

-- example
SELECT * FROM people p WHERE height = (SELECT MAX(height) FROM people p2);

SELECT person_id FROM identities WHERE hero_id = (SELECT hero_id FROM heroes WHERE name = 'Green Lantern');

SELECT last_name, first_name FROM people p JOIN identities i USING (person_id) 
JOIN heroes USING (hero_id) WHERE name = 'Green Lantern' ORDER BY last_name, first_name;

SELECT last_name, first_name FROM people WHERE person_id IN (
SELECT person_id FROM identities WHERE hero_id = (
SELECT hero_id FROM heroes WHERE name = 'Green Lantern'
)
) 
ORDER BY last_name, first_name;
-------- same thing on one line...
SELECT last_name, first_name FROM people WHERE person_id IN (SELECT person_id FROM identities WHERE hero_id = (SELECT hero_id FROM heroes WHERE name = 'Green Lantern')) ORDER BY last_name, first_name;

-- using IN on a predefined set (not always from a subquery)
SELECT * FROM heroes WHERE hero_id IN (4,5,6,8,9,10,11,12) ORDER BY name; -- Marvel Comics heroes
SELECT * FROM heroes WHERE hero_id NOT IN (4,5,6,8,9,10,11,12) ORDER BY name; -- DC Comics heroes


------------------------
-- CORRELATED SUBQUERIES
------------------------

SELECT s.assignment_id, s.date FROM shifts s 
ORDER BY s.assignment_id, date DESC;
-----
SELECT s.assignment_id, s.date FROM shifts s 
WHERE s.date IN (SELECT MAX(s1.date) from shifts s1) 
ORDER BY s.assignment_id, date DESC;
-----
SELECT s.assignment_id, s.date AS "Last Shift" FROM shifts s 
WHERE date = (SELECT MAX(date) FROM shifts s1 WHERE s1.assignment_id = s.assignment_id) 
ORDER BY s.assignment_id, date DESC;

 






