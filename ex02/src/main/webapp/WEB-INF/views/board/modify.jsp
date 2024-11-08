<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    

<%@include file="../includes/header.jsp" %>
    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">게시글 수정</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    Board Modify
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                	<form action="/board/modify" method="post">
	                	<div class="form-group">
	                   		<label>번호</label>
	                   		<input type="text" class="form-control" name="bno" value="${ board.bno }" readonly />
	                   	</div>                    
	                   	<div class="form-group">
	                   		<label>제목</label>
	                   		<input type="text" class="form-control" name="title" value="${ board.title }" />
	                   	</div>
	                   	<div class="form-group">
	                   		<label>내용</label>
	                   		<textarea class="form-control" row="3" name="content">${ board.content }</textarea>
	                   	</div>
	                   	<div class="form-group">
	                   		<label>작성자</label>
	                   		<input type="text" class="form-control" name="writer" value="${ board.writer }" readonly />
	                   	</div>
	                   	
	                   	<button type="submit" data-oper="modify" class="btn btn-primary">수정</button>
	                   	<button type="submit" data-oper="remove" class="btn btn-danger">삭제</button>                    
	                   	<button type="submit" data-oper="list" class="btn btn-secondary">목록</button>                    
                	</form>
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>
        <!-- /.col-lg-6 -->
    </div>
    <!-- /.row -->

<%@include file="../includes/footer.jsp" %>
 
<script>
 $(document).ready(function(){
	 const formObj = $('form');
	 
	 $("button").click(function(e){
		 e.preventDefault();  // 버튼 form 전송기능 막기
		 
		 let operation = $(this).data("oper");
		 // console.log(operation);
		 
 		 if(operation === 'remove'){
			 formObj.attr('action', '/board/remove');
		 }else if(operation === 'list'){
			 //location.href='/board/list';
			 //return;
			 formObj.attr('action', '/board/list').attr('method','get');
			 formObj.empty();
		 }
		 formObj.submit();
		 
	 });	 
 });
 </script>