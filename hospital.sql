/* Hospital DB 
https://www.w3resource.com/sql-exercises/hospital-database-exercise/index.php */

/* 1) Write a query in SQL to find all the information of the nurses who are yet to be registered. */
SELECT * 
FROM nurse n
WHERE n.registered = 't'

/* 2) Write a query in SQL to find the name of the nurse who are the head of their department. */ 
SELECT * 
FROM nurse n
WHERE n.position = 'Head Nurse'

/* 3) Write a query in SQL to obtain the name of the physicians who are the head of each department.*/
SELECT p.name
FROM physician p
INNER JOIN department d
ON p.employeeid = d.head

/* 4) Write a query in SQL to count the number of patients who taken appointment with at least one physician. */
SELECT COUNT(DISTINCT(a.patient))
FROM appointment a

/* 5)  Write a query in SQL to find the floor and block where the room number 212 belongs to. */
SELECT r.blockfloor
FROM room r
WHERE r.roomnumber = 212

/* 6) Write a query in SQL to count the number available rooms. */
SELECT COUNT(r.unavailable)
FROM room r
WHERE r.unavailable = 'f'

/* 7) Write a query in SQL to count the number unavailable rooms. */
SELECT COUNT(r.unavailable)
FROM room r
WHERE r.unavailable = 't'

/* 8) Write a query in SQL to obtain the name of the physician and the departments they are affiliated with. */
SELECT p.name AS doctor_name, d.name AS dept_name
FROM physician p
LEFT JOIN affiliated_with a
ON p.employeeid = a.physician
LEFT JOIN department d
ON a.department = d.departmentid

/* 9) Write a query in SQL to obtain the name of the physicians who are trained for a special treatement. */
SELECT DISTINCT p.name
FROM physician p
INNER JOIN trained_in t
ON p.employeeid = t.physician

/* 10) Write a query in SQL to obtain the name of the physicians with department who are yet to be affiliated. */
SELECT p.name
FROM physician p
LEFT JOIN affiliated_with a
ON p.employeeid = a.physician
WHERE a.primaryaffiliation = 'f'

/* 11) Write a query in SQL to obtain the name of the physicians who are not a specialized physician. */
SELECT p.name
FROM physician p 
WHERE p.name NOT IN (
    SELECT DISTINCT p.name
    FROM physician p
    INNER JOIN trained_in t
    ON p.employeeid = t.physician
)

/* 12)  Write a query in SQL to obtain the name of the patients with their physicians by whom they got their preliminary treatement. */
SELECT a.name AS patient_name, b.name AS doctor_name
FROM patient a
LEFT JOIN physician b
ON a.pcp = b.employeeid

/* 13) Write a query in SQL to find the name of the patients and the number of physicians they have taken appointment.  */
SELECT COUNT(a.patient), p.name
FROM appointment a
LEFT JOIN patient p
ON a.patient = p.ssn
GROUP BY p.name

/* 14) Write a query in SQL to count number of unique patients who got an appointment for examination room C. */
SELECT COUNT(DISTINCT(a.patient))
FROM appointment a
WHERE a.examinationroom = 'C'

/* 15) Write a query in SQL to find the name of the patients and the number of the room where they have to go for their treatment. */
SELECT a.examinationroom, p.name
FROM appointment a
LEFT JOIN patient p
ON a.patient = p.ssn

/* 16) Write a query in SQL to find the name of the nurses and the room scheduled, where they will assist the physicians. */
SELECT n.name, a.examinationroom
FROM nurse n
INNER JOIN appointment a
ON n.employeeid = a.prepnurse

/* 17)  Write a query in SQL to find the name of the patients who taken the appointment on the 25th of April at 10 am, and also display their physician, assisting nurses and room no. */
SELECT a.name AS patient_name, b.start_dt_time, b.examinationroom, c.name AS nurse_name, d.name AS doc_name
FROM patient a
LEFT JOIN appointment b
ON a.ssn = b.patient
LEFT JOIN nurse c
ON b.prepnurse = c.employeeid
LEFT JOIN physician d
ON b.physician = d.employeeid
WHERE b.start_dt_time = '2008-04-25 10:00:00'

/* 18) Write a query in SQL to find the name of patients and their physicians who does not require any assistance of a nurse. */
SELECT a.name AS patient_name, c.name AS doc_name
FROM patient a
LEFT JOIN appointment b
ON a.ssn = b.patient
INNER JOIN physician c
ON b.physician = c.employeeid
WHERE b.prepnurse IS NULL

/* 19) Write a query in SQL to find the name of the patients, their treating physicians and medication. */
SELECT a.name AS patient_name, b.medication, c.name AS doc_name
FROM patient a
LEFT JOIN prescribes b
ON a.ssn = b.patient
LEFT JOIN physician c
ON b.physician = c.employeeid

/* Note: Here we want to use a left join initially when merging the patients and prescribes table. This is to make sure every patient is listed even if they don't take any medicine.

/* 20) Write a query in SQL to find the name of the patients who taken an advanced appointment, and also display their physicians and medication. */
SELECT a.name AS patient_name, c.name AS doc_name, d.name AS meds_name
FROM patient a
INNER JOIN prescribes b
ON a.ssn = b.patient
INNER JOIN physician c
ON b.physician = c.employeeid
INNER JOIN medication d
ON b.medication = d.code;

/* 21) Write a query in SQL to find the name and medication for those patients who did not take any appointment. */
SELECT a.name AS patient_name, d.name AS meds_name
FROM patient a
INNER JOIN prescribes b
ON a.ssn = b.patient
INNER JOIN physician c
ON b.physician = c.employeeid
INNER JOIN medication d
ON b.medication = d.code
WHERE b.appointment IS NULL

/* 31) Write a query in SQL to count the number of available rooms in each block. */
SELECT name AS "Physician"
FROM physician
WHERE employeeid IN
    ( SELECT undergoes.physician
     FROM undergoes
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician
     AND undergoes.procedure=trained_in.treatment
     WHERE treatment IS NULL );

