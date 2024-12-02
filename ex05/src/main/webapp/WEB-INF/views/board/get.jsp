<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    

<%@include file="../includes/header.jsp" %>
<style>
.uploadResult {
   width: 100%;
   background-color: #eee;
}

.uploadResult ul {
   display: flex;
   flex-flow: row;
   justify-content: center;
   align-items: center;
}

.uploadResult ul li {
   list-style: none;
   padding: 10px;
}

.uploadResult ul li img {
   width: 100px;
}

.bigPictureWrapper {
  position: fixed;
  display: none;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  z-index: 1001;
  cursor: pointer;
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 0;
}
</style>

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
                   		<input type="hidden" name="type" value="${ cri.type }">
                   		<input type="hidden" name="keyword" value="${ cri.keyword }">
                   	</form>                  
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    
    <!-- AttachedFile -->
    <div class="bigPictureWrapper">
    	<div class="bigPicture"></div>
    </div>
    
    <div class="row">
        <div class="col-lg-12">
        	<div class="panel panel-default">
                <div class="panel-heading">Files</div>
                <div class="panel-body">
                    <div class="uploadResult">
						<ul>
						</ul>
					</div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- reply -->
    <div class="row">
        <div class="col-lg-12">
        	<div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-comments fa-fw"></i> Reply
                    <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글 작성</button>
                </div>
                <div class="panel-body">
                    <ul class="chat"></ul>
                </div>
                <div class="panel-footer"></div>
            </div>
        </div>
    </div>
    
    <!-- Modal -->
    <div class="modal" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">Reply Modal</h5>
	      </div>
	      <div class="modal-body">
	      	<div class="form-group">
	          <label>내용</label>
	          <input type="text" class="form-control" name="reply" value="New Reply!!">
	        </div>
	        <div class="form-group">
	          <label>작성자</label>
	          <input type="text" class="form-control" name="replyer" value="test00">
	        </div>
	        <div class="form-group">
	          <label>작성일</label>
	          <input type="text" class="form-control" name="replyDate" value="">
	        </div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" id="modalModBtn" class="btn btn-warning">수정</button>
	        <button type="button" id="modalRemoveBtn" class="btn btn-danger">삭제</button>
	        <button type="button" id="modalRegisterBtn" class="btn btn-primary">등록</button>
	        <button type="button" id="modalCloseBtn" class="btn btn-close btn-secondary" data-bs-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>

<%@include file="../includes/footer.jsp" %>

<script src="/resources/js/reply.js"></script>

<style>
	.chat > li:hover{cursor: pointer;}
</style>

