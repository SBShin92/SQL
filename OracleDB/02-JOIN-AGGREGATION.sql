

-- 카티전 프로덕트
SELECT * from EMPLOYEES, DEPARTMENTS;

---- 의미없는 중복을 없애기 위해 JOIN 조건 설정
SELECT * FROM EMPLOYEES, DEPARTMENTS
WHERE EMPLOYEEs.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;

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
    employees emp, employees man
WHERE
    emp.manager_id = man.employee_id;


