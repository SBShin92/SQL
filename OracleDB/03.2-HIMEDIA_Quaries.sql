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

SELECT *
FROM emp_it;

describe emp_it;

desc book;

DROP TABLE emp_it;

ALTER TABLE emp_it ADD (hp VARCHAR2(20));

ALTER TABLE emp_it SET UNUSED (hp);

SELECT *
FROM user_role_privs;

CREATE TABLE author (
    author_id NUMBER(10),
    author_name VARCHAR2(100) NOT NULL,
    author_desc VARCHAR2(500),
    PRIMARY KEY (author_id)
);

desc author;

ALTER TABLE book MODIFY ( book_id NUMBER(10));
ALTER TABLE book ADD (CONSTRAINT c_book_pk PRIMARY KEY (book_id));
ALTER TABLE book ADD ( CONSTRAINT c_author_id_fk FOREIGN KEY (author_id) REFERENCES author(author_id));

desc book;

SELECT object_name, object_type FROM user_objects;

SELECT
    constraint_name,
    constraint_type,
    search_condition,
    table_name
FROM
    user_constraints
WHERE TABLE_NAME = 'BOOK';