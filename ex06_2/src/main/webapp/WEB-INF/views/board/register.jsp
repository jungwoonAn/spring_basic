<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>    

<%@include file="../includes/header.jsp" %>
    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">게시글 등록</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    Board Register
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <form action="/board/register" method="post">                    
                   	 	<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }">
                    	<div class="form-group">
                    		<label>제목</label>
                    		<input type="text" class="form-control" name="title" />
                    	</div>
                    	<div class="form-group">
                    		<label>내용</label>
                    		<textarea class="form-control" row="3" name="content"></textarea>
                    	</div>
                    	<div class="form-group">
                    		<label>작성자</label>
                    		<input type="text" class="form-control" name="writer"
                    			value='<sec:authentication property="principal.username"/>' readonly />
                    	</div>
                    	
                    	<button type="submit" class="btn btn-primary">등록</button>
                    	<button type="reset" class="btn btn-warning">취소</button>
                    	<button type="button" class="btn btn-success" 
                    		onclick="location.href='/board/list'">목록</button>                    
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