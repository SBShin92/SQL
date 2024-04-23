--SQL 문장의 주석은 두 개의 하이픈(--)으로 표기
--SQL 문장의 끝은 세미콜론(;)
--키워드들은 대소문자를 구분하지 않는다.(단, 실제 데이터의 경우 대소문자를 구분한다.)

--테이블 구조 확인: DESCRIBE
DESCRIBE employees;
describe departments;
describe locations;

-- SELECT
SELECT employee_id "id", 
    first_name AS 성, 
    last_NAME aS 이름,
    phone_number "전화 번호",
    hire_date 입사일,
    SalarY "급  여",
    salary * 12 "연  봉"
FroM employees;

-- 단순연산
SELECT 3 + 4 FROM dual;

---- err? why? : job_id는 VARCHAR!
--select job_id * 12
--from employees;