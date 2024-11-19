<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
  justify-content: center;
  align-items: center;
  top: 0;
  left: 0;
  width:100%;
  height:100%;
  background-color: rgba(0, 0, 0, 0.7);
  z-index: 100;
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}

</style>
</head>
<body>
	<h1>Upload with Ajax</h1>
	
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	
	<button id="uploadBtn">업로드</button>	
		
	<div class="uploadResult">
		<ul>
		</ul>
	</div>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script type="text/javascript">
	
	// 섬네일 클릭시 원본 이미지 보여주기
	function showImage(fileCallPath) {
		// alert("fileCallPath" + fileCallPath);
		
		$('.bigPictureWrapper').css('disply', 'flex').show();
		
		$('.bigPicture').html('<img src="/display?fileName='+ encodeURI(fileCallPath) +'">')
		.animate({width: '100%', height: '100%'}, 1000);
	}
	
	// 섬네일 닫기
	$('.bigPictureWrapper').click(function(){
		$('bitPicture').animate({width: '0%', height: '0%'}, 1000);
		setTimeout(function() {
			$(this).hide();
		}, 1000);
	});
	
	$(function(){
		// 파일 업로드 제외 확장자와 크기 설정
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
		
		const cloneObj = $('.uploadDiv').clone();  // 파일첨부 복제
		
		$('#uploadBtn').click(function(){
			const formData = new FormData();
			const inputFile = $('input[name="uploadFile"]');
			
			let files = inputFile[0].files;			
			// console.log(files);
			
			// add File Data to formData
			for(let i=0; i<files.length; i++){
				
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,
				data : formData,
				type: 'post',
				dataType : 'json',
				success: function(result){					
					alert("파일이 업로드 되었습니다.");
					console.log(result);					
					showUploadedFile(result);					
					$('.uploadDiv').html(cloneObj.html());  // 첨부파일 초기화
				}
			});
		});
		
		const uploadResult = $('.uploadResult ul');
		
		function showUploadedFile(uploadResultArr) {
			let str = '';
			
			$(uploadResultArr).each(function(i, obj) {
				if(!obj.image) {  // 일반 파일이면	
					let fileCallPath = encodeURIComponent(obj.uploadPath + '/' + 
							obj.uuid + "_" + obj.fileName);
					
					str += '<li><a href="/download?fileName='+ fileCallPath +'">'
					+ '<img src="/resources/img/attach.png"><br>'
					+ obj.fileName + '</a></li>';
				}else {  // 이미지 파일이면
					let fileCallPath = encodeURIComponent(obj.uploadPath + 
							"/s_" + obj.uuid + "_" + obj.fileName);
				
					let originPath = obj.uploadPath + '\\' + obj.uuid + '_' + obj.fileName;
					console.log("originPath before : " + originPath);
					
					originPath = originPath.replace(new RegExp(/\\/g), '/');
					console.log("originPath after : " + originPath);
					
					str += '<li><a href="javascript:showImage(\'/'+ originPath +'\')">'
						+'<img src="/display?fileName='+ 
							fileCallPath +'"><br>' + obj.fileName + '</a></li>';
				}
			});
			
			uploadResult.append(str);
		}
	});
	</script>

</body>
</html>