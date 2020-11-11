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