<script type="text/javascript">
$(function(){
	console.log('==========');
	console.log('js test');
	
	const bnoValue = '<c:out value="${ board.bno }"/>';
	const replyUL = $('.chat');
	
	showList(1);
	
	function showList(page){
		console.log('show list page : ' + page);
		
		replyService.getList({bno: bnoValue, page: page || 1}, function(replyCnt, list){
			console.log('replyCnt : ' + replyCnt);
			console.log('list : ' + list);
				
			if(page == -1){
				pageNum = Math.ceil(replyCnt/5.0);  // 마지막 페이지
				showList(pageNum);  // 목록 갱신
				return;
			}

			let str = '';
			
			if(list == null || list.length == 0){
				replyUL.html('');
				return;
			}else {
				for(let i=0, len= list.length; i<len; i++){
					str += '<li class="clearfix" data-rno="'+ list[i].rno +'">';
					str += '<div class="header"><strong class="premary-font">'+ list[i].replyer +'</strong>';
					str += '<small class="pull-right text-muted">'+ replyService.displayTime(list[i].replyDate) +'</small></div>';
					str += '<p>'+ list[i].reply +'</p></li>'
				}
				
				replyUL.html(str);  // 댓글 출력
				
				showReplyPage(replyCnt);  // 화면에 댓글 페이지 번호 출력 메서드 호출
			}			
		});
	}
	
	// 모달창 이벤트
	const modal = $('.modal');
	const modalInputReply = modal.find('input[name="reply"]');
	const modalInputReplyer = modal.find('input[name="replyer"]');
	const modalInputReplyDate = modal.find('input[name="replyDate"]');
	
	const modalModBtn = $('#modalModBtn');
	const modalRemoveBtn = $('#modalRemoveBtn');
	const modalRegisterBtn = $('#modalRegisterBtn');
	
	// 댓글 작성 버튼 이벤트
	$('#addReplyBtn').click(function(){
		modal.find('input').val('');
		modalInputReplyDate.closest('div').hide();
		
		modal.find('button[id != modalCloseBtn]').hide();
		modalRegisterBtn.show();
		
		$('.modal').modal('show');
	});
	
	// 댓글 등록 버튼 이벤트
	modalRegisterBtn.click(function(){
		let reply = {
			reply: modalInputReply.val(),
			replyer: modalInputReplyer.val(),
			bno: bnoValue
		}
		
		replyService.add(reply, function(result){
			alert("댓글이 등록되었습니다.");
			
			modal.find('input').val('');
			modal.modal('hide');
			
			// showList(1); // 댓글 목록 다시 호출(갱신)
			showList(-1);  // 마지막 페이지로 댓글 목록 갱신
		});
	});
	
	// 댓글 닫기 버튼 이벤트
	$('#modalCloseBtn').click(function(){
		modal.modal('hide');
	})
	
	// 댓글 조회(댓글 제목 클릭) 이벤트 처리
	replyUL.on('click', 'li', function(){
		let rno = $(this).data('rno');
		// console.log(rno);
		
		replyService.get(rno, function(reply){
			modalInputReply.val(reply.reply);
			modalInputReplyer.val(reply.replyer);
			modalInputReplyDate.val(replyService.displayTime(reply.replyDate))
				.attr('readonly','readonly');
			modal.data('rno', reply.rno);
			
			modal.find('button[id != modalCloseBtn]').hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			modal.modal('show');
		})
	});
	
	// 댓글 수정 버튼 이벤트
	modalModBtn.click(function(){
		let reply = {
			rno: modal.data('rno'),
			reply: modalInputReply.val()			
		}
		
		replyService.update(reply, function(result){
			alert('댓글이 수정되었습니다.');
			
			modal.modal('hide');
			// showList(1);
			showList(pageNum);
		});
	});
	
	// 댓글 삭제 버튼 이벤트
	modalRemoveBtn.click(function(){
		let rno = modal.data('rno');
		
		replyService.remove(rno, function(result){
			alert('댓글이 삭제되었습니다');
			
			modal.modal('hide');
			// showList(1);
			showList(pageNum);
		});
	});
	
	// 댓글 페이지 번호 출력
	let pageNum = 1;
	const replyPageFooter = $('.panel-footer');
	
	function showReplyPage(replyCnt){
		let endNum = Math.ceil(pageNum / 5.0) * 5;
		let startNum = endNum - 4;
		
		let prev = (startNum != 1);
		let next = false;
		
		if(endNum * 5 >= replyCnt){
			endNum = Math.ceil(replyCnt / 5.0)
		}
		
		if(endNum * 5 < replyCnt){
			next = true;
		}
		
		let str = '<nav aria-label="Page navigation" class="text-center">';
		str += '<ul class="pagination">';
		
		if(prev){
			str += '<li class="page-item">';
			str += '<a class="page-link" href="'+ (startNum - 1) +'" aria-label="Previous">'
		    str += '<span aria-hidden="true">&laquo;</span></a></li>';  
		}
		
		for(let i=startNum; i<=endNum; i++){
			let active = pageNum == i ? 'active' : '';
			
			str += '<li class="page-item '+ active +'">';
			str += '<a class="page-link" href="'+ i +'">'+ i +'</a></li>'; 	
		}
		
		if(next){
			str += '<li class="page-item">';
			str += '<a class="page-link" href="'+ (endNum + 1) +'" aria-label="Previous">'
		    str += '<span aria-hidden="true">&raquo;</span></a></li>';  
		}
		
		str += '</ul></nav>';		
		// console.log(str);
		
		replyPageFooter.html(str);
	}	
	
	// 페이지 번호 클릭 이벤트 처리
	replyPageFooter.on('click','li a', function(e){
		e.preventDefault();
		
		let targetPageNum = $(this).attr('href');
		// console.log(targetPageNum);
		pageNum = targetPageNum;
		
		showList(pageNum);
	});
	
	// replyService add test
	/* replyService.add(
		{reply: 'JS TEST', replyer: 'tester', bno: bnoValue},
		function(result){
			alert('RESULT : ' + result);
		}
	); */
	
	// replyService getList test
	/* replyService.getList({bno: bnoValue, page: 1}, function(list){
		for(let i=0, len= list.length || 0; i<len; i++){
			console.log(list[i]);
		}
	}); */
	
	// rno=34 replyService remove test
	/* replyService.remove(34, function(result){
		console.log(result);
		
		if(result === 'success'){
			alert('삭제 되었습니다.');
		}
	}, function(err){
		alert('ERROR...');
	}); */
	
	// rno=35 replyService update test
	/* replyService.update(
		{rno: 35, bno: bnoValue, reply: 'Modified Reply..'},
		function(result){
			if(result === 'success'){
				alert('수정이 완료되었습니다.');
			}			
		}
	); */
	
	// rno=33 replyService get test
	/* replyService.get(33, function(result){
		console.log(result);
	}) */
});
</script>

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

