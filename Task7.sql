use library_db;
CREATE TABLE departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50)
);
CREATE TABLE employees (
    emp_id     INT PRIMARY KEY,
    emp_name   VARCHAR(50),
    salary     DECIMAL(10,2),
    hire_date  DATE,
    dept_id    INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
INSERT INTO departments VALUES
(10,'Sales'), (20,'Tech'), (30,'HR');
INSERT INTO employees VALUES
(1,'Alice', 70000,'2021-04-01',20),
(2,'Bob',   45000,'2023-01-15',10),
(3,'Cara',  90000,'2019-07-20',20),
(4,'Dan',   30000,'2024-02-28',30),
(5,'Eve',   55000,'2022-05-10',10);


CREATE OR REPLACE VIEW v_employee_summary AS
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary,
    ROUND(DATEDIFF(CURDATE(), e.hire_date)/365, 1) AS years_worked,
    CASE
        WHEN e.salary < 40000            THEN 'Low'
        WHEN e.salary BETWEEN 40000 AND 70000 THEN 'Mid'
        ELSE 'High'
    END AS salary_band
FROM   employees e
JOIN   departments d ON d.dept_id = e.dept_id
WHERE  e.salary >= 30000          -- hide interns etc.
  AND  e.hire_date >= '2019-01-01' -- hide very old records
ORDER BY d.dept_name, e.salary DESC;


SELECT * FROM v_employee_summary;

CREATE USER 'analyst'@'%' IDENTIFIED BY 'pwd123';

GRANT SELECT ON v_employee_summary TO 'analyst'@'%';
