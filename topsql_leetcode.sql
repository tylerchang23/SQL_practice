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

/* Department Top Three Salaries 
https://leetcode.com/problems/department-top-three-salaries/solution/ */

/* Solution) Nested Query */
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