<script>
$(function(){
	let bno = '<c:out value="${board.bno}" />';
	
	$.ajax({
		url: '/board/getAttachList',
		method: 'get',
		data: {bno: bno},
		dataType: 'json',
		success: function(result){
			console.log(result);
			
			let str = '';
			
			$(result).each(function(i, attach){
				// image type
				if(attach.fileType){
					let fileCallPath = encodeURIComponent(attach.uploadPath + '/s_' 
							+ attach.uuid + '_' + attach.fileName);
					
					str += '<li data-path="'+ attach.uploadPath +'" data-uuid="'+ attach.uuid;
					str += '" data-filename="'+ attach.fileName +'" data-type="'+ attach.fileType +'"><div>';
					str += '<img src="/display?fileName='+ fileCallPath +'">';
					str += '</div></li>';
				}else {										
					str += '<li data-path="'+ attach.uploadPath +'" data-uuid="'+ attach.uuid;
					str += '" data-filename="'+ attach.fileName +'" data-type="'+ attach.fileType +'"><div>';
					str += '<span>'+ attach.fileName + '</span><br>';
					str += '<img src="/resources/img/attach.png">';
					str += '</div></li>';
				}
			});
			$('.uploadResult ul').html(str);
		}
	});
	
	$('.uploadResult').on('click','li', function(e){
		console.log('view image');
		
		let path = encodeURIComponent($(this).data('path') + '/' 
				+ $(this).data('uuid') + '_' + $(this).data('filename'));
		console.log(path.replace(new RegExp(/\\/g), '/'))
		
		if($(this).data('type')){
			showImage(path.replace(new RegExp(/\\/g), '/'));
		}else {
			//download
			self.location = '/download?fileName=' + path;
		}		
	});
	
	// 섬네일 클릭시 원본 이미지 보여주기
	function showImage(fileCallPath) {
		// alert("fileCallPath" + fileCallPath);
		
		$('.bigPictureWrapper').show();
		
		$('.bigPicture').html('<img src="/display?fileName='+ fileCallPath +'">')
		.animate({height: '100%'}, 1000);
	}
	
	// 섬네일 닫기
 	$('.bigPictureWrapper').click(function(){
		$('.bigPicture').animate({height: '0'}, 1000);
		setTimeout(function() {
			$('.bigPictureWrapper').hide();
		}, 1000);
	}); 
	
});
</script>