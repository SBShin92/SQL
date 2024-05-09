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
create database webdb;
create user 'dev'@'localhost' identified by 'dev';
grant all privileges on *.* to 'dev'@'localhost';
-- -----------------------------------------------------------------
