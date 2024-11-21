-- board 테이블 생성
create table board (
    bno number(10,0),
    title varchar2(200) not null,
    content varchar2(2000) not null,
    writer varchar2(50) not null,
    regdate date default sysdate,
    updatedate date default sysdate
);

-- bno를 PK로 제약조건 설정
alter table board add constraint pk_board primary key (bno);

-- 사용자 테이블에 대한 제약조건 확인
select * from user_constraints;

-- 시퀀스 생성
create sequence seq_board;

-- 더미 데이터
insert into board(bno, title, content, writer)
values(seq_board.nextval, '테스트 제목5','테스트 내용5','user00');

-- board 테이블 조회
select * from board;


commit;

select * from board where bno > 0;

-- 페이징을 위한 데이터 추가
insert into board(bno, title, content, writer)
(select seq_board.nextval, title, content, writer from board);

-- 연산작업 추가하여 정렬시간 소모 확인
select * from board order by bno+1 desc;
select * from board order by bno desc;

-- 인덱스로 정렬
select
    /*+ index_desc(board pk_board) */
* 
from board
where bno > 0;

-- rownum 사용
select
    /*+ index_desc(board pk_board) */
    rownum rn, bno, title, content
from board
where bno > 0;

-- 10개의 데이터 추출
select
    /*+ index_desc(board pk_board) */
    rownum rn, bno, title, content
from board
where rownum <= 10;

-- 2페이지 11~20까지 10개의 데이터 추출
-- 아무것도 조회되지 않음
select
    /*+ index_desc(board pk_board) */
    rownum rn, bno, title, content
from board
where rownum > 10 and rownum <= 20;

-- rownum을 인라인 뷰를 적용한 쿼리
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

-- 검색 처리
select *
from (
    select /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content, writer, regdate, updatedate
    from board
    where title like '%등록%' and rownum <= 20)
where rn > 10;

-- 다중 검색(예상과 다르게 동작하는 SQL)
select *
from (
    select /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content, writer, regdate, updatedate
    from board
    where title like '%등록%' or content like '%수정된%' and rownum <= 20)
where rn > 10;

-- 다중 검색(정상적으로 처리하기 위해서는 ()를 이용해서 OR 조건을 처리)
select *
from (
    select /*+ index_desc(board pk_board) */
        rownum rn, bno, title, content, writer, regdate, updatedate
    from board
    where (title like '%등록%' or content like '%수정된%') and rownum <= 20)
where rn > 10;


-- 댓글 처리를 위한 테이블 생성과 처리
-- reply 테이블 생성
create table reply (
    rno number(10, 0),
    bno number(10, 0) not null,
    reply varchar2(1000) not null,
    replyer varchar2(50) not null,
    replyDate date default sysdate,
    updateDate date default sysdate
);

-- reply 시퀀스 생성
create sequence seq_reply;

-- reply rno 컬럼 PK constraint 변경
alter table reply add constraint pk_reply primary key (rno);

-- reply bno 컬럼 FK constraint 변경
alter table reply add constraint fk_reply_board foreign key (bno) references board (bno);

commit;

-- reply 테이블에 인덱스 생성
create index idx_reply on reply (bno desc, rno asc);

-- 특정 게시물의 rno 순번대로 데이터 조회
select /*+ index(reply idx_reply) */
    rownum rn, bno, rno, reply, replyer, replyDate, updateDate
from reply
where bno = 130
and rno > 0;

-- 댓글 페이징 처리(서브쿼리)
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


-- 5-19_트랜잭션
-- 실습 테이블 생성
create table sample1(col1 varchar2(500));
create table sample2(col2 varchar2(50));

commit;

select * from sample1;
select * from sample2;

-- 기존 데이터 삭제
delete from sample1;
commit;

-- 5-20_댓글수 처리
-- board 테이블에 댓글수 컬럼 추가
alter table board add (replycnt number default 0);

update board set replycnt = (select count(rno) from reply where reply.bno = board.bno);

commit;


-- 7-32_스프링 시큐리티_JDBC를 이용하는 간편 인증/권한 처리
-- users 테이블 생성
create table users(
      username varchar2(50) not null primary key,
      password varchar2(50) not null,
      enabled char(1) default '1'
);

-- authorities 테이블 생성
create table authorities (
      username varchar2(50) not null,
      authority varchar2(50) not null,
      constraint fk_authorities_users foreign key(username) references users(username)
);

-- 인덱스 생성
create unique index ix_auth_username on authorities (username,authority);

-- users 테이블 데이터 삽입
insert into users (username, password) values ('user00','pw00');
insert into users (username, password) values ('member00','pw00');
insert into users (username, password) values ('admin00','pw00');

-- authorities 테이블 데이터 삽입
insert into authorities (username, authority) values ('user00','ROLE_USER');
insert into authorities (username, authority) values ('member00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_ADMIN');

commit;

-- users 테이블 조회
select * from users;

-- authorities 테이블 조회
select * from authorities order by authority;


-- 기존 테이블을 이용하는 경우
-- member 테이블 생성
create table member(
      userid varchar2(50) not null primary key,
      userpw varchar2(100) not null,
      username varchar2(100) not null,
      regdate date default sysdate, 
      updatedate date default sysdate,
      enabled char(1) default '1'
);

-- member_auth 테이블 생성
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

-- 7-35_데이터베이스를 이용하는 자동 로그인
-- 로그인 정보를 유지하는 테이블(persistent_logins) 생성
create table persistent_logins (
    series varchar2(64) primary key,
    username varchar2(64) not null,    
    token varchar2(64) not null,
    last_used timestamp not null
);

commit;

select * from persistent_logins;