<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    

<%@include file="../includes/header.jsp" %>
    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">게시글 상세 보기</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    Board Read
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                	<div class="form-group">
                   		<label>번호</label>
                   		<input type="text" class="form-control" name="bno" value="${ board.bno }" readonly />
                   	</div>                    
                   	<div class="form-group">
                   		<label>제목</label>
                   		<input type="text" class="form-control" name="title" value="${ board.title }" readonly />
                   	</div>
                   	<div class="form-group">
                   		<label>내용</label>
                   		<textarea class="form-control" row="3" name="content" readonly>${ board.content }</textarea>
                   	</div>
                   	<div class="form-group">
                   		<label>작성자</label>
                   		<input type="text" class="form-control" name="writer" value="${ board.writer }" readonly />
                   	</div>
                   	
                   	<button type="button" class="btn btn-primary" data-ofer="modify"
                   		onclick="location.href='/board/modify?bno=${board.bno}'">수정</button>
                   	<button type="button" class="btn btn-secondary" data-ofer="list">목록</button>  
                   	
                   	<form action="/board/modify" method="get" id="operForm">
                   		<input type="hidden" id="bno" name="bno" value="${ board.bno }">
                   		<input type="hidden" name="pageNum" value="${ cri.pageNum }">
                   		<input type="hidden" name="amount" value="${ cri.amount }">
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
	const operForm = $('#operForm');
	
	$("button[data-ofer='modify']").click(function(){
		operForm.attr('action','/board/modify').submit();
	});
	
	$("button[data-ofer='list']").click(function(){
		operForm.find('#bno').remove();
		operForm.attr('action','/board/list').submit();
	});
});
</script>