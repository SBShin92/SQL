SELECT
    *
FROM
    employees;

SELECT
    first_name,
    last_name,
    AVG(salary)
FROM
    employees
    JOIN salaries
    USING (emp_no)
GROUP BY
    first_name,
    last_name;

SELECT
    first_name,
    AVG(salary)
FROM
    employees
    JOIN salaries
    USING (emp_no)
GROUP BY
    first_name
HAVING
    AVG(salary) >= (
        SELECT
            AVG(salary)
        FROM
            salaries
    );


