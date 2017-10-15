<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="date" value="<%=new Date() %>"></c:set>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2>현재 날짜와 시간 표현하기 </h2>
	
	오늘날짜 <fmt:formatDate value="${date }"/><br>
	현재시간 <fmt:formatDate value="${date }" type="time"/><br><br>
	
	1. <fmt:formatDate value="${date }" type="both"/><br><br>
	
	2. style=short,long,medium,full<br>
	2-1. <fmt:formatDate value="${date }" type="both" dateStyle="short" timeStyle="short"/><br>
	2-2. <fmt:formatDate value="${date }" type="both" dateStyle="short" timeStyle="long"/><br>
	2-3. <fmt:formatDate value="${date }" type="both" dateStyle="long" timeStyle="short"/><br>
	2-4. <fmt:formatDate value="${date }" type="both" dateStyle="long" timeStyle="long"/><br><br>
	
	3. 패턴 2017-09-27 20:19:30 형식으로 표현하기 ("yyyy-MM-dd (E) hh:mm:ss")<br>
		<fmt:formatDate value="${date }" type="both" pattern="yyyy-MM-dd (E) hh:mm:ss"/>


	<br><br>
	<h2>숫자 표현하기 </h2>
	
	<fmt:formatNumber value="1234567890123" groupingUsed="true" />
	
	

</body>
</html>