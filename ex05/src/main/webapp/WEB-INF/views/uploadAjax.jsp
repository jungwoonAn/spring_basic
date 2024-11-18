<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Upload with Ajax</h1>
	
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	
	<button id="uploadBtn">업로드</button>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script type="text/javascript">
	$(function(){
		// 파일 업로드 제외 확장자와 크기 설정
		const regex = new RegExp('(.*?)\.(exe|sh|zip|alz)$');
		const maxSize = 5242880;  // 5MB
		
		// 
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
		
		$('#uploadBtn').click(function(){
			const formData = new FormData();
			const inputFile = $('input[name="uploadFile"]');
			
			let files = inputFile[0].files;			
			console.log(files);
			
			// add File Data to formData
			for(let i=0; i<files.length; i++){
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,
				data : formData,
				type: 'post',
				success: function(result){
					alert("파일이 업로드 되었습니다.");
				}
			});
		});
	});
	</script>

</body>
</html>