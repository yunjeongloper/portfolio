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
	c10foreach.jsp<br>
	
	<c:forEach var="i" begin="1" end="9">
		====== Table ${i } ======<br>
		<c:forEach var="j" begin="1" end="9">
			${i }*${j } = ${i*j }<br>
		</c:forEach>
		<br>	
	</c:forEach>
	
	<c:forEach var="cnt" begin="1" end="7" step="2">
		${cnt } <br>
		<h${cnt }> hello </h${cnt }>
	</c:forEach>

</body>
</html>