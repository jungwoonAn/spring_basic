alter session set "_ORACLE_SCRIPT"=true;

-- �������� �� ���̺����̽� ����
create user book_ex identified by 1234
default tablespace users
temporary tablespace temp;

-- ���� ����
grant connect, dba to book_ex;