-- 1. Create a view that holds the retirement eligibile employees.

CREATE VIEW retirement_info
AS
SELECT emp_no,first_name,last_name
FROM
employees
WHERE birth_date >='1952-01-01' AND birth_date <'1955-12-31' AND hire_date >='1985-01-01' AND hire_date <'1988-12-31';
-----------------------------





-- 2. Create a view that holds a list of all the current employees, include the employee number, first and last name. 

CREATE VIEW current_employees
AS
SELECT 
retirement_info.emp_no,first_name,last_name,to_date
FROM  
retirement_info
LEFT JOIN
dept_emp
ON dept_emp.emp_no=retirement_info.emp_no
WHERE to_date='9999-01-01';
-------------------------------







-- 3. Get the average salary by title for the current employees. 


SELECT titles.title, AVG(salaries.salary)

FROM current_employees
LEFT JOIN salaries
ON current_employees.emp_no=salaries.emp_no

LEFT JOIN titles
ON titles.emp_no=salaries.emp_no

GROUP BY
    titles.title

ORDER BY
   AVG(salaries.salary);

----------------------------






-- 4. Get the average salary by department for the current employees. 


SELECT departments.dept_name,AVG(salaries.salary)


FROM current_employees
LEFT JOIN dept_emp
ON current_employees.emp_no=dept_emp.emp_no

LEFT JOIN departments
ON dept_emp.dept_no=departments.dept_no

LEFT JOIN titles
ON dept_emp.emp_no=titles.emp_no


LEFT JOIN
salaries
ON salaries.emp_no=dept_emp.emp_no


GROUP BY
 departments.dept_name
	
ORDER BY
 AVG(salaries.salary);
 
-----------------------------






-- 5. Compare the average salary by title for each department for the current employees.

--- Was getting weird results so I had to change it up

SELECT departments.dept_name,titles.title,AVG(salaries.salary)

FROM dept_emp CROSS JOIN dept_manager

LEFT JOIN
departments
ON departments.dept_no=dept_emp.dept_no

LEFT JOIN
salaries
ON salaries.emp_no=dept_emp.emp_no

LEFT JOIN
titles
ON titles.emp_no=salaries.emp_no

RIGHT JOIN
current_employees
ON current_employees.emp_no=titles.emp_no

GROUP BY
 departments.dept_name,titles.title
 
ORDER BY
 titles.title, AVG(salaries.salary) ASC;
----------------------------




-- 6. Determine the number of current employees by title and grouped within departments. 
-- And, rank the results by title within each department. 



SELECT titles.title, departments.dept_name, COUNT(current_employees.emp_no),
   RANK() OVER (PARTITION BY dept_name ORDER BY COUNT(current_employees.emp_no)DESC)

FROM current_employees

LEFT JOIN dept_emp
ON current_employees.emp_no=dept_emp.emp_no


LEFT JOIN departments
ON dept_emp.dept_no=departments.dept_no

LEFT JOIN titles
ON dept_emp.emp_no=titles.emp_no

GROUP BY
departments.dept_name,titles.title;
