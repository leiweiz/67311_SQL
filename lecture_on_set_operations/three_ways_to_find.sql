-- Find only those records in heroes that are not in either marvel or dc (i.e., the Tick)
-- 
-- ----------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------
-- 
-- First, uisng set operations
SELECT name FROM heroes 
EXCEPT 
SELECT name FROM marvel 
EXCEPT 
SELECT name FROM dc 
ORDER BY name;

--                                                                                QUERY PLAN
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=16.68..16.71 rows=14 width=118) (actual time=0.050..0.050 rows=1 loops=1)
--    Sort Key: "*SELECT* 1".name
--    Sort Method: quicksort  Memory: 25kB
--    ->  HashSetOp Except  (cost=0.00..16.41 rows=14 width=118) (actual time=0.042..0.042 rows=1 loops=1)
--          ->  Append  (cost=0.00..16.36 rows=21 width=118) (actual time=0.031..0.040 rows=13 loops=1)
--                ->  Result  (cost=0.00..15.22 rows=14 width=118) (actual time=0.030..0.032 rows=6 loops=1)
--                      ->  HashSetOp Except  (cost=0.00..15.22 rows=14 width=118) (actual time=0.029..0.029 rows=6 loops=1)
--                            ->  Append  (cost=0.00..14.86 rows=143 width=118) (actual time=0.005..0.018 rows=23 loops=1)
--                                  ->  Subquery Scan on "*SELECT* 1"  (cost=0.00..1.28 rows=14 width=118) (actual time=0.005..0.009 rows=14 loops=1)
--                                        ->  Seq Scan on heroes  (cost=0.00..1.14 rows=14 width=118) (actual time=0.005..0.009 rows=14 loops=1)
--                                  ->  Subquery Scan on "*SELECT* 2"  (cost=0.00..13.58 rows=129 width=118) (actual time=0.002..0.008 rows=9 loops=1)
--                                        ->  Result  (cost=0.00..12.29 rows=129 width=118) (actual time=0.001..0.005 rows=9 loops=1)
--                                              ->  Append  (cost=0.00..12.29 rows=129 width=118) (actual time=0.001..0.004 rows=9 loops=1)
--                                                    ->  Seq Scan on marvel  (cost=0.00..1.09 rows=9 width=118) (actual time=0.001..0.002 rows=9 loops=1)
--                                                    ->  Seq Scan on marvel_clone marvel  (cost=0.00..11.20 rows=120 width=118) (actual time=0.001..0.001 rows=0 loops=1)
--                ->  Subquery Scan on "*SELECT* 3"  (cost=0.00..1.14 rows=7 width=118) (actual time=0.002..0.004 rows=7 loops=1)
--                      ->  Seq Scan on dc  (cost=0.00..1.07 rows=7 width=118) (actual time=0.002..0.002 rows=7 loops=1)
--  Total runtime: 0.119 ms
-- (18 rows)


-- Second, using subqueries
SELECT name FROM heroes 
WHERE name NOT IN (SELECT name from marvel) 
AND name NOT IN (SELECT name FROM dc) 
ORDER BY name;

--                                                                  QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=14.95..14.96 rows=4 width=118) (actual time=0.051..0.051 rows=1 loops=1)
--    Sort Key: heroes.name
--    Sort Method: quicksort  Memory: 25kB
--    ->  Seq Scan on heroes  (cost=13.70..14.91 rows=4 width=118) (actual time=0.045..0.045 rows=1 loops=1)
--          Filter: ((NOT (hashed SubPlan 1)) AND (NOT (hashed SubPlan 2)))
--          Rows Removed by Filter: 13
--          SubPlan 1
--            ->  Result  (cost=0.00..12.29 rows=129 width=118) (actual time=0.004..0.006 rows=9 loops=1)
--                  ->  Append  (cost=0.00..12.29 rows=129 width=118) (actual time=0.004..0.005 rows=9 loops=1)
--                        ->  Seq Scan on marvel  (cost=0.00..1.09 rows=9 width=118) (actual time=0.002..0.003 rows=9 loops=1)
--                        ->  Seq Scan on marvel_clone marvel  (cost=0.00..11.20 rows=120 width=118) (actual time=0.000..0.000 rows=0 loops=1)
--          SubPlan 2
--            ->  Seq Scan on dc  (cost=0.00..1.07 rows=7 width=118) (actual time=0.002..0.002 rows=7 loops=1)
--  Total runtime: 0.096 ms
-- (14 rows)


-- Finally, using (left) joins
SELECT name FROM heroes h 
LEFT JOIN marvel m USING (name) 
LEFT JOIN dc USING (name) 
WHERE m.hero_id IS NULL 
AND dc.hero_id IS NULL
ORDER BY h.name;

--                                                           QUERY PLAN
-- -------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=15.23..15.23 rows=1 width=118) (actual time=0.064..0.064 rows=1 loops=1)
--    Sort Key: h.name
--    Sort Method: quicksort  Memory: 25kB
--    ->  Hash Right Join  (cost=2.43..15.22 rows=1 width=118) (actual time=0.056..0.058 rows=1 loops=1)
--          Hash Cond: ((m.name)::text = (h.name)::text)
--          Filter: (m.hero_id IS NULL)
--          Rows Removed by Filter: 7
--          ->  Append  (cost=0.00..12.29 rows=129 width=122) (actual time=0.002..0.006 rows=9 loops=1)
--                ->  Seq Scan on marvel m  (cost=0.00..1.09 rows=9 width=122) (actual time=0.002..0.005 rows=9 loops=1)
--                ->  Seq Scan on marvel_clone m  (cost=0.00..11.20 rows=120 width=122) (actual time=0.000..0.000 rows=0 loops=1)
--          ->  Hash  (cost=2.42..2.42 rows=1 width=118) (actual time=0.033..0.033 rows=8 loops=1)
--                Buckets: 1024  Batches: 1  Memory Usage: 1kB
--                ->  Hash Left Join  (cost=1.16..2.42 rows=1 width=118) (actual time=0.025..0.028 rows=8 loops=1)
--                      Hash Cond: ((h.name)::text = (dc.name)::text)
--                      Filter: (dc.hero_id IS NULL)
--                      Rows Removed by Filter: 6
--                      ->  Seq Scan on heroes h  (cost=0.00..1.14 rows=14 width=118) (actual time=0.005..0.006 rows=14 loops=1)
--                      ->  Hash  (cost=1.07..1.07 rows=7 width=122) (actual time=0.010..0.010 rows=6 loops=1)
--                            Buckets: 1024  Batches: 1  Memory Usage: 1kB
--                            ->  Seq Scan on dc  (cost=0.00..1.07 rows=7 width=122) (actual time=0.003..0.004 rows=7 loops=1)
--  Total runtime: 0.119 ms
-- (21 rows)

-- ================================
-- At first glance, the best way appears to be with subqueries -- performance is considerably faster than either set 
-- operations or left joins.  However, problem with the subquery solution is that if there is a null record for name 
-- in either mavel or dc, then no results will be returned; this is not the case for the joins or set operations 
-- solutions.  Try it yourself to see.  This is another example of the perniciousness of nulls we discussed earlier 
-- in the semester.  In this case, there are no nulls in name, so all is good, but in the real world we can't be sure
-- that would always be the case; hence the fastest solution may not be the 'best' solution.  Between the remaining 
-- two the determinant of 'best' is going to depend on interpretibility/ease of understanding because the time is the 
-- same.  As you increase your familiarity with joins, it may seem as easy (or even easier) as the set operations, but 
-- many people find the set operations a little more intuitive.