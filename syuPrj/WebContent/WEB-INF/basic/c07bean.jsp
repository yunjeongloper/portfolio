<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2>자바 이용하기 : Property</h2>
	
	<jsp:useBean id="taxi" class="kr.ac.syu.web.Car"></jsp:useBean>
	<!-- java로 표현하면 taxi.setSpeed("77")과 같음 -->
	<jsp:setProperty property="speed" name="taxi" value="77"/>
	<!-- java로 표현하면 taxi.setColor("read")과 같음 -->
	<jsp:setProperty property="color" name="taxi" value="RED"/>
	
	<jsp:useBean id="bus" class="kr.ac.syu.web.Car"></jsp:useBean>
	<jsp:setProperty property="speed" name="bus" value="60"/>
	<jsp:setProperty property="color" name="bus" value="BLUE"/>
	
	<hr>
	taxi info<br>
	<jsp:getProperty property="speed" name="taxi"/><br>
	<jsp:getProperty property="color" name="bus" />
	
</body>
</html>