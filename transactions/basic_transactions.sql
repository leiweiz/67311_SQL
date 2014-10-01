-- SUCCESSFUL TRANSACTION
BEGIN;
UPDATE heroes SET age = 34 WHERE hero_id = 14;
SAVEPOINT first_leg;
UPDATE heroes SET age = 42;
-- did't mean to change age of everyone to 42... 
ROLLBACK TO first_leg;
UPDATE heroes SET age = 42 WHERE hero_id = 14;
COMMIT;
  -- everything is saved and updated as expected


-- TRANSACTION WITH SQL ERROR CAUSING ROLLBACK
BEGIN;
UPDATE heroes SET name = 'The Tickster' WHERE hero_id = 14;
SAVEPOINT first_leg;
UPDATE heroes SET age = 42;
-- did't mean to change age of everyone to 42... 
ROLLBACK TO first_leg;
SELECT * FROM heroes;
UPDATE heroes SET age = 42 WHERE id = 14;
-- error; it is hero_id, not id...
COMMIT;
	-- try to commit, but because of the error the transaction is rolled back

