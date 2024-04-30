-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 문제1.
-- 평균 급여보다 적은 급여을 받는 직원은 몇명인지 구하시요.
-- (56건)

SELECT
    COUNT(salary)
FROM
    employees
WHERE
    salary < (
        SELECT
            AVG(salary)
        FROM
            employees
    );

---------------------------------------------------------------------------

-- 문제2.
-- 평균급여 이상, 최대급여 이하의 월급을 받는 사원의
-- 직원번호(employee_id), 이름(first_name), 급여(salary), 평균급여, 최대급여를 급여의 오름차
-- 순으로 정렬하여 출력하세요
-- (51건)

SELECT
    employee_id        직원번호,
    first_name         이름,
    salary             급여,
    (
        SELECT
            round(AVG(salary),
            1)
        FROM
            employees
    ) 평균급여,
    MAX(salary) OVER() 최대급여
FROM
    employees
WHERE
    salary >= (
        SELECT
            AVG(salary)
        FROM
            employees
    )
    AND salary <= (
        SELECT
            MAX(salary)
        FROM
            employees
    )
ORDER BY
    급여;

---------------------------------------------------------------------------

-- 문제3.
-- 직원중 Steven(first_name) king(last_name)이 소속된 부서(departments)가 있는 곳의 주소
-- 를 알아보려고 한다.
-- 도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 도시명(city), 주
-- (state_province), 나라아이디(country_id) 를 출력하세요
-- (1건)

-- 쉽게쉽게
SELECT
    location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM
    locations
    JOIN departments
    USING (location_id)
    JOIN employees
    USING (department_id)
WHERE
    lower(first_name) = 'steven'
    AND lower(last_name) = 'king';

-- 굳이 어렵게
SELECT
    location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM
    locations
    JOIN departments
    USING (location_id)
    JOIN (
        SELECT
            first_name,
            last_name,
            department_id
        FROM
            employees
        WHERE
            lower(first_name) = 'steven'
            AND lower(last_name) = 'king'
    )
    USING (department_id);

---------------------------------------------------------------------------

-- 문제4.
-- job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,이름,급여를 급여의 내림차순으로
-- 출력하세요 -ANY연산자 사용
-- (74건)

SELECT
    employee_id 사번,
    first_name  이름,
    salary      급여
FROM
    employees
WHERE
    salary < ANY(
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id = 'ST_MAN'
    );

ORDER BY 급여 DESC;

---------------------------------------------------------------------------

-- 문제5.
-- 각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name)과 급여
-- (salary) 부서번호(department_id)를 조회하세요
-- 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다.
-- 조건절비교, 테이블조인 2가지 방법으로 작성하세요
-- (11건)

-- WHERE절
SELECT
    employee_id   직원번호,
    first_name    이름,
    salary        급여,
    department_id 부서번호
FROM
    employees outer
WHERE
    (department_id, salary) IN (
        SELECT
            department_id,
            MAX(salary)
        FROM
            employees
        GROUP BY
            department_id
    )
ORDER BY
    department_id;

-- FROM절
SELECT
    outer.employee_id   직원번호,
    outer.first_name    이름,
    outer.salary        급여,
    outer.department_id 부서번호
FROM
    employees outer
    JOIN (
        SELECT
            department_id,
            MAX(salary)   max_sal
        FROM
            employees
        GROUP BY
            department_id
    ) inner
    ON outer.department_id = inner.department_id
    AND outer.salary = inner.max_sal
ORDER BY
    outer.department_id;

---------------------------------------------------------------------------

-- 문제6.
-- 각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다.
-- 연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오
-- (19건)

SELECT
    job_title   업무,
    SUM(salary) "연봉의 총합"
FROM
    employees
    JOIN jobs
    USING (job_id)
GROUP BY
    job_id,
    job_title
ORDER BY
    "연봉의 총합" DESC;

-- 조금 더 스마트하게
SELECT
    DISTINCT job_title                                         업무,
    SUM(salary) OVER (PARTITION BY job_id, job_title) "연봉의 총합"
FROM
    employees
    JOIN jobs
    USING (job_id)
ORDER BY
    "연봉의 총합" DESC;

---------------------------------------------------------------------------

-- 문제7.
-- 자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 직원번호(employee_id), 이름
-- (first_name)과 급여(salary)을 조회하세요
-- (38건)

SELECT
    employee_id 직원번호,
    first_name  이름,
    salary      급여
FROM
    employees outer
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
        WHERE
            department_id = outer.department_id
    );

---------------------------------------------------------------------------

-- 문제8.
-- 직원 입사일이 11번째에서 15번째의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력
-- 하세요
SELECT
    *
FROM
    (
        SELECT
            employee_id                            사번,
            first_name                             이름,
            salary                                 급여,
            hire_date                              입사일,
            row_number() OVER (ORDER BY hire_date) 순서
        FROM
            employees
    )
WHERE
    순서 BETWEEN 11 AND 15;