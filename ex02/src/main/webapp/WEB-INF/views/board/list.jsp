<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    

	<%@include file="../includes/header.jsp" %>
	
    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">게시판 목록</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    Board List
                    <button type="button" id="regBtn" class="btn btn-xs btn-primary pull-right">글쓰기</button>
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <table width="100%" class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>#번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                                <th>수정일</th>
                            </tr>
                        </thead>
                        
                        <tbody>                      
                        <c:forEach items="${ list }" var="board">
                        	<tr>
                        		<td><c:out value="${ board.bno }" /></td>
                        		<td>
                        			<a class="move" href="${ board.bno }">
                        				<c:out value="${ board.title }" />
                        			</a>
                        		</td>
                        		<td><c:out value="${ board.writer }" /></td>
                        		<td><fmt:formatDate pattern="yyy-MM-dd" value="${ board.regdate }" /></td>
                        		<td><fmt:formatDate pattern="yyy-MM-dd" value="${ board.updateDate }" /></td>
                        	</tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    
                    <!-- Paging start -->
                    <nav aria-label="Page navigation" class="text-center">
					  <ul class="pagination">
					  	<c:if test="${ pageMaker.prev }">
						    <li class="page-item">
						      <a class="page-link" href="${ pageMaker.startPage - 1 }" aria-label="Previous">
						        <span aria-hidden="true">&laquo;</span>
						      </a>
						    </li>
					    </c:if>
					    
					    <c:forEach begin="${ pageMaker.startPage }"
					    	end="${ pageMaker.endPage }" var="num">
						    <li class="page-item ${ pageMaker.cri.pageNum == num ? 'active' : '' }">
						    	<a class="page-link" href="${ num }">${ num }</a>
						    </li>
					    </c:forEach>
					    
					    <c:if test="${ pageMaker.next }">
						    <li class="page-item">
						      <a class="page-link" href="${ pageMaker.endPage + 1 }" aria-label="Next">
						        <span aria-hidden="true">&raquo;</span>
						      </a>
						    </li>
					    </c:if>
					  </ul>
					</nav>
					
					<form action="/board/list" method="get" id="actionForm">
						<input type="hidden" name="pageNum" value="${ pageMaker.cri.pageNum }">
						<input type="hidden" name="amount" value="${ pageMaker.cri.amount }">
					</form>
                    <!-- Paging end -->
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>
        <!-- /.col-lg-6 -->
    </div>
    <!-- /.row -->
    
	<!-- modal start -->
	<div id="myModal" class="modal" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">등록 완료</h5>
	      </div>
	      <div class="modal-body">
	        <p>처리가 완료되었습니다.</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
	      </div>
	    </div>
	  </div>
	</div>
	<!-- modal end -->

	<%@include file="../includes/footer.jsp" %>
 
    <script>
    $(document).ready(function() {    	
    	// 재전송(redirect) 처리
        let result = '<c:out value="${result}" />';
        
        checkModal(result);
        
        // 뒤로가기 문제 해결을 위한 코드
        history.replaceState({},null,null);
        
        function checkModal(result){
        	if(result === '' || history.state){
        		return;
        	}else if(parseInt(result) > 0){
        		$('.modal-body p').html('게시글 ' + parseInt(result) + '번이 등록되었습니다.');
        	}
        	
        	$('#myModal').modal('show'); 
        }
        
        // 모달 닫기
        $('#myModal button').click(function(){
        	$('#myModal').modal('hide'); 
        });
        
     	// 글쓰기 버튼 동작
    	/* $('#regBtn').click(function(){
    		location.href = '/board/register';
    	}); */
    	regBtn.addEventListener('click', function(){
    		location.href = '/board/register';
    	});
    	
    	// 페이징 버튼 동작
    	const actionForm = $('#actionForm');
    	
    	$('.page-link').click(function(e){
    		e.preventDefault();
    		//console.log('click');
    		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
    		actionForm.submit();
    	});
    	
    	// 게시물 조회를 위한 이벤트 처리
    	$('.move').click(function(e){
    		e.preventDefault();
    		actionForm.append('<input type="hidden" name="bno" value="' +
    				$(this).attr("href") + '">"');
    		actionForm.attr('action','/board/get');
    		actionForm.submit();
    	});
    });
    </script>