-- board ���̺� ����
create table board (
    bno number(10,0),
    title varchar2(200) not null,
    content varchar2(2000) not null,
    writer varchar2(50) not null,
    regdate date default sysdate,
    updatedate date default sysdate
);

-- bno�� PK�� �������� ����
alter table board add constraint pk_board primary key (bno);

-- ����� ���̺� ���� �������� Ȯ��
select * from user_constraints;

-- ������ ����
create sequence seq_board;

-- ���� ������
insert into board(bno, title, content, writer)
values(seq_board.nextval, '�׽�Ʈ ����5','�׽�Ʈ ����5','user00');

-- board ���̺� ��ȸ
select * from board;


commit;

select * from board where bno > 0;

-- ����¡�� ���� ������ �߰�
insert into board(bno, title, content, writer)
(select seq_board.nextval, title, content, writer from board);

-- �����۾� �߰��Ͽ� ���Ľð� �Ҹ� Ȯ��
select * from board order by bno+1 desc;
select * from board order by bno desc;

-- �ε����� ����
select
    /*+ index_desc(board pk_board) */
* 
from board
where bno > 0;

-- rownum ���
select
    /*+ index_desc(board pk_board) */
    rownum rn, bno, title, content
from board
where bno > 0;

-- 10���� ������ ����
select
    /*+ index_desc(board pk_board) */
    rownum rn, bno, title, content
from board
where rownum <= 10;

-- 2������ 11~20���� 10���� ������ ����
-- �ƹ��͵� ��ȸ���� ����
select
    /*+ index_desc(board pk_board) */
    rownum rn, bno, title, content
from board
where rownum > 10 and rownum <= 20;

-- rownum�� �ζ��� �並 ������ ����
select bno, title, content
from (
    select
        /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content
    from board
    where rownum <= 20)
where rn > 10;

select bno, title, content, writer, regdate, updatedate
from (
    select
        /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content, writer, regdate, updatedate
    from board
    where rownum <= 20)
where rn > 10;

-- �˻� ó��
select *
from (
    select /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content, writer, regdate, updatedate
    from board
    where title like '%���%' and rownum <= 20)
where rn > 10;

-- ���� �˻�(����� �ٸ��� �����ϴ� SQL)
select *
from (
    select /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content, writer, regdate, updatedate
    from board
    where title like '%���%' or content like '%������%' and rownum <= 20)
where rn > 10;

-- ���� �˻�(���������� ó���ϱ� ���ؼ��� ()�� �̿��ؼ� OR ������ ó��)
select *
from (
    select /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content, writer, regdate, updatedate
    from board
    where (title like '%���%' or content like '%������%') and rownum <= 20)
where rn > 10;


-- ��� ó���� ���� ���̺� ������ ó��
-- reply ���̺� ����
create table reply (
    rno number(10, 0),
    bno number(10, 0) not null,
    reply varchar2(1000) not null,
    replyer varchar2(50) not null,
    replyDate date default sysdate,
    updateDate date default sysdate
);

-- reply ������ ����
create sequence seq_reply;

-- reply rno �÷� PK constraint ����
alter table reply add constraint pk_reply primary key (rno);

-- reply bno �÷� FK constraint ����
alter table reply add constraint fk_reply_board foreign key (bno) references board (bno);

commit;

-- reply ���̺� �ε��� ����
create index idx_reply on reply (bno desc, rno asc);

-- Ư�� �Խù��� rno ������� ������ ��ȸ
select /*+ index(reply idx_reply) */
    rownum rn, bno, rno, reply, replyer, replyDate, updateDate
from reply
where bno = 130
and rno > 0;

-- ��� ����¡ ó��(��������)
select bno, rno, reply, replyer, replyDate, updateDate
from (
    select /*+ index_desc(reply idx_reply) */
        rownum rn, bno, rno, reply, replyer, replyDate, updateDate
    from reply
    where bno = 130
        and rno > 0
        and rownum <= 10)
where rn > 5;


select * from reply where rno > 0;

select * from reply where bno = 22540 order by replydate desc;


-- 5-19_Ʈ�����
-- �ǽ� ���̺� ����
create table sample1(col1 varchar2(500));
create table sample2(col2 varchar2(50));

commit;

select * from sample1;
select * from sample2;

-- ���� ������ ����
delete from sample1;
commit;

-- 5-20_��ۼ� ó��
-- board ���̺� ��ۼ� �÷� �߰�
alter table board add (replycnt number default 0);

update board set replycnt = (select count(rno) from reply where reply.bno = board.bno);

commit;


-- 7-32_������ ��ť��Ƽ_JDBC�� �̿��ϴ� ���� ����/���� ó��
-- users ���̺� ����
create table users(
      username varchar2(50) not null primary key,
      password varchar2(50) not null,
      enabled char(1) default '1'
);

-- authorities ���̺� ����
create table authorities (
      username varchar2(50) not null,
      authority varchar2(50) not null,
      constraint fk_authorities_users foreign key(username) references users(username)
);

-- �ε��� ����
create unique index ix_auth_username on authorities (username,authority);

-- users ���̺� ������ ����
insert into users (username, password) values ('user00','pw00');
insert into users (username, password) values ('member00','pw00');
insert into users (username, password) values ('admin00','pw00');

-- authorities ���̺� ������ ����
insert into authorities (username, authority) values ('user00','ROLE_USER');
insert into authorities (username, authority) values ('member00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_ADMIN');

commit;

-- users ���̺� ��ȸ
select * from users;

-- authorities ���̺� ��ȸ
select * from authorities order by authority;


-- ���� ���̺��� �̿��ϴ� ���
-- member ���̺� ����
create table member(
      userid varchar2(50) not null primary key,
      userpw varchar2(100) not null,
      username varchar2(100) not null,
      regdate date default sysdate, 
      updatedate date default sysdate,
      enabled char(1) default '1'
);

-- member_auth ���̺� ����
create table member_auth (
     userid varchar2(50) not null,
     auth varchar2(50) not null,
     constraint fk_member_auth foreign key(userid) references member(userid)
);

select * from member;

select * from member_auth;

select m.userid, userpw, username, enabled, regdate, updatedate, a.auth
from member m left outer join member_auth a
on m.userid = a.userid
where m.userid = 'user15';

-- 7-35_�����ͺ��̽��� �̿��ϴ� �ڵ� �α���
-- �α��� ������ �����ϴ� ���̺�(persistent_logins) ����
create table persistent_logins (
    series varchar2(64) primary key,
    username varchar2(64) not null,    
    token varchar2(64) not null,
    last_used timestamp not null
);

commit;

select * from persistent_logins;