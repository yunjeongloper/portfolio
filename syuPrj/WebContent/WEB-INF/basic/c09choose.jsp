<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	c09choose.jsp?num=테스트 <br>
	
	<c:choose>
		<c:when test="${param.num eq 0}">
			This is Zero
		</c:when>
		<c:when test="${param.num eq 1 }">
			This is One
		</c:when>
		<c:when test="${param.num eq 2 }">
			This is Two
		</c:when>
		<c:when test="${empty param.num }">
			This is Empty Parameter
		</c:when>
		<c:otherwise>
			Unknown Value
		</c:otherwise>
	</c:choose>
</body>
</html>