-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no)
);	
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);
-- 7.3.1 Query Dates
SELECT * FROM departments;

select * from salaries
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- 7.3.1 Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring ADD COUNT
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- 41,380 employees but inculdes retired already

-- 7.3.1 Create retirement_info table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring ADD COUNT
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create a table for retirement_info ##7
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- This table lacked emp_no column so drop it.
SELECT * FROM retirement_info;
DROP TABLE retirement_info; 

-- Create new table for retiring employees #7
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- 7.3.3
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- create new table for current_emp based on above query
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- 7.3.4
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- lists employees in each of 9 departments

-- 7.3.5
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Testing out a new table for adding salary with all the employee table fields into emp_info
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create a new table for adding salary and dept_emp data
-- Now join three tables 
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');
	 


-- List of managers per department #11. Not actually created
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- 7.3.6
-- Create department retirees table #12. Not actually created
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- Create list for Sales team #13
SELECT  ce.emp_no, 
		ce.first_name,
		ce.last_name,
		d.dept_name,
		d.dept_no
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

-- Create mentor list for 2 departments #14
SELECT  ce.emp_no, 
		ce.first_name,
		ce.last_name,
		d.dept_name,
		d.dept_no
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Development', 'Sales');

-- End of Module

--CHALLENGE--

-- ADDING TITLE DATA TO EMP_INFO TABLE PREVIOUSLY CREATED IN MODULE

SELECT e.emp_no,
e.first_name,
e.last_name,
e.salary,
ti.title,
ti.from_date
INTO ret_title
FROM emp_info as e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no);

-- DATA CONFIRMATION
SELECT * FROM titles
WHERE emp_no = 10035

SELECT * FROM ret_title

-- Count the number of rows in each group as confirmation
SELECT
first_name, last_name, count(*)
FROM ret_title
GROUP BY 
	first_name,
	last_name
HAVING count(*) > 1;

-- Find duplicate rows (technique not used)
SELECT * FROM
(SELECT *, count (*)
 OVER
 (PARTITION BY
 first_name,
 last_name
 ) AS count
FROM ret_title) tableWithCount
WHERE tableWithCount.count > 1;

-- More data confirmation exercises
SELECT * FROM employees
WHERE first_name = ('Aamod') AND last_name = ('Suri')

SELECT * FROM titles
WHERE emp_no = '494473'

-- Do partitioning by setting up a temporary table "tmp" on the outer select
-- Inner select references ret_title table, which was created with "WHERE to_date =9999"
-- Note- Challenge instructions directed ORDER BY to-date, but that makes no sense  
--  because we previously filtered by to_date = 9999, and we never joined to_date into a table, 
--  so we cannot reference it here and do not need to.  I believe that was a mistake in instructions.  
--  Ordering by from_date is what makes sense, so I added from_date to both select statements as well.

-- Create retire_title_salary table derived from emp_info table and ret_title table
-- Table 1A --

SELECT tmp.emp_no,
tmp.first_name,
tmp.last_name, 
tmp.title,
tmp.salary,
tmp.from_date
INTO retire_title_salary
FROM 
(SELECT emp_no,
first_name,
last_name,
title,
salary,
from_date,
ROW_NUMBER() OVER
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM ret_title
) tmp WHERE rn = 1
ORDER BY emp_no;

-- Confirmation
SELECT * FROM retire_title_salary;

-- Late Sunday night I learned from a TA that the graders wanted a 3rd table showing just the count of titles.  I saw no mention of this in the rubric.
-- Table 1B--

SELECT title, COUNT(*)
INTO title_count
FROM retire_title_salary
GROUP BY title
ORDER BY title;

SELECT* From title_count



-- Table 2 --
-- Set up
SELECT * FROM EMPLOYEES
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31';

-- run table #7 for mentors
SELECT emp_no, first_name, last_name
INTO sixty_five
FROM employees
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31');
-- 1,940

-- Validation
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')

SELECT * FROM sixty_five


-- run table #8 for mentors
SELECT sx.emp_no,
sx.first_name,
sx.last_name,
de.to_date
INTO mentor_sixtyfive
FROM sixty_five as sx
LEFT JOIN dept_emp as de
ON sx.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
--1,549

-- run table #10 for mentors
SELECT e.emp_no,
e.first_name,
e.last_name,
e.to_date,
ti.title,
ti.from_date
INTO mentors_list
FROM mentor_sixtyfive as e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE e.to_date=('9999-01-01');

-- removing dupes using table #11
SELECT tmp.emp_no,
tmp.first_name,
tmp.last_name, 
tmp.title,
tmp.from_date,
tmp.to_date
INTO mentor_eligible
FROM 
(SELECT emp_no,
first_name,
last_name,
title,
from_date,
to_date,
ROW_NUMBER() OVER
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM mentors_list
) tmp WHERE rn = 1
ORDER BY emp_no;

-- Validation
SELECT * FROM mentor_eligible;

-- 1,549

