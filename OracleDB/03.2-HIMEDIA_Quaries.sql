-- HIMEDIA.XE
SELECT username
FROM all_users;

CREATE TABLE test(
    a NUMBER
);

describe test;

INSERT INTO test VALUES (
    2024
);

SELECT *
FROM test;

SELECT *
FROM user_users;

SELECT *
FROM all_users;

SELECT *
FROM dba_users;

SELECT *
FROM hr.employees;

SELECT *
FROM hr.departments;

SELECT *
FROM tabs;

CREATE TABLE book (
    book_id NUMBER(5),
    title VARCHAR2(50),
    author VARCHAR2(10),
    pub_date DATE DEFAULT sysdate
);

SELECT *
FROM book;

CREATE TABLE emp_it AS (
    SELECT *
    FROM hr.employees
    WHERE job_id LIKE 'IT%'
);

select * from emp_it;
describe emp_it;

DROP TABLE emp_it;

alter table emp_it add (hp VARCHAR2(20));

alter table emp_it set unused (hp);