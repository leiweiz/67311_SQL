-- PROBLEM: Find the major victories for hero_id = 1 (Batman) each month as 
-- well as a running total of his major victories year to date (YTD)


-- SOLUTION 1: using self joins
	-- Step 1: join each 'month' record with previous 'month' records (self-joins)
SELECT *
FROM victories v JOIN victories v1 ON (v.for_month>=v1.for_month) 
WHERE v.hero_id = 1
ORDER BY v.for_month;

	-- Step 2: group by month (and major) in order to aggregate
SELECT to_char(v.for_month,'Month YYYY') AS "Month", 
v.major AS "Victories", 
SUM(v1.major) AS "YTD"
FROM victories v JOIN victories v1 
ON (v.for_month>=v1.for_month) 
WHERE v.hero_id = 1 AND v1.hero_id = 1
GROUP BY v.for_month, v.major 
ORDER BY v.for_month;


-- SOLUTION 2: using a correlated subquery in SELECT clause
SELECT to_char(v.for_month,'Month YYYY') AS "Month"
	, v.major AS "Victories"
	, (SELECT SUM(major) FROM victories v1 WHERE v.for_month>=v1.for_month AND v1.hero_id=1) AS "YTD" 
FROM victories v 
WHERE v.hero_id = 1 
ORDER BY v.for_month;


	-- experiment by asking what will happen when we drop the column alias
	-- --------------------------------------------------------------------
	
	-- Bottom line is that solution 1 will typically execute faster  
	-- but solution 2 is more intuitive
	
	
SELECT to_char(v.for_month,'Month YYYY') AS "Month", v.major AS "Victories", SUM(v1.major) AS "YTD" FROM victories v JOIN victories v1 ON (v.for_month>=v1.for_month) WHERE v.hero_id = 1 AND v1.hero_id = 1 GROUP BY v.for_month, v.major ORDER BY v.for_month;

-- superhero=# explain analyze SELECT to_char(v.for_month,'Month YYYY') AS "Month", v.major AS "Victories", SUM(v1.major) AS "YTD" FROM victories v JOIN victories v1 ON (v.for_month>=v1.for_month) WHERE v.hero_id = 1 AND v1.hero_id = 1 GROUP BY v.for_month, v.major ORDER BY v.for_month;
--                                                        QUERY PLAN
-- ------------------------------------------------------------------------------------------------------------------------
--  GroupAggregate  (cost=2.62..2.65 rows=1 width=12) (actual time=0.095..0.111 rows=8 loops=1)
--    ->  Sort  (cost=2.62..2.63 rows=1 width=12) (actual time=0.079..0.079 rows=36 loops=1)
--          Sort Key: v.for_month, v.major
--          Sort Method: quicksort  Memory: 26kB
--          ->  Nested Loop  (cost=0.00..2.61 rows=1 width=12) (actual time=0.022..0.062 rows=36 loops=1)
--                Join Filter: (v.for_month >= v1.for_month)
--                Rows Removed by Join Filter: 28
--                ->  Seq Scan on victories v  (cost=0.00..1.30 rows=1 width=8) (actual time=0.018..0.020 rows=8 loops=1)
--                      Filter: (hero_id = 1)
--                      Rows Removed by Filter: 16
--                ->  Seq Scan on victories v1  (cost=0.00..1.30 rows=1 width=8) (actual time=0.001..0.003 rows=8 loops=8)
--                      Filter: (hero_id = 1)
--                      Rows Removed by Filter: 16
--  Total runtime: 0.153 ms
-- (14 rows)



SELECT to_char(v.for_month,'Month YYYY') AS "Month", v.major AS "Victories", (SELECT SUM(major) FROM victories v1 WHERE v.for_month>=v1.for_month AND v1.hero_id=1) AS "YTD" FROM victories v WHERE v.hero_id = 1 ORDER BY v.for_month;

-- superhero=# explain analyze SELECT to_char(v.for_month,'Month YYYY') AS "Month", v.major AS "Victories", (SELECT SUM(major) FROM victories v1 WHERE v.for_month>=v1.for_month AND v1.hero_id=1) AS "YTD" FROM victories v WHERE v.hero_id = 1 ORDER BY v.for_month;
--                                                         QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=2.69..2.69 rows=1 width=8) (actual time=0.212..0.212 rows=8 loops=1)
--    Sort Key: v.for_month
--    Sort Method: quicksort  Memory: 25kB
--    ->  Seq Scan on victories v  (cost=0.00..2.68 rows=1 width=8) (actual time=0.075..0.175 rows=8 loops=1)
--          Filter: (hero_id = 1)
--          Rows Removed by Filter: 16
--          SubPlan 1
--            ->  Aggregate  (cost=1.36..1.37 rows=1 width=4) (actual time=0.010..0.011 rows=1 loops=8)
--                  ->  Seq Scan on victories v1  (cost=0.00..1.36 rows=1 width=4) (actual time=0.002..0.007 rows=4 loops=8)
--                        Filter: ((v.for_month >= for_month) AND (hero_id = 1))
--                        Rows Removed by Filter: 20
--  Total runtime: 0.299 ms
-- (12 rows)