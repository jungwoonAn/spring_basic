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

select * from reply;