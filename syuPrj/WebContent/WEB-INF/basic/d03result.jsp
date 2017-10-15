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
	
	list size = ${listSize }<br>
	
	<c:if test="${listSize gt 0 }">
		<table border=1>
			<tr height=30>
				<td>아이디</td>
				<td>이름</td>
				<td>나이</td>
				<td>비고</td>
			</tr>
			
			<c:forEach var="i" begin="0" end="${listSize-1 }">
			<tr height=30>
				<td>${idList[i] }</td>
				<td>${nameList[i] }</td>
				<td>${ageList[i] }</td>
				<td>비고</td>
			</tr>
			</c:forEach>
		</table>
	</c:if>
	
	
</body>
</html>