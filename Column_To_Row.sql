CREATE TABLE pivot_test (
  id            NUMBER,
  customer_id   NUMBER,
  product_code  VARCHAR2(5),
  quantity      NUMBER
);

INSERT INTO pivot_test VALUES (1, 1, 'A', 10);
INSERT INTO pivot_test VALUES (2, 1, 'B', 20);
INSERT INTO pivot_test VALUES (3, 1, 'C', 30);
INSERT INTO pivot_test VALUES (4, 2, 'A', 40);
INSERT INTO pivot_test VALUES (5, 2, 'C', 50);
INSERT INTO pivot_test VALUES (6, 3, 'A', 60);
INSERT INTO pivot_test VALUES (7, 3, 'B', 70);
INSERT INTO pivot_test VALUES (8, 3, 'C', 80);
INSERT INTO pivot_test VALUES (9, 3, 'D', 90);
INSERT INTO pivot_test VALUES (10, 4, 'A', 100);
COMMIT;
----------
select * from pivot_test t;
----------
select *
  from (select product_code, quantity from pivot_test)
pivot(sum(quantity) as sum_quantity
   for(product_code) in('A' as a, 'B' as b, 'C' as c));
----------
select *
  from (select customer_id, product_code, quantity from pivot_test)
pivot(sum(quantity) as sum_quantity
   for(product_code) in('A' as a, 'B' as b, 'C' as c))
 order by customer_id;
----------
select sum(decode(product_code, 'A', quantity, 0)) as a_sum_quantity,
       sum(decode(product_code, 'B', quantity, 0)) as b_sum_quantity,
       sum(decode(product_code, 'C', quantity, 0)) as c_sum_quantity
  from pivot_test
 order by customer_id;
----------
select customer_id,
       sum(decode(product_code, 'A', quantity, 0)) as a_sum_quantity,
       sum(decode(product_code, 'B', quantity, 0)) as b_sum_quantity,
       sum(decode(product_code, 'C', quantity, 0)) as c_sum_quantity
  from pivot_test
 group by customer_id
 order by customer_id;
