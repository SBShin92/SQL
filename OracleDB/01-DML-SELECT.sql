--SQL 문장의 주석은 두 개의 하이픈(--)으로 표기
--SQL 문장의 끝은 세미콜론(;)
--키워드들은 대소문자를 구분하지 않는다.(단, 실제 데이터의 경우 대소문자를 구분한다.)
------------------------------------------------------------------

--테이블 구조 확인: DESCRIBE
DESCRIBE employees;

describe departments;

------------------------------------------------------------------

-- SELECT --

-- Alias에 띄어쓰기, 특수문자가 있으면 더블쿼트("")를 써야 한다.
SELECT
    employee_id  "id",
    first_name   AS 성,
    last_name    AS 이름,
    phone_number AS "전화-번호",
    hire_date    AS 입사일,
    salary       AS "급  여",
    salary * 12 AS "연  봉"
FROM
    employees;

------------------------------------------------------------------

-- 단순연산 --

SELECT
    3 + 4
FROM
    dual;

-- select job_id * 12
---- 위 쿼리가 에러가 난 이유? : job_id는 VARCHAR!
-- 연산 시에는 숫자인지 꼭 확인하도록 하자.
------------------------------------------------------------------

-- NULL --

-- 이름, 급여를 출력
SELECT
    first_name,
    salary
FROM
    employees;

SELECT
    first_name                       AS 성,
    salary                           AS 기본급,
    commission_pct                   AS 수당,
    salary + salary * commission_pct AS 월급
FROM
    employees;

-- 월급 값을 NULL이 아닌 값으로 계산하고 싶으면 아래와 같이
SELECT
    first_name                               AS 성,
    salary                                   AS 기본급,
    commission_pct                           AS 수당,
    salary + salary * nvl(commission_pct, 0) AS 월급
FROM
    employees;

-- 연산 전에는 항상 NULL을 생각하자!
------------------------------------------------------------------

-- 문자열 결합 연산 --

SELECT
    'Name is '
    || first_name
    || ' '
    || last_name
    || concat(' and no. is ', employee_id)
FROM
    employees;

-- 응용 1
SELECT
    first_name
    || ' '
    || last_name                             "Full Name",
    salary + salary * nvl(commission_pct, 0) "급여(with 수당)",
    salary * 12 연봉
FROM
    employees;

-- 응용 2
SELECT
    first_name
    || ' '
    || last_name                             이름,
    to_char(hire_date, 'yyyy-mm-dd')         입사일,
    phone_number                             전화번호,
    salary                                   급여,
    salary + salary * nvl(commission_pct, 0) "급여(with 수당)",
    salary * 12 연봉
FROM
    employees;

------------------------------------------------------------

-- WHERE --

SELECT
    first_name,
    last_name,
    job_id,
    salary,
    hire_date
FROM
    employees
WHERE
    salary <= 4000
    AND first_name LIKE 'S%'
    OR salary BETWEEN 15000 AND 25000
    AND hire_date >= TO_DATE('20030101', 'YYYYMMDD');

-- DATE 타입은 TO_DATE로 바꿔서 연산하는 것이 호환상 좋아보인다.

-- HIRE_DATE >= '03/01/01' -- 이건 sql developer에서 먹히더라
-- HIRE_DATE >= '01-jan-03' -- 이건 vscode의 extension에서 먹힘


-- BETWEEN AND
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary BETWEEN 14000 AND 17000;

-- IS NULL
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NULL;

-- IS NOT NULL
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NOT NULL;

-- OR 노가다
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id = 10
    OR department_id = 20
    OR department_id = 40;

-- IN
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id IN(10, 20, 40);

-- ANY와 비교해보자.
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id = ANY(10, 20, 40);

-- LIKE
SELECT
    first_name
FROM
    employees
WHERE
    lower(first_name) LIKE '%am%';

SELECT
    first_name
FROM
    employees
WHERE
    lower(first_name) LIKE '_a%';

-- st로 시작하는 이름 찾기, 그러나 ESCAPE용 기호가 t일때?
SELECT
    first_name
FROM
    employees
WHERE
    lower(first_name) LIKE 'stt%'ESCAPE't';

-- 이름이 4글자인 사람 중 두번 째 문자가 a
SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    last_name LIKE '_a__';

-- department_id == 90 && salary >= 20000?
SELECT
    first_name,
    last_name,
    employee_id,
    salary
FROM
    employees
WHERE
    department_id = 90
    AND salary >= 20000;

-- hire_date 07/01/01~07/12/31?
SELECT
    first_name,
    last_name,
    hire_date
FROM
    employees
WHERE
    hire_date >= TO_DATE('110101', 'yymmdd')
    AND hire_date <= TO_DATE('151231', 'yymmdd');

-------------------------------------------------------------

-- manager_id 100, 120, 147 찾기를 할 때
-- 다음과 같이 순서정렬을 해줄 수도 있다.
SELECT
    first_name,
    last_name,
    manager_id
FROM
    employees
WHERE
    manager_id IN (100, 120, 147)
ORDER BY
    manager_id,
    1 DESC,
    2 ASC;

-- sort department_id asc
SELECT
    department_id,
    first_name,
    last_name,
    salary
FROM
    employees
ORDER BY
    department_id;

-- salary >= 10000, sort salary desc
SELECT
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    salary >= 10000
ORDER BY
    salary DESC;

-- sort department_id asc, salary desc
SELECT
    department_id,
    first_name,
    last_name,
    salary
FROM
    employees
ORDER BY
    1 ASC,
    4 DESC;
-----------------------------------------------------------------

-- 요약하자면

-- SELECT projection_컬럼_목록
-- FROM 테이블목록
-- WHERE 필터링조건
-- ORDER BY 정렬조건;
