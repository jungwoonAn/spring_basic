alter session set "_ORACLE_SCRIPT"=true;

-- 계정생성 및 테이블스페이스 설정
create user book_ex identified by 1234
default tablespace users
temporary tablespace temp;

-- 권한 설정
grant connect, dba to book_ex;