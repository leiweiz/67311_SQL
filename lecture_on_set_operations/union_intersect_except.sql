SELECT name FROM dc ORDER BY name;

SELECT name FROM marvel ORDER BY name;

SELECT name FROM heroes ORDER BY name;

-- UNION and UNION ALL

SELECT name FROM dc UNION SELECT name FROM marvel ORDER BY name;

SELECT name FROM heroes UNION SELECT name FROM marvel ORDER BY name;

SELECT name, power FROM heroes UNION SELECT name, power FROM marvel ORDER BY name;

SELECT name FROM heroes UNION ALL SELECT name FROM marvel ORDER BY name; -- can be faster than UNION

-- SELECT name, power FROM heroes UNION ALL SELECT name, power FROM marvel ORDER BY name;

SELECT * FROM heroes UNION SELECT * FROM marvel ORDER BY name;

SELECT name FROM heroes UNION SELECT name, power FROM marvel ORDER BY name; -- fail b/c wrong num of cols

SELECT hero_id, name FROM heroes UNION SELECT name, power FROM marvel ORDER BY name; -- fail b/c mismatched data types

SELECT power, name FROM heroes UNION SELECT name, power FROM marvel ORDER BY name; -- works, even if makes no sense


-- INTERSECT and INTERSECT ALL

SELECT name FROM heroes INTERSECT SELECT name FROM marvel ORDER BY name;

SELECT name, power FROM heroes INTERSECT SELECT name, power FROM marvel ORDER BY name;

SELECT name FROM heroes INTERSECT ALL SELECT name FROM marvel ORDER BY name; -- faster than INTERSECT

SELECT name, power FROM heroes INTERSECT ALL SELECT name, power FROM marvel ORDER BY name;

SELECT name FROM marvel INTERSECT SELECT name FROM dc ORDER BY name;


-- EXCEPT and combos

SELECT name FROM heroes EXCEPT SELECT name FROM marvel ORDER BY name;

SELECT name, power FROM heroes EXCEPT SELECT name, power FROM marvel ORDER BY name;

SELECT name FROM marvel EXCEPT SELECT name FROM heroes ORDER BY name; -- order matters

SELECT name FROM heroes EXCEPT SELECT name FROM marvel EXCEPT SELECT name FROM dc ORDER BY name;

-- transition to class exercise on alt ways for finding this answer...