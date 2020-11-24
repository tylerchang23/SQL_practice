/* Top SQL Interview Questions */

/* Second Highest Salary
https://leetcode.com/problems/second-highest-salary/ */

/* Solution 1 */
/* Select the highest salary that isn't the current highest salary => The Second Highest */
SELECT MAX(e.Salary) AS "SecondHighestSalary"
FROM Employee e
WHERE e.Salary NOT IN (
    SELECT MAX(e.Salary)
    FROM Employee e
);
/* Solution 2 */
/* Order salaries in descending order, then get the first record after you take out the current first record (i.e. the second highest) */
/* NOTE: Assumes there exists a second highest salary */
SELECT DISTINCT e.Salary AS SecondHighestSalary
FROM Employee e
ORDER BY e.Salary DESC
LIMIT 1 OFFSET 1

/* - - - - - - - - - - */

/* Combine Two Tables 
https://leetcode.com/problems/combine-two-tables/ */

/* Solution */
/* Here we need to use a Left/Outer Join to ensure that everyone in the Person table is returned, regardless if they have an address listed. */
SELECT p.FirstName, p.LastName, a.City, a.State
FROM Person p
LEFT JOIN Address a
ON p.PersonId = a.PersonId;

/* - - - - - - - - - -  */

/* Nth Highest Salary
https://leetcode.com/problems/nth-highest-salary/ */

/* Solution */
/* First we need to eliminate duplicate salaries with DISTINCT */
/* After we order the salaries in descending orders, we'll take out or OFFSET the first N-1 rows so that the row that we want (Nth highest), is on top */
/* Now that the Nth highest salary is on top we simply need to LIMIT to the first row to return just the Nth highest salary. */ 
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N = N-1;
RETURN (
SELECT DISTINCT e.salary
FROM Employee e
ORDER BY e.salary DESC
LIMIT N, 1
);
END 

/* - - - - - - - - - -  */

/* Department Top Three Salaries 
https://leetcode.com/problems/department-top-three-salaries/solution/ */

/* Solution Nested Query */
/* For each DISTINCT salary, COUNT how many DISTINCT salaries are greater than the given salary. */
/* If there are less than 3 salaries that are greater than that given salary, that means that given salary is a Top 3 salary. */
SELECT d.Name AS 'Department', e1.Name AS 'Employee', e1.Salary
FROM Employee e1
JOIN Department d
ON e1.DepartmentId = d.Id
WHERE (
    SELECT COUNT(DISTINCT e2.salary)
    FROM Employee e2
    WHERE e2.Salary > e1.Salary
    AND e1.DepartmentId = e2.DepartmentId
) < 3

/* - - - - - - - - - -  */

/* Rank Scores
https://leetcode.com/problems/rank-scores/ */

/* Solution */
/* The rank of a salary is the number/COUNT of DISTINCT salaries that are greater than a given salary + 1 */
SELECT tbl1.Score AS 'Score', (
    SELECT COUNT(DISTINCT tbl2.Score)
    FROM Scores AS tbl2
    WHERE tbl2.Score > tbl1.Score
) + 1 AS 'Rank'
FROM Scores AS tbl1
ORDER BY tbl1.Score DESC 

/* - - - - - - - - - -  */

/* Trips and Users 
https://leetcode.com/problems/trips-and-users/ */

/* Solution */
/* First start by adding fields to the Trips table that determine whether a driver/client is banned or not*/
/* Then count the number of valid cancellations by unbanned users and also add to the Trips table*/
/* Finally calculate the cancellation rate by dividing the number of valid cancellations by the total*/
/* number of requests made.*/
WITH 
client_ban AS (
SELECT u.Users_Id, u.Banned
FROM Users u
WHERE u.Role = 'client') ,

driver_ban AS (
SELECT u.Users_Id, u.Banned
FROM Users u
WHERE u.Role = 'driver') ,

numValid_cancels AS (
SELECT t.Request_at, COUNT(t.Status) AS 'numValidCancels'
FROM trips t
LEFT JOIN client_ban AS cb
ON t.Client_Id = cb.Users_Id
LEFT JOIN driver_ban AS db
ON t.Driver_id = db.Users_Id
WHERE (cb.Banned = 'No' AND db.Banned = 'No') AND (t.Status = 'cancelled_by_driver' OR t.Status = 'cancelled_by_client')
GROUP BY t.Request_at)

