-- MVCC DEMO 
-- in connection #1
BEGIN;
UPDATE heroes SET age = 48 WHERE hero_id = 1;
UPDATE heroes SET age = 42 WHERE hero_id = 14;
UPDATE heroes SET age = 37 WHERE hero_id = 6;
SELECT * FROM heroes;

-- in connection #2
SELECT * FROM heroes;
SELECT * FROM people;
UPDATE people SET email = 'dgreyson@wayne.net' WHERE person_id = 5;
SELECT * FROM people;
UPDATE heroes SET age = 23 WHERE hero_id = 5;
SELECT * FROM heroes;

-- in connection #1
SELECT * FROM heroes;

-- in connection #2
UPDATE heroes SET name = 'The Tick' WHERE hero_id = 14;

-- in connection #1
SELECT * FROM heroes;

-- in connection #2
UPDATE heroes SET age = 50 WHERE hero_id = 1;

-- in connection #1
COMMIT;

-- in connection #2
SELECT * FROM heroes;
	
