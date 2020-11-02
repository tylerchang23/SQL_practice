/* Subquery Exercises https://www.w3resource.com/sql-exercises/subqueries/index.php */

/*
Salesman Table
salesman_id  name        city        commission
-----------  ----------  ----------  ----------
5001         James Hoog  New York    0.15
5002         Nail Knite  Paris       0.13
5005         Pit Alex    London      0.11
5006         Mc Lyon     Paris       0.14
5003         Lauson Hen  San Jose    0.12
5007         Paul Adam   Rome        0.13

Orders Table
ord_no      purch_amt   ord_date    customer_id  salesman_id
----------  ----------  ----------  -----------  -----------
70001       150.5       2012-10-05  3005         5002
70009       270.65      2012-09-10  3001         5005
70002       65.26       2012-10-05  3002         5001
70004       110.5       2012-08-17  3009         5003
70007       948.5       2012-09-10  3005         5002
70005       2400.6      2012-07-27  3007         5001
70008       5760        2012-09-10  3002         5001
70010       1983.43     2012-10-10  3004         5006
70003       2480.4      2012-10-10  3009         5003
70012       250.45      2012-06-27  3008         5002
70011       75.29       2012-08-17  3003         5007
70013       3045.6      2012-04-25  3002         5001

Customers Table
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


/* 1) Write a query to display all the orders from the orders table issued by the salesman 'Paul Adam'. */
SELECT * FROM Orders
WHERE salesman_id  = 
    (SELECT salesman_id FROM Salesman s
     WHERE s.Name = 'Paul Adam');


/* 2) Write a query to display all the orders for the salesman who belongs to the city London. */
SELECT * FROM Orders
WHERE salesman_id =
    (SELECT salesman_id FROM Salesman
     WHERE city = 'London');

/* 3) Write a query to find all the orders issued against the salesman who may works for customer whose id is 3007. */
SELECT * FROM Orders
WHERE salesman_id = 
    (SELECT salesman_id FROM Salesman
     WHERE customer_id = '3007');

/* 4) Write a query to display all the orders which values are greater than the average order value for 10th October 2012. */
SELECT * FROM Orders
WHERE purch_amt > 
        (SELECT AVG(purch_amt) FROM Orders
         WHERE ord_date = '2012-10-10');

/* 5)  Write a query to find all orders attributed to a salesman in New York. */
SELECT * FROM Orders
WHERE salesman_id IN 
    (SELECT salesman_id FROM Salesman
     WHERE city = 'New York');

/* 6) Write a query to display the commission of all the salesmen servicing customers in Paris. */
SELECT commission FROM Salesman
WHERE salesman_id IN
    (SELECT salesman_id FROM Customer
     WHERE city = 'Paris');

/* 7) Write a query to display all the customers whose id is 2001 bellow the salesman ID of Mc Lyon. */
SELECT cust_name FROM Customer
WHERE customer_id = 
    ((SELECT salesman_id FROM Salesman s WHERE s.Name = 'Mc Lyon')) - 2001;
    
/* 8) Write a query to count the customers with grades above New York's average. */
SELECT COUNT(cust_name) FROM Customer
WHERE grade > (SELECT AVG(grade) FROM Customer
               WHERE city = 'New York' );

/* This is the total count ^ We could have also grouped by 'grade' type to get counts per group (solution on site) */ 

/* 9) Write a query to extract the data from the orders table for those salesman who earned the maximum commission */
SELECT * FROM Orders
WHERE salesman_id IN
    (SELECT salesman_id FROM Salesman
     WHERE commission = (SELECT MAX(commission) FROM salesman));

/* 10) Write a query to display all the customers with orders issued on date 17th August, 2012. */
SELECT cust_name FROM Customer
WHERE customer_id IN
    (SELECT customer_id FROM Orders
     WHERE ord_date = '2012-08-17');

/* 11) Write a query to find the name and numbers of all salesmen who had more than one customer. */
SELECT s.salesman_id, s.name FROM Salesman s
WHERE salesman_id IN
    (SELECT salesman_id FROM Customer
     GROUP BY salesman_id
     HAVING COUNT(salesman_id) > 1);

/* 12) Write a query to find all orders with order amounts which are above-average amounts for their customers. */
SELECT * FROM Orders a
WHERE purch_amt >
    (SELECT AVG(purch_amt) FROM orders b
     WHERE b.customer_id = a.customer_id);

/* inner query -> gets the average purchase amount FOR EACH customer (could have also joined tables)

/* 13) Write a queries to find all orders with order amounts which are on or above-average amounts for their customers. */
SELECT * FROM Orders a
WHERE purch_amt >=
    (SELECT AVG(purch_amt) FROM orders b
     WHERE b.customer_id = a.customer_id);

/* 14) Write a query to find the sums of the amounts from the orders table, grouped by date, eliminating all those dates
 where the sum was not at least 1000.00 above the maximum order amount for that date. */
SELECT ord_date, SUM(purch_amt) FROM Orders a
GROUP BY ord_date
HAVING SUM(purch_amt) > 
    (SELECT MAX(purch_amt) + 1000 FROM Orders b
    WHERE a.ord_date = b.ord_date);

/* 15) Write a query to extract the data from the customer table if and only if one or more of the customers in the
 customer table are located in London. */
SELECT customer_id, cust_name, city FROM Customer
WHERE EXISTS
    (SELECT * FROM Customer
     WHERE City = 'London');