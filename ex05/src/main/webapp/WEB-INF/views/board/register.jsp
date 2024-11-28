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
</style>

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
                    		<input type="text" class="form-control" name="writer" />
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
    
    <!-- 첨부파일 -->
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    첨부 파일
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                	<div class="form-group uploadDiv">
                		<input type="file" name="uploadFile" multiple>
                	</div>
                	
                	<div class="uploadResult">
                		<ul></ul>
                	</div>
    			</div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>
        <!-- /.col-lg-6 -->
    </div>

<%@include file="../includes/footer.jsp" %>

<script>
	$(function(){		
		// submit 버튼 기본동작 막기
		const formObj = $('form');
		
		$('button[type="submit"]').click(function(e){
			e.preventDefault();
			console.log('submit clicked');
			
			// 첨부파일 정보는 <input type="hidden">으로 처리하고
			// form 태그를 전송하는 부분
			let str = '';
			
			$('.uploadResult ul li').each(function(i, obj){
				const jobj = $(obj);
				console.dir(jobj);  //JavaScript 객체 속성을 인터랙티브한 목록으로 표시
				
				str += '<input type="hidden" name="attachList['+ i +'].fileName" value="'+ jobj.data('filename') +'">';
				str += '<input type="hidden" name="attachList['+ i +'].uuid" value="'+ jobj.data('uuid') +'">';
				str += '<input type="hidden" name="attachList['+ i +'].uploadPath" value="'+ jobj.data('uploadPath') +'">';
				str += '<input type="hidden" name="attachList['+ i +'].fileType" value="'+ jobj.data('fileType') +'">';
			});
			
			formObj.append(str).submit();
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
		
		// 첨부파일 삭제
		$('.uploadResult').on('click','button', function(e){
			console.log('delete file');
			
			let targetFile = $(this).data('file');
			let type = $(this).data('type');
			let targetLi = $(this).closest('li');
			
			$.ajax({
				url: '/deleteFile',
				type: 'post',
				data: {fileName: targetFile, type: type},
				dataType: 'text',
				success: function(result){
					alert(result);
					targetLi.remove();
				}
			});
		});
	});	
	
</script>