SELECT t.Request_at AS 'Day', ROUND(IFNULL(nc.numValidCancels/COUNT(t.status), 0), 2) AS 'Cancellation Rate'
FROM Trips t
LEFT JOIN client_ban AS cb
ON t.Client_Id = cb.Users_Id
LEFT JOIN driver_ban AS db
ON t.Driver_Id = db.Users_Id
LEFT JOIN numValid_cancels AS nc
ON t.Request_at = nc.Request_at
WHERE cb.Banned = 'No' AND db.Banned = 'No'
AND t.Request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.Request_at

/* - - - - - - - - - -  */

/* Employees Earning More Than Their Managers 
https://leetcode.com/problems/employees-earning-more-than-their-managers/*/

/* My Solution */
/* The trick here is to first isolate the managers into their own table and figure out their salaries.
/* To do this, you'll need to inner join the Employee table to get rid of those those that don't have a manager */
/* Now that you have the manager's salaries you simply join this back to the original table and compare to the
/* rest of the employees. */

WITH managers_tbl AS (
SELECT e.Id, e.Salary
FROM Employee e
WHERE e.Id IN (SELECT e1.ManagerId
FROM Employee e1
INNER JOIN (
SELECT e.ManagerId 
FROM Employee e) e2
ON e1.ManagerId = e2.ManagerId)
)

SELECT e.Name AS 'Employee'
FROM Employee e
LEFT JOIN managers_tbl m
ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary

/* Alternate solution */
/* Instead of creating an entirely separate table of managers' salaries, we can instead self JOIN the table
/* on two conditions: */
/* 1) managerId = Id -> This will filter out the rows where an employee doesn't have a manager
/* 2) e.salary > m.salary -> This will keep the rows where the employee's (e) salary is more than their boss (m) */

SELECT e.Name AS 'Employee'
FROM Employee e
JOIN Employee m
ON e.ManagerId = m.Id
AND e.Salary > m.Salary

/* - - - - - - - - - -  */

/* Reformat Department Table
https://leetcode.com/problems/reformat-department-table/ */

/* Soulution 1) IF */
/* We simply need to output the revenue for a given combination of Id and Month, and output null if there isn't anything.
/* Why SUM? Since we group by Id, there will be months that have more than one value for a single id.
/* Thus, in order to select a single row for those occassions, we need to use an aggregate function on 
/* to condense into a single value. */

SELECT id,
SUM(IF(month = 'Jan', revenue, NULL)) AS Jan_Revenue,
SUM(IF(month = 'Feb', revenue, NULL)) AS Feb_Revenue,
SUM(IF(month = 'Mar', revenue, NULL)) AS Mar_Revenue,
SUM(IF(month = 'Apr', revenue, NULL)) AS Apr_Revenue,
SUM(IF(month = 'May', revenue, NULL)) AS May_Revenue,
SUM(IF(month = 'Jun', revenue, NULL)) AS Jun_Revenue,
SUM(IF(month = 'Jul', revenue, NULL)) AS Jul_Revenue,
SUM(IF(month = 'Aug', revenue, NULL)) AS Aug_Revenue,
SUM(IF(month = 'Sep', revenue, NULL)) AS Sep_Revenue,
SUM(IF(month = 'Oct', revenue, NULL)) AS Oct_Revenue,
SUM(IF(month = 'Nov', revenue, NULL)) AS Nov_Revenue,
SUM(IF(month = 'Dec', revenue, NULL)) AS Dec_Revenue
FROM Department
GROUP BY id

/* Solution 2) CASE WHEN */
/* Same idea, but just use CASE WHEN instead of IF() */

select id, 
sum(case when month = 'jan' then revenue else null end) as Jan_Revenue,
sum(case when month = 'feb' then revenue else null end) as Feb_Revenue,
sum(case when month = 'mar' then revenue else null end) as Mar_Revenue,
sum(case when month = 'apr' then revenue else null end) as Apr_Revenue,
sum(case when month = 'may' then revenue else null end) as May_Revenue,
sum(case when month = 'jun' then revenue else null end) as Jun_Revenue,
sum(case when month = 'jul' then revenue else null end) as Jul_Revenue,
sum(case when month = 'aug' then revenue else null end) as Aug_Revenue,
sum(case when month = 'sep' then revenue else null end) as Sep_Revenue,
sum(case when month = 'oct' then revenue else null end) as Oct_Revenue,
sum(case when month = 'nov' then revenue else null end) as Nov_Revenue,
sum(case when month = 'dec' then revenue else null end) as Dec_Revenue
from department
group by id
order by id
/* - - - - - - - - - -  */

/* Department Highest Salary 
https://leetcode.com/problems/department-highest-salary/ */

/* Solution /*
/* First we figure out the max salary for each department and save as a CTE */
/* Then we add this "max_dep_salary" field back to the original table and figure out which employees for */
/* a given department have this salary. */

