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
                		<!-- 추가 -->
                		<input type="hidden" name="pageNum" value="${ cri.pageNum }">
                		<input type="hidden" name="amount" value="${ cri.amount }">
                		<input type="hidden" name="type" value="${ cri.type }">
                		<input type="hidden" name="keyword" value="${ cri.keyword }">
                		
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
    
    <!-- AttachedFile -->
    <div class="bigPictureWrapper">
    	<div class="bigPicture"></div>
    </div>
    
    <div class="row">
        <div class="col-lg-12">
        	<div class="panel panel-default">
                <div class="panel-heading">Files</div>
                <div class="panel-body">
                	<div class="form-group uploadDiv">
                		<input type="file" name="uploadFile" multiple>
                	</div>
                
                    <div class="uploadResult">
						<ul>
						</ul>
					</div>
                </div>
            </div>
        </div>
    </div>
    
<%@include file="../includes/footer.jsp" %>
 
<script>
 $(document).ready(function(){
	 const formObj = $('form');
	 
	 $("button").click(function(e){
		 e.preventDefault();  // 버튼 form 전송기능 막기
		 
		 let operation = $(this).data("oper");
		 console.log(operation);
		 
 		 if(operation === 'remove'){
			 formObj.attr('action', '/board/remove');
		 }else if(operation === 'list'){
			 //location.href='/board/list';
			 //return;
			 formObj.attr('action', '/board/list').attr('method','get');
			 const pageNumTag = $("input[name='pageNum']").clone();
			 const amountTag = $("input[name='amount']").clone();
			 const typeTag = $("input[name='type']").clone();
			 const keywordTag = $("input[name='keyword']").clone();
			 
			 formObj.empty();
			 formObj.append(pageNumTag);
			 formObj.append(amountTag);
			 formObj.append(typeTag);
			 formObj.append(keywordTag);			 
		 }else if(operation === 'modify'){  // 게시물 수정 이벤트 처리
		 	console.log('modify submit clicked');
		 
		 	let str = '';
		 	
		 	$('.uploadResult ul li').each(function(i, obj){
				const jobj = $(obj);
				console.dir(jobj);  //JavaScript 객체 속성을 인터랙티브한 목록으로 표시
				
				str += '<input type="hidden" name="attachList['+ i +'].fileName" value="'+ jobj.data('filename') +'">';
				str += '<input type="hidden" name="attachList['+ i +'].uuid" value="'+ jobj.data('uuid') +'">';
				str += '<input type="hidden" name="attachList['+ i +'].uploadPath" value="'+ jobj.data('path') +'">';
				str += '<input type="hidden" name="attachList['+ i +'].fileType" value="'+ jobj.data('type') +'">';
			});
			
			formObj.append(str).submit();
		 }
		 formObj.submit();
		 
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
						str += '<span>'+ attach.fileName + '</span>';
						str += '<button type="button" data-file="'+ fileCallPath +'" data-type="image"';
						str += 'class="btn btn-warning btn-circle">';
						str += '<i class="fa fa-times"></i></button><br>';
						str += '<img src="/display?fileName='+ fileCallPath +'">';
						str += '</div></li>';
					}else {		
						let fileCallPath = encodeURIComponent(attach.uploadPath + '/' 
								+ attach.uuid + '_' + attach.fileName);
						
						str += '<li data-path="'+ attach.uploadPath +'" data-uuid="'+ attach.uuid;
						str += '" data-filename="'+ attach.fileName +'" data-type="'+ attach.fileType +'"><div>';
						str += '<span>'+ attach.fileName + '</span>';
						str += '<button type="button" data-file="'+ fileCallPath +'" data-type="image"';
						str += 'class="btn btn-warning btn-circle">';
						str += '<i class="fa fa-times"></i></button><br>';
						str += '<img src="/resources/img/attach.png">';
						str += '</div></li>';
					}
				});
				$('.uploadResult ul').html(str);
			}
		});
		
		// 첨부파일 'x'버튼 클릭시 화면상에서 사라지도록
		$('.uploadResult').on('click', 'button', function(){
			console.log('delete file');
			
			if(confirm('파일을 삭제하시겠습니까?')){
				let targetLi = $(this).closest('li');
				targetLi.remove();
			}
		});
		
		// 파일 업로드 유효성 검사
		const regex = new RegExp('(.*?)\.(exe|sh|zip|alz)$');
		const maxSize = 5242880;  // 5MB
		
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize){
				alert('파일 사이즈 초과');
				return false;
			}
			
			if(regex.test(fileName)){
				alert('해당 종류의 파일은 업로드할 수 없습니다.');
				return false;
			}
			
			return true;
		}
		
		// <input type="file">의 내용이 변경되는 것을 감지
		$('input[type="file"]').change(function(e){
			const formData = new FormData();
			const inputFile = $('input[name="uploadFile"]');
			let files = inputFile[0].files;
			
			for(let i=0; i<files.length; i++){
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				
				formData.append('uploadFile', files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				type: 'post',
				processData: false,
				contentType: false,
				data: formData,
				dataType: 'json',
				success: function(result){
					console.log(result);
					showUploadResult(result); // 업로드 결과 처리 함수 호출
				}
			});
		});
		
		
		// 업로드된 결과를 화면에 섬네일 등을 만들어서 처리하는 부분
		function showUploadResult(uploadResultArr) {
			if(!uploadResultArr || uploadResultArr.length == 0){return;}
			
			const uploadUL = $('.uploadResult ul');
			
			let str = '';
			
			$(uploadResultArr).each(function(i, obj){
				// image type
				if(obj.image){
					let fileCallPath = encodeURIComponent(obj.uploadPath + '/s_' 
							+ obj.uuid + '_' + obj.fileName);
					
					str += '<li data-path="'+ obj.uploadPath +'" data-uuid="'+ obj.uuid;
					str += '" data-filename="'+ obj.fileName +'" data-type="'+ obj.image +'"><div>';
					str += '<span>'+ obj.fileName + '</span>';
					str += '<button type="button" data-file="'+ fileCallPath +'" data-type="image"';
					str += 'class="btn btn-warning btn-circle">';
					str += '<i class="fa fa-times"></i></button><br>';
					str += '<img src="/display?fileName='+ fileCallPath +'">';
					str += '</div></li>';
				}else {
					let fileCallPath = encodeURIComponent(obj.uploadPath + '/' 
							+ obj.uuid + '_' + obj.fileName);
					let fileLink = fileCallPath.replace(new RegExp(/\\/g), '/');
					
					str += '<li data-path="'+ obj.uploadPath +'" data-uuid="'+ obj.uuid;
					str += '" data-filename="'+ obj.fileName +'" data-type="'+ obj.image +'"><div>';
					str += '<span>'+ obj.fileName + '</span>';
					str += '<button type="button" data-file="'+ fileCallPath +'" data-type="image"';
					str += 'class="btn btn-warning btn-circle">';
					str += '<i class="fa fa-times"></i></button><br>';
					str += '<img src="/resources/img/attach.png">';
					str += '</div></li>';
				}
			});
			
			uploadUL.append(str);
		}		
	});
</script>