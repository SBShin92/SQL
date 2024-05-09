show databases;
use sakila;
show tables;
desc actor;

SELECT VERSION(), CURRENT_DATE();
use hrdb;
show tables;
desc employees;
SELECT 
    *
FROM
    employees;
SELECT 
    *
FROM
    jobs;

-- DB CRUD
show databases;
-- DB를 만들 때, 문자셋, 정렬 방식을 명시적으로 지정하는 것이 좋다.
CREATE DATABASE db_name CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
drop database db_name;

-- USER CRUD
CREATE USER 'user_id'@'localhost' IDENTIFIED BY 'password';
DROP USER 'user_id'@'localhost';

-- 권한
use mysql;
select user from user;
grant select on *.* to 'user_id'@'localhost';
revoke all privileges on *.* from 'user_id'@'localhost';

-- 실습 예제
-- [실습 1] 데이터베이스 'webdb'를 생성해 봅시다.
-- [실습 2] localhost로부터 접속할 수 있는 사용자 dev를 만들어 봅시다.
-- [실습 3] 새로 생성한 사용자 'dev'@'localhost'에게 'webdb'의 모든 테이블에 대한 모든
-- 권한을 부여해 봅시다.
CREATE DATABASE webdb;
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost';
-- 확인, 삭제
show databases;
use mysql; select user from user;
drop user 'dev'@'localhost';
-- -----------------------------------------------------------------
-- [실습 1] author 테이블을 만들어 봅시다
use webdb;
show tables;
create table authors (
	author_id int PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    author_desc VARCHAR(500)
);
desc authors;
-- 테이블 생성 할 때의 생성정보 확인
show create table authors;
-- -------------------
-- [실습 2] book 테이블을 만들어 봅시다
CREATE TABLE books (
	book_id int primary key,
    title varchar(100) not null,
    pubs varchar(100),
    pub_date datetime DEFAULT now(),
    author_id int,
    CONSTRAINT fk_book FOREIGN KEY (author_id)
    REFERENCES author(author_id)
);
desc books;
-- -----------------------------------------------------------------
-- INSERT
INSERT INTO authors VALUES (1, '박경리', '토지 작가');
SELECT 
    *
FROM
    authors;
INSERT INTO authors (author_id, author_name)
VALUES (2, '김영하');
-- 트랜잭션
START TRANSACTION;

SELECT * FROM authors;

UPDATE authors
SET author_desc = "알쓸신잡 출연"
WHERE author_id = 2;

SELECT * FROM authors;
-- 커밋 or 롤백
COMMIT;
ROLLBACK;

SELECT 
    *
FROM
    authors;
show tables;
-- ----------------------------------------------------------
-- auto increment
ALTER TABLE authors AUTO_INCREMENT = 3;
select * from authors;
-- 이미 존재하는 테이블에 auto_increment 속성을 부여하려면 FK 속성을 제거한 후
-- 입력해주어야 한다
DESC authors;
desc books;
-- 처음엔 안될거임
ALTER TABLE authors MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;
-- 외래키 정보 확인 후 삭제
select * from information_schema.KEY_COLUMN_USAGE WHERE constraint_schema = 'webdb';
ALTER TABLE books DROP CONSTRAINT book_fk;
-- PK제약 삭제 후 auto_increment, pk 재부여
ALTER TABLE authors DROP PRIMARY KEY;
-- 이제 될거임
ALTER TABLE authors MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;
-- 다시 FK 지정
ALTER TABLE books 
ADD CONSTRAINT fk_book 
FOREIGN KEY (author_id) 
REFERENCES authors(author_id);
-- 확인
desc authors;
-- 오토커밋 활성화
SET autocommit = 1;

-- auto_increment 시작지점 설정
SELECT MAX(author_id) FROM authors;
ALTER TABLE authors AUTO_INCREMENT = 3;
-- 확인
desc authors;
INSERT INTO authors (author_name, author_desc) VALUES ('고길동', '얼음왕국 자서전');
INSERT INTO authors (author_name, author_desc) VALUES ('류츠신', '삼체 작가');
select * from authors;
-- ------------------------
-- books 재생성
drop table books cascade;
CREATE TABLE books (
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    pubs VARCHAR(100),
    pub_date DATETIME DEFAULT now(),
    author_id INT,
    CONSTRAINT fk_books FOREIGN KEY (author_id)
    REFERENCES authors(author_id)
);
-- 확인
select * from information_schema.KEY_COLUMN_USAGE WHERE constraint_schema = 'webdb';

-- books에 데이터입력
INSERT INTO books (title, pub_date, author_id)
VALUES ('토지', '1994-03-04', 1);
INSERT INTO books (title, author_id)
VALUES ('살인자의 기억', 2);
INSERT INTO books (title, author_id)
VALUES ('쇼생크 탈출', 3);
INSERT INTO books (title, author_id)
VALUES ('삼체', 4);
select * from books;
-- join해서 출력해보기
SELECT 
    title, pub_date, author_name, author_desc
FROM
    books
        JOIN
    authors USING (author_id);


SELECT LAST_INSERT_ID();