/* Random SQL questions on Leetcode or I made up on the spot (adjusted to W3 Resource tables)
https://www.w3resource.com/sql/tutorials.php */


/* 1) Find the average salary for each department (HR Database) */
SELECT e.department_id, AVG(e.salary)
FROM employees e 
GROUP BY e.department_id

/* 2) Find the employees that earn more than the average salary (HR Database) */
SELECT e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(e.salary)
    FROM employees e
)

/* 3) Find the employees that earn more than their department's average salary (HR Database) */
SELECT e.first_name, e.last_name, e.salary, avgs_tbl.dept_avg
FROM employees e
INNER JOIN (
    SELECT e.department_id, AVG(e.salary) AS dept_avg
    FROM employees e
    GROUP BY e.department_id
) avgs_tbl
ON e.department_id = avgs_tbl.department_id
WHERE e.salary > avgs_tbl.dept_avg

/* 4) Find the employees that earn more than their manager's salary (HR Database) */
SELECT e.first_name, e.last_name, e.salary, managerSal_tbl.managerSal
FROM employees e
INNER JOIN (
    SELECT e.employee_id, e.salary AS managerSal
    FROM employees e
    WHERE e.employee_id IN (
        SELECT e.manager_id
        FROM employees e
    )
) managerSal_tbl
ON e.manager_id = managerSal_tbl.employee_id
WHERE e.salary > managerSal_tbl.managerSal

/* 5) Find the percentage of doctors who are trained in each treatment rounded to two decimals (Hospital Database) */
SELECT t.treatment, ROUND((COUNT(t.physician) / (SELECT COUNT(*) FROM physician p)), 2) AS pct_doctors
FROM trained_in t
GROUP BY t.treatment
ORDER BY t.treatment