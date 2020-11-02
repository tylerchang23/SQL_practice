/* Join Exercises https://www.w3resource.com/sql-exercises/sql-joins-exercises.php */

/*
Salesman Table
 salesman_id |    name    |   city   | commission 
-------------+------------+----------+------------
        5001 | James Hoog | New York |       0.15
        5002 | Nail Knite | Paris    |       0.13
        5005 | Pit Alex   | London   |       0.11
        5006 | Mc Lyon    | Paris    |       0.14
        5007 | Paul Adam  | Rome     |       0.13
        5003 | Lauson Hen | San Jose |       0.12

Customer Table
customer_id |   cust_name    |    city    | grade | salesman_id 
-------------+----------------+------------+-------+-------------
        3002 | Nick Rimando   | New York   |   100 |        5001
        3007 | Brad Davis     | New York   |   200 |        5001
        3005 | Graham Zusi    | California |   200 |        5002
        3008 | Julian Green   | London     |   300 |        5002
        3004 | Fabian Johnson | Paris      |   300 |        5006
        3009 | Geoff Cameron  | Berlin     |   100 |        5003
        3003 | Jozy Altidor   | Moscow     |   200 |        5007
        3001 | Brad Guzan     | London     |       |        5005
*/

/* 1) Write a SQL statement to prepare a list with salesman name, customer name and
their cities for the salesmen and customer who belongs to the same city */
SELECT s.name, c.cust_name, s.City
FROM Salesman s
INNER JOIN Customer c
ON s.City = c.City 

/* 2) Write a SQL statement to make a list with order no, purchase amount, customer
name and their cities for those orders which order amount between 500 and 2000 */
SELECT o.ord_no, o.purch_amt, c.cust_name, c.city
FROM Orders o
INNER JOIN Customer c
ON o.customer_id = c.customer_id
WHERE o.purch_amt BETWEEN 500 AND 2000;

/* 3) Write a SQL statement to know which salesman are working for which customer */
SELECT s.name AS salesman_name, c.cust_name
FROM Salesman s
LEFT JOIN Customer c
ON s.salesman_id = c.salesman_id;

/* 4) Write a SQL statement to find the list of customers who appointed a salesman for
their jobs who gets a commission from the company is more than 12% */
SELECT c.cust_name, s.name AS salesman_name, s.commission
FROM Customer c
LEFT JOIN Salesman s
ON c.salesman_id = s.salesman_id
WHERE s.commission > 0.12;

/* 5) Write a SQL statement to find the list of customers who appointed a salesman for 
their jobs who does not live in the same city where their customer lives, and gets a commission
is above 12% */
SELECT c.cust_name, s.name AS salesman_name, c.city AS cust_city, s.city AS sales_city, s.commission
FROM Customer c
LEFT JOIN Salesman s
ON c.salesman_id = s.salesman_id
WHERE (c.city != s.city) AND (s.commission > 0.12);

/* 6) Write a SQL statement to find the details of a order i.e. order number, order date, 
amount of order, which customer gives the order and which salesman works for that customer 
and how much commission he gets for an order. */
SELECT o.ord_no, o.ord_date, o.purch_amt, c.cust_name, s.name AS salesman_name, s.commission
FROM Orders o
INNER JOIN Customer c
ON o.salesman_id = c.salesman_id
INNER JOIN Salesman s
ON o.salesman_id = s.salesman_id

/* 7) Write a SQL statement to make a join on the tables salesman, customer and orders 
in such a form that the same column of each table will appear once and only the relational 
rows will come. */
SELECT *
FROM Orders
NATURAL JOIN Customer
NATURAL JOIN Salesman;

/* 8) Write a SQL statement to make a list in ascending order for the customer who works
either through a salesman or by own. */
SELECT c.cust_name, s.name AS salesman_name
FROM Customer c 
LEFT JOIN Salesman s
ON c.salesman_id = s.salesman_id
ORDER BY c.cust_name;

/* Here we use an Outer Join to account for the possibility that the customer was not helped
by a salesman (not the case here though) */

/* 9) Write a SQL statement to make a list in ascending order for the customer who holds a 
grade less than 300 and works either through a salesman or by own. */
SELECT c.cust_name, s.name AS salesman_name
FROM Customer c
LEFT JOIN Salesman s
ON c.salesman_id = s.salesman_id
WHERE c.grade < 300
ORDER BY c.cust_name;

/* 10) Write a SQL statement to make a report with customer name, city, order number, 
order date, and order amount in ascending order according to the order date to find that 
either any of the existing customers have placed no order or placed one or more orders. */
SELECT c.cust_name, c.city, o.ord_no, o.ord_date, o.purch_amt
FROM Customer c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
ORDER BY o.ord_date;

/* 11) Write a SQL statement to make a report with customer name, city, order number, order 
date, order amount salesman name and commission to find that either any of the existing customers 
have placed no order or placed one or more orders by their salesman or by own. */
SELECT c.cust_name, c.city, o.ord_no, o.ord_date, o.purch_amt. s.name AS salesman_name, s.commission
FROM Customer c
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
LEFT JOIN salesman s
ON c.salesman_id = s.salesman_id;

/* 12) Write a SQL statement to make a list in ascending order for the salesmen who works either 
for one or more customer or not yet join under any of the customers. */ 
SELECT s.name AS salesman_name
FROM Salesman s
LEFT JOIN Customer c
ON s.salesman_id = c.salesman_id
ORDER BY salesman_name

/* 13) Write a SQL statement to make a list for the salesmen who works either for one or more
customer or not yet join under any of the customers who placed either one or more orders or no
order to their supplier */
SELECT s.name AS salesman_name
FROM Salesman s
LEFT JOIN Customer c
ON s.salesman_id = c.salesman_id
LEFT JOIN Orders o
ON c.salesman_id = o.salesman_id