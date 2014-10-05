-- COMPETING TRANSACTIONS & LOCKING DEMO 

-- in connection #1
BEGIN;
UPDATE heroes SET age = 50 WHERE hero_id = 1;
SELECT * FROM heroes;

-- in connection #2
BEGIN;
UPDATE heroes SET age = 42 WHERE hero_id = 14;
SELECT * FROM heroes;

-- introduce the deadlock
-- in connection #1
UPDATE heroes SET age = 43 WHERE hero_id = 14;
SELECT * FROM heroes;

-- in connection #2
UPDATE heroes SET age = 49 WHERE hero_id = 1;
-- deadlock is detected and broken by postgres

-- in connection #1
SELECT * FROM heroes;

-- in connection #2
SELECT * FROM heroes; -- won't do anything until transaction finished
COMMIT; -- will rollback automatically

-- in connection #1
SELECT * FROM heroes;
LOCK TABLE heroes IN ACCESS EXCLUSIVE MODE;
UPDATE heroes SET age = 44 WHERE hero_id = 14;

-- in connection #2
SELECT * FROM heroes;

-- in connection #1
COMMIT;
	
