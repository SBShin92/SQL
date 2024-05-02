-- HIMEDIA.XE

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

-- HIMEDIA -----------------------------------------------
-- 다시 테이블 삽입
INSERT INTO test VALUES (
    2024
);

SELECT
    *
FROM
    test;

-- 유저 정보?
SELECT
    *
FROM
    user_users;

SELECT
    *
FROM
    all_users;

-- HIMEDIA -----------------------------------------------
-- 테이블 만들어보자.
SELECT
    *
FROM
    tabs;

CREATE TABLE book (
    book_id NUMBER(5),
    title VARCHAR2(50),
    author VARCHAR2(10),
    pub_date DATE DEFAULT sysdate
);

SELECT
    *
FROM
    tabs;

-- SUBQUERY를 이용한 테이블 생성
CREATE TABLE emp_it AS (
    SELECT
        *
    FROM
        hr.employees
    WHERE
        job_id LIKE 'IT%'
);

SELECT
    *
FROM
    tabs;

SELECT
    *
FROM
    emp_it;

DESCRIBE emp_it;

-- HIMEDIA -----------------------------------------------
-- DROP
DROP TABLE emp_it;

-- SYSTEM, HIMEDIA -------------------------------------------
-- 사용자 자신의 권한(ROLE) 알기
SELECT
    *
FROM
    user_role_privs;

-- CONNECT, RESOURCE 안에는 어떤 권한이?
SELECT
    privilege
FROM
    role_sys_privs
WHERE
    role='CONNECT';

SELECT
    privilege
FROM
    role_sys_privs
WHERE
    role='RESOURCE';

-- HIMEDIA -----------------------------------------------
-- author table 생성

CREATE TABLE author (
    author_id NUMBER(10),
    author_name VARCHAR2(100) NOT NULL,
    author_desc VARCHAR2(500),
    PRIMARY KEY (author_id)
);

desc author;

-- book테이블의 book_id를 pk로
ALTER TABLE book MODIFY ( book_id NUMBER(10));

ALTER TABLE book ADD (CONSTRAINT c_book_pk PRIMARY KEY (book_id));

-- book table에서 author 지우고 author_id 추가, fk 설정

ALTER TABLE book DROP (author);

ALTER TABLE book ADD (author_id NUMBER(10));

ALTER TABLE book ADD (CONSTRAINT c_author_id_fk FOREIGN KEY (author_id) REFERENCES author(author_id));

-- 제약조건 확인
SELECT
    *
FROM
    user_objects;

SELECT
    *
FROM
    user_constraints;

-- HIMEDIA -----------------------------------------------

-- 사용자 스키마 이름, 타입 정보 출력
SELECT
    *
FROM
    user_objects;

SELECT
    object_name,
    object_type
FROM
    user_objects;

-- 제약조건 확인
SELECT
    *
FROM
    user_constraints;

SELECT
    constraint_name,
    constraint_type,
    search_condition,
    table_name
FROM
    user_constraints
WHERE
    table_name = 'BOOK';

-- HIMEDIA -----------------------------------------------
-- INSERT
-- 작가테이블 확인
SELECT
    *
FROM
    author;

TRUNCATE TABLE author;

-- 작가 추가 (묵시적 방법)
INSERT INTO author VALUES(
    1,
    '박경리',
    '토지 작가'
);

-- 작가 추가 (명시적 방법)
INSERT INTO author (
    author_id,
    author_name
) VALUES (
    2,
    '김영하'
);

-- 키 값만 맞으면 순서는 상관없다.
INSERT INTO author (
    author_name,
    author_id,
    author_desc
) VALUES(
    '류츠신',
    3,
    '삼체 작가'
);

-- DML은 트랜잭션 대상이기 때문에 롤백 가능하다.
ROLLBACK;

-- COMMIT
COMMIT;

--------------------------------------------------------------

-- UPDATE
-- UPDATE 이렇게 쓰면 ㅈ된거임
UPDATE author
SET
    author_desc = '알쓸신잡 출연';

-- WHERE 조건 꼭 쓰기
UPDATE author
SET
    author_desc = '알쓸신잡 출연';

WHERE AUTHOR_NAME = '김영하';

-------------------------------------------------------------

-- hr에서 정보 가져와서 테이블 생성
CREATE TABLE emp123 AS (
    SELECT
        *
    FROM
        hr.employees
    WHERE
        department_id IN (10, 20, 30)
);

-- 확인
SELECT * FROM emp123;


-- JOB_ID MK_로 시작하는 직원 삭제
DELETE FROM emp123 WHERE job_id LIKE 'MK_%';

-- 다 지워봐
DELETE FROM emp123;

-- 확인
SELECT * FROM emp123;

-- 롤백
ROLLBACK;

-----------------------------------------------------------------------

-- Transaction
CREATE TABLE t_test (
    log_text VARCHAR2(100)
);

SELECT * FROM t_test;

INSERT INTO t_test VALUES('트랜잭션 시작');
INSERT INTO t_test VALUES('데이터 INSERT');

-- 세이브포인트 설정
SAVEPOINT sp1;

-- 데이터 넣고 세이브포인트로 롤백해보기
INSERT INTO t_test Values('데이터 2 INSERT');
SELECT * FROM t_test;
ROLLBACK TO sp1;
SELECT * FROM t_test;

-- 다시 데이터 넣고 세이브
INSERT INTO t_test Values('데이터 2 INSERT');
SAVEPOINT sp2;
SELECT * FROM t_test;

-- 잘못 넣어버렸네
UPDATE t_test SET log_text = '업데이트';
SELECT * FROM t_test;
ROLLBACK TO sp2;
SELECT * FROM t_test;

-- sp1으로 돌아가고나면 sp2로 못돌아감
ROLLBACK TO sp1;
-- ROLLBACK TO sp2;

-- 데이터 다른거 넣어보자
INSERT INTO t_test VALUES('데이터 3 INSERT');
SELECT * FROM t_test;

-- 커밋 (트랜잭션 종료)
COMMIT;
SELECT * FROM t_test;

-- 롤백 안돼~
ROLLBACK;
SELECT * FROM t_test;
