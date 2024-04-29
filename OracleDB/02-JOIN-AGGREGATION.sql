-- 카티전 프로덕트
SELECT
    *
FROM
    employees,
    departments;

---- 의미없는 중복을 없애기 위해 JOIN 조건 설정
SELECT
    *
FROM
    employees,
    departments
WHERE
    employees.department_id = departments.department_id;

--------------------------------------------------------------------

-- alias를 이용, 원하는 필드의 프로젝션

-- 모호하지 않은 속성은 테이블을 명시 안해도 돌아가긴 한다.
SELECT
    first_name,
    e.department_id,
    d.department_id,
    department_name
FROM
    employees   e,
    departments d
WHERE
    e.department_id = d.department_id;

SELECT
    *
FROM
    employees
WHERE
    department_id IS NULL;

SELECT
    emp.first_name,
    department_id,
    dept.department_name
FROM
    employees   emp
    JOIN departments dept
    USING (department_id);

-- THETA JOIN

SELECT
    emp.employee_id,
    emp.first_name,
    emp.salary,
    emp.job_id,
    j.job_id,
    j.job_title
FROM
    employees emp
    JOIN jobs j
    ON emp.job_id = j.job_id
WHERE
    emp.salary <= (j.min_salary + j.max_salary) / 2;

-- NATURAL JOIN
-- 같은 이름의 컬럼은 모두 JOIN 시킨다. 아래 두 쿼리는 속성 순서는 다르나, 같은 릴레이션을 가진다.

-- JOIN한 속성이 테이블의 앞쪽에 나오기 때문에 그것으로 무엇을 기준으로 조인했는 지 짐작할 수 있다.
SELECT
    *
FROM
    employees   emp
    NATURAL JOIN departments dept;

SELECT
    *
FROM
    employees   emp
    JOIN departments dept
    ON emp.department_id = dept.department_id
    AND emp.manager_id = dept.manager_id;

-------------------------------------------------------------

-- OUTER JOIN


---- LEFT OUTER JOIN
SELECT
    emp.first_name,
    emp.department_id,
    dept.department_id,
    dept.department_name
FROM
    employees   emp
    LEFT OUTER JOIN departments dept
    ON emp.department_id = dept.department_id;

---- 위와 아래는 같은 결과
SELECT
    emp.first_name,
    emp.department_id,
    dept.department_id,
    dept.department_name
FROM
    employees   emp,
    departments dept
WHERE
    emp.department_id = dept.department_id(+);

-- RIGHT OUTER JOIN, FULL OUTER JOIN 모두 형태는 같다. 확인하려면 코드에서 단어만 바꿔 쓰자.
-- FULL OUTER JOIN은 (+)로 한 줄에 표기할 순 없고
-- UNION ALL로 두 개의 테이블을 합쳐야 한다.
-- 따라서 얌전히 ANSI규격으로 사용하자.
--------------------------------------------------------------

-- SELF JOIN

SELECT
    emp.employee_id,
    emp.first_name,
    man.manager_id,
    man.first_name
FROM
    employees emp,
    employees man
WHERE
    emp.manager_id = man.employee_id;

--------------------------------------------------------------
--------------------------------------------------------------




-- group aggregation --

-- COUNT

SELECT
    COUNT(*)
FROM
    employees;

SELECT
    COUNT(commission_pct)
FROM
    employees;

-- SUM

SELECT
    SUM(salary)
FROM
    employees;

-- AVG

SELECT
    round(AVG(commission_pct), 4),
    round(AVG(nvl(commission_pct, 0)), 4)
FROM
    employees;

-- MIN, MAX

SELECT
    MIN(salary),
    MAX(salary),
    AVG(salary),
    MEDIAN(salary)
FROM
    employees;

-- 이라믄안돼
-- SELECT department_id,
--     AVG(salary)
-- FROM employees;

-- GROUP BY
SELECT
    department_id,
    AVG(salary)
FROM
    employees
GROUP BY
    department_id
ORDER BY
    1;

-- GROUP BY를 쓰는 SELECT문에는 GROUP BY한 필드, 집계함수만 가능
SELECT
    department_id,
    department_name,
    round(AVG(salary), 2)
FROM
    employees
    JOIN departments
    USING (department_id)
GROUP BY
    department_id,
    department_name;

-- 예제
-- 평균 급여가 7000 이상인 부서 출력
SELECT
    department_id,
    department_name,
    AVG(salary)
FROM
    departments
    JOIN employees
    USING (department_id)
GROUP BY
    CUBE(department_id, department_name)
HAVING
    AVG(salary) >= 7000
ORDER BY
    department_id;

---------------------------------------------------------------------------------

/* 여기까지 요약하자면...
단일 SQL 작성법?
1. 최종 출력될 정보에 따라 원하는 컬럼을 SELECT 절에 추가
2. 원하는 정보를 가진 테이블들을 FROM 절에 추가 및 JOIN
3. WHERE 절에 알맞은 검색 조건 추가
4. 필요에 따라 GROUP BY, HAVING 등을 통해 Grouping하고 Aggregate
5. 정렬 조건 ORDER BY에 추가 */



-- ROLLUP

SELECT
    department_id,
    nvl(job_id, '합'),
    SUM(salary)
FROM
    employees
GROUP BY
    ROLLUP(department_id, job_id)
ORDER BY
    department_id;

-- CUBE
SELECT
    department_id,
    job_id,
    SUM(salary)
FROM
    employees
GROUP BY
    CUBE(department_id, job_id)
ORDER BY
    department_id;

---------------------------------------------------------------------------------

-- subquery

SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary >= (
        SELECT
            MEDIAN(salary)
        FROM
            employees
    );

-- Susan보다 늦게 입사한 사람?

SELECT
    first_name,
    hire_date
FROM
    employees
WHERE
    hire_date > (
        SELECT
            hire_date
        FROM
            employees
        WHERE
            first_name = 'Susan'
    );

-- 급여를 모든 직원 급여의 중앙값보다 많이 받으면서 수잔보다 늦게 입사한 직원?
SELECT
    first_name,
    hire_date,
    salary
FROM
    employees
WHERE
    hire_date > (
        SELECT
            hire_date
        FROM
            employees
        WHERE
            first_name = 'Susan'
    )
    AND salary > (
        SELECT
            MEDIAN(salary)
        FROM
            employees
    );