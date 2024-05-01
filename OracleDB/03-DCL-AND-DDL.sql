-- DCL


-- SYSTEM -------------------------------------------
-- 계정 생성. 그러나, 그냥은 못만든다.
CREATE USER himedia IDENTIFIED BY himedia;

-- oracle 18버전부터 containers database 개념이 도입
-- CDB로 만드는 것이 default이다.
CREATE USER c##himedia IDENTIFIED BY himedia;

DROP USER c##himedia CASCADE;

-- CDB가 아닌 일반 DB를 만들려면?
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER himedia IDENTIFIED BY himedia;

-- CREATE SESSION만 주기
GRANT CREATE SESSION TO himedia;

-- CONNECT, RESOURCE ROLE 주기
GRANT CONNECT, RESOURCE TO himedia;

-- HIMEDIA -----------------------------------------------
-- test 테이블 생성
CREATE TABLE test(
    a NUMBER
);

describe test;

-- 테이블삽입. 그러나, 권한이 없다.
INSERT INTO test VALUES (
    2024
);

-- SYSTEM -------------------------------------------
-- TABLESPACE 관련 권한 부여, 크기(QUOTA)를 제한하지 않겠다.
ALTER USER himedia DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

-- HIMEDIA -----------------------------------------------
-- 다시 테이블 삽입
INSERT INTO test VALUES (
    2024
);

SELECT *
FROM test;

-- 유저 정보?
SELECT *
FROM user_users;

SELECT *
FROM all_users;

-- SYSTEM -------------------------------------------
-- 아래 쿼리는 SYSTEM계정, SYSDBA에서 가능
SELECT *
FROM dba_users;

-- HR 스키마의 employees 테이블 조회 권한을 himedia에게 주고싶다?
-- HR -----------------------------------------------
GRANT SELECT ON employees TO himedia;

-- 조회해보자
-- HIMEDIA -----------------------------------------------
SELECT *
FROM hr.employees;

SELECT *
FROM hr.departments;

------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------

-- DCL

-- SYSTEM -------------------------------------------
-- 스키마 내의 모든 테이블 확인
SELECT *
FROM tabs;

-- HIMEDIA -----------------------------------------------
-- 테이블 만들어보자.
SELECT *
FROM tabs;

CREATE TABLE book (
    book_id NUMBER(5),
    title VARCHAR2(50),
    author VARCHAR2(10),
    pub_date DATE DEFAULT sysdate
);

SELECT *
FROM tabs;

-- SUBQUERY를 이용한 테이블 생성
CREATE TABLE emp_it AS (
    SELECT *
    FROM hr.employees
    WHERE job_id LIKE 'IT%'
);

SELECT *
FROM tabs;

SELECT *
FROM emp_it;

DESCRIBE emp_it;






-- HIMEDIA -----------------------------------------------
-- DROP
DROP TABLE emp_it;