WITH topDep AS (
SELECT DepartmentId, MAX(salary) AS top_sal
FROM Employee
GROUP BY DepartmentId)

SELECT d.Name AS 'Department', e.Name AS 'Employee', e.Salary
FROM Employee e
JOIN Department d
ON e.DepartmentId = d.Id
JOIN topDep t
ON e.DepartmentId = t.DepartmentId
WHERE e.Salary = t.top_Sal
/* - - - - - - - - - -  */

/* Delete Duplicate Emails
https://leetcode.com/problems/delete-duplicate-emails/ */

/* Solution */
/* In order to compare emails, we need to self-join the table, then delete the duplicates. */

DELETE p1
FROM Person p1, Person p2
WHERE p1.Email = p2.Email
AND p1.Id > p2.Id

/* - - - - - - - - - -  */

/* Average Salary Departments vs Company 
https://leetcode.com/problems/average-salary-departments-vs-company/ */

/* Solution */
/* First find the company's average salary by month (companyAvg) */
/* Then figure out each department's average by month via double group by (depAvg) */
/* Then compare the company's average to a departments average for a given month, and insert. */

WITH companyAvg AS (
SELECT date_format(pay_date, '%Y-%m') AS pay_date, AVG(amount) AS cAvg
FROM salary
GROUP BY date_format(pay_date, '%Y-%m') ),
depAvg AS (
SELECT date_format(s.pay_date, '%Y-%m') AS pay_date, e.department_id, AVG(s.amount) AS dAvg
FROM salary s
JOIN employee e
ON s.employee_id = e.employee_id
GROUP BY e.department_id, date_format(s.pay_date, '%Y-%m'))

SELECT d.pay_date AS 'pay_month', d.department_id,
CASE
    WHEN c.cAvg < d.dAvg THEN 'higher'
    WHEN c.cAvg > d.dAvg THEN 'lower'
    WHEN c.cAvg = d.dAvg THEN 'same'
END AS 'comparison'
FROM depAvg d
JOIN companyAvg c
ON d.pay_date = c.pay_date

/* - - - - - - - - - -  */

/* Consecutive Numbers
https://leetcode.com/problems/consecutive-numbers/ */

/* Solution */
/* Here we need to self join the table 3 times in order to compare 3 consecutive rows. */
/* Then we simply condition the table so that: 1) We're looking at three consecutive rows, */
/* 2) They all have the same number. We also need to throw a DISTINCT clause so that we */
/* output a single number if it happens to show up consecutively more than once. */

SELECT DISTINCT tbl1.Num AS 'ConsecutiveNums'
FROM Logs tbl1, Logs tbl2, Logs tbl3
WHERE (tbl1.id = tbl2.id + 1 AND tbl2.id = tbl3.id + 1)
AND (tbl1.Num = tbl2.Num AND tbl2.Num = tbl3.Num)

/* - - - - - - - - - -  */

/* Find Users With Valid E-mails
https://leetcode.com/problems/find-users-with-valid-e-mails/ */

/* Solution */
/* Here we'll need to use a regular expression /*
/* ^[A-Z] -> The first character must start with a letter */
/* [A-Z0-9_.-]* -> Give any number of letters, numbers, underscores, periods, or dashes */
/* @leetcode.com -> All emails need to end like this */

SELECT *
FROM Users
WHERE mail REGEXP '^[A-Z][A-Z0-9_.-]*@leetcode.com$'

/* - - - - - - - - - -  */

/* Swap Salary 
https://leetcode.com/problems/swap-salary/ */

/* Solution */
/* We only need to account for two cases here: When it's 'm' THEN 'f', when it's 'f' THEN 'm'*/

UPDATE salary
SET sex = CASE sex
WHEN 'm' THEN 'f'
WHEN 'f' THEN 'm'
END

/* - - - - - - - - - -  */

/* Activity Participants
https://leetcode.com/problems/activity-participants/ */

/* Solution */
/* We need to get the activity that doesn't have the max number of participants AND the min number. */
/* After aggregating with the GROUP BY, we filter out the results that satisfy these conditions. */
/* The hard part is trying to do a MAX(COUNT(*))/MIN(COUNT(*)). Since we can't perform an aggregate */ 
/* function on another aggregate function, we can work around it by counting the values in a separate table */

SELECT activity
FROM Friends
GROUP BY activity
HAVING COUNT(activity) <> (
    SELECT MAX(x.c)
    FROM (
        SELECT COUNT(activity) c 
        FROM Friends f
        GROUP BY activity
    ) x
)
AND COUNT(activity) <> (
    SELECT MIN(x.c)
    FROM (
        SELECT COUNT(activity) c 
        FROM Friends f
        GROUP BY activity
    ) x
)

