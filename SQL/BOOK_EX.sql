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

select * from reply;