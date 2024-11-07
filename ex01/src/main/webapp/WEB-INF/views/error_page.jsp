<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>페이지 공사중!!!</h2>
	<h4><c:out value="${ exception.getMessage() }" /></h4>

	<ul>
	<c:forEach items="${ exception.getStackTrace() }" var="stack">
		<li><c:out value="${ stack }" />
	</c:forEach>
	</ul>
</body>
</html>