/* - - - - - - - - - -  */

/* Immediate Food Delivery
https://leetcode.com/problems/immediate-food-delivery-i/ */

/* Solution */
/* The percentage of immediate orders is the number (COUNT) of orders that have an order date that is the same */
/* as the customer's preferred date, divided by the number of distinct orders total. */

SELECT ROUND((SELECT COUNT(order_date) FROM Delivery WHERE order_date = customer_pref_delivery_date) / COUNT(DISTINCT delivery_id) * 100, 2) AS 'immediate_percentage'
FROM Delivery

/* - - - - - - - - - -  */

/* All People Report to the Given Manager
https://leetcode.com/problems/all-people-report-to-the-given-manager/ */

/* Subquery solution) */
/* First we need to check if you work directly under the head. */
/* Then check if report indirectly under the head- two ways. */
/* 1) Either your manager works directly under the head. */
/* 2) Or your manager's manager works directly under the head. */

SELECT employee_id
FROM employees
WHERE employee_id IN (
    SELECT employee_id 
    FROM employees
    /* Checks if you are a manager that reports DIRECTLY under the head */
    WHERE employee_id IN (
        SELECT employee_id
        FROM Employees
        WHERE manager_id = 1 AND employee_id <> 1) )
    /* Checks if you report INDIRECTLY under the head */
    OR manager_id IN (
        SELECT employee_id 
        FROM employees
        /* Checks if your manager works directly under the head */
        WHERE employee_id IN (
            SELECT employee_id
            FROM Employees
            WHERE manager_id = 1 AND employee_id <> 1) 
        /* Checks if your manager's manager works under the head */
        OR manager_id IN (
            SELECT employee_id
            FROM Employees
            WHERE manager_id = 1 AND employee_id <> 1))

/* - - - - - - - - - -  */

/* Triangle Judgement 
https://leetcode.com/problems/triangle-judgement/ */

/* Solution */
/* Three sides make a triangle if the the sum of all possible combinations of two sides is greater than */
/* the third one */

SELECT x,y,z,
CASE
    WHEN x+y>z THEN 'Yes'
    WHEN x+z>y THEN 'Yes'
    WHEN y+z>x THEN 'Yes'
    ELSE 'No'
END AS 'triangle'
FROM triangle

/* - - - - - - - - - -  */

/* Rising Temperature 
https://leetcode.com/problems/rising-temperature/ */

/* Solution */
/* We need to do a self join in order to compare two values in the same field. */
/* Join where the difference between two dates is one (i.e. look at today and yesterday) */
/* Then take the values where the temperature was higher in the latter */

SELECT w1.id AS 'Id'
FROM Weather w1
JOIN Weather w2
ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
AND w1.Temperature > w2.Temperature

/* - - - - - - - - - -  */

/* Customers Who Never Order 
https://leetcode.com/problems/customers-who-never-order/ */

/* Solution */
/* A customer didn't order if their Id isn't in the Orders table */

SELECT c.Name AS 'Customers'
from Customers c
WHERE Id NOT IN (
    SELECT CustomerId
    FROM Orders
)

/* - - - - - - - - - -  */

/* Students With Invalid Departments 
https://leetcode.com/problems/students-with-invalid-departments/ */

/* Solution */
/* Here, our main assumption is that the Departments table only has IDs that are valid. */
/* Therefore, any student with a class that isn't in the Departments table is indeed invalid. */

SELECT s.id, s.name
FROM Students s
WHERE s.department_id NOT IN (
    SELECT d.id
    FROM Departments d
)

/* - - - - - - - - - - */

/* List the Products Ordered in a Period 
https://leetcode.com/problems/list-the-products-ordered-in-a-period/ */

/* Solution */
/* Here the two conditions we need to account for are total number of units and the date. */
/* However, we need to set these conditions at different times because of the nature of aggregate */
/* functions in SQL. We could have set a filter for date with either a WHERE or HAVING clause, because
/* it doesn't really matter when we take out the rows that don't satisfy this particular condition */
/* We need to use a HAVING clause for total number of units because we want to filter out the rows */
/* AFTER we added up all of the units. */

SELECT p.product_name, SUM(o.unit) AS 'unit'
FROM Products p
RIGHT JOIN Orders o
ON p.product_id = o.product_id
WHERE (o.order_date BETWEEN '2020-02-01' AND '2020-02-29')
GROUP BY o.product_id
HAVING SUM(o.unit) >= 100

/* - - - - - - - - - - */