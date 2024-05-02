-- 혼합 SQL 문제입니다.

------------------------------------------------------------

-- 문제1.
-- 담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의
-- 이름, 매니저 아이디, 커미션 비율, 월급을 출력하세요.
-- (45건)

SELECT
    first_name     "이름",
    manager_id     "매니저 아이디",
    commission_pct "커미션 비율",
    salary         "월급"
FROM
    employees
WHERE
    manager_id IS NOT NULL
    AND commission_pct IS NULL
    AND salary > 3000;

------------------------------------------------------------

-- 문제2.
-- 각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name), 급여
-- (salary), 입사일(hire_date), 전화번호(phone_number), 부서번호(department_id)를 조회하세
-- 요
-- -조건절 비교 방법으로 작성하세요
-- -급여의 내림차순으로 정렬하세요
-- -입사일은 2001-01-13 토요일 형식으로 출력합니다.
-- -전화번호는 515-123-4567 형식으로 출력합니다.
-- (11건)

SELECT
    employee_id                          "직원번호",
    first_name                           "이름",
    salary                               "급여",
    to_char(hire_date, 'yyyy-mm-dd day') "입사일",
    '+'
    || replace(phone_number, '.', '-')   "전화번호",
    department_id                        "부서번호"
FROM
    employees
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
    "급여" DESC;

------------------------------------------------------------

-- 문제3
-- 매니저별로 평균급여 최소급여 최대급여를 알아보려고 한다.
-- -통계대상(직원)은 2015년 이후의 입사자 입니다.
-- -매니저별 평균급여가 5000이상만 출력합니다.
-- -매니저별 평균급여의 내림차순으로 출력합니다.
-- -매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
-- -출력내용은 매니저 아이디, 매니저이름(first_name), 매니저별 평균급여, 매니저별 최소급여,
-- 매니저별 최대급여 입니다.
-- (9건)

SELECT
    DISTINCT *
FROM
    (
        SELECT
            mng.employee_id                                      "매니저 아이디",
            mng.first_name                                       "매니저 이름",
            round(avg(mng.salary) OVER (ORDER BY mng.salary), 1) "매니저 평균급여",
            MIN(mng.salary) OVER (ORDER BY mng.salary)           "매니저 최소급여",
            MAX(mng.salary) OVER (ORDER BY mng.salary)           "매니저 최대급여"
        FROM
            employees emp
            JOIN employees mng
            ON emp.manager_id = mng.employee_id
        WHERE
            mng.hire_date >= TO_DATE('20150101', 'yyyymmdd')
    )
WHERE
    "매니저 평균급여" >= 5000
ORDER BY
    "매니저 평균급여" DESC;

------------------------------------------------------------

-- 문제4.
-- 각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
-- (department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
-- 부서가 없는 직원(Kimberely)도 표시합니다.
-- (106명)

SELECT
    emp.employee_id     "사번",
    emp.first_name      "이름",
    dep.department_name "부서명",
    mng.first_name      "매니저이름"
FROM
    employees   emp
    JOIN employees mng
    ON emp.manager_id = mng.employee_id
    JOIN departments dep
    ON emp.department_id = dep.department_id;

------------------------------------------------------------

-- 문제5.
-- 2015년 이후 입사한 직원 중에 입사일이 11번째에서 20번째의 직원의
-- 사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요

SELECT
    "사번",
    "이름",
    "부서명",
    "급여",
    "입사일"
FROM
    (
        SELECT
            employee_id                            "사번",
            first_name                             "이름",
            department_name                        "부서명",
            salary                                 "급여",
            hire_date                              "입사일",
            row_number() OVER (ORDER BY hire_date) "입사순서"
        FROM
            employees
            JOIN departments
            USING (department_id)
    )
WHERE
    "입사순서" BETWEEN 11 AND 20;

------------------------------------------------------------

-- 문제6.
-- 가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서 이름
-- (department_name)은?

SELECT
    first_name
    || ' '
    || last_name                     "이름",
    salary                           "연봉",
    department_name                  "부서 이름",
    to_char(hire_date, 'yyyy-mm-dd') "입사일"
FROM
    employees
    JOIN departments
    USING (department_id)
WHERE
    hire_date = (
        SELECT
            MAX(hire_date)
        FROM
            employees
    );

------------------------------------------------------------

-- 문제7.
-- 평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name), 성
-- (last_name)과 업무(job_title), 연봉(salary)을 조회하시오.

SELECT
    employee_id                               "직원번호",
    first_name                                "이름",
    last_name                                 "성",
    job_title                                 "업무",
    salary                                    "급여",
    avg(salary) OVER (ORDER BY department_id) "평균급여"
FROM
    employees
    JOIN jobs
    USING (job_id)
WHERE
    department_id = (
        SELECT
            department_id
        FROM
            (
                SELECT
                    department_id,
                    avg_sal,
                    row_number() OVER (ORDER BY avg_sal DESC) max_sal
                FROM
                    (
                        SELECT
                            department_id,
                            AVG(salary)   avg_sal
                        FROM
                            employees
                        GROUP BY
                            department_id
                    )
            )
        WHERE
            max_sal = 1
    );

------------------------------------------------------------

-- 문제8.
-- 평균 급여(salary)가 가장 높은 부서는?

SELECT
    department_id, department_name
FROM
    (
        SELECT
            department_id,
            avg_sal,
            row_number() OVER (ORDER BY avg_sal DESC) max_sal
        FROM
            (
                SELECT
                    department_id,
                    AVG(salary)   avg_sal
                FROM
                    employees
                GROUP BY
                    department_id
            )
    )
    JOIN departments USING (department_id)
WHERE
    max_sal = 1;

------------------------------------------------------------

-- 문제9.
-- 평균 급여(salary)가 가장 높은 지역은?

SELECT
    region_id, region_name
FROM
    (
        SELECT
            department_id,
            avg_sal,
            row_number() OVER (ORDER BY avg_sal DESC) max_sal
        FROM
            (
                SELECT
                    department_id,
                    AVG(salary)   avg_sal
                FROM
                    employees
                GROUP BY
                    department_id
            )
    )
    JOIN departments USING (department_id)
    JOIN locations USING (location_id)
    JOIN countries USING (country_id)
    JOIN regions USING (region_id)
WHERE
    max_sal = 1;

------------------------------------------------------------

-- 문제10.
-- 평균 급여(salary)가 가장 높은 업무는?

SELECT DISTINCT
    job_id, job_title
FROM
    (
        SELECT
            department_id,
            avg_sal,
            row_number() OVER (ORDER BY avg_sal DESC) max_sal
        FROM
            (
                SELECT
                    department_id,
                    AVG(salary)   avg_sal
                FROM
                    employees
                GROUP BY
                    department_id
            )
    )
    JOIN employees USING (department_id)
    JOIN jobs USING (job_id)
WHERE
    max_sal = 1;
    