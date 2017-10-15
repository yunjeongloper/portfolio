<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%

request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");

HashMap<String, String> protocol = new HashMap<String, String>();
protocol.put("TCP","Transmission Control Protocol");
protocol.put("UDP","User Datagram Protocol");
protocol.put("HTTP","Hyper Text Transfer Protocol");
protocol.put("IP","Internet address Protocol");
protocol.put("SMTP","Simple Mail Transfer Protocol");

request.setAttribute("PROTOCOL",protocol);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	표준 액션(Standard Action)<br>
	태그형태를 취하는 명령을 기본적으로 JSP에서 제공한다. <br>
	
	예 include <br>
	<jsp:include page="c05include.jsp" />
	
	예 forward <br>
	<jsp:forward page="c06fwd.jsp?key=IP"></jsp:forward>
	
	c03의 마지막부분 <br>
</body>
</html>