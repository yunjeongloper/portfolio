<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	
	String[] winners = new String[3];
	winners[0] = "홍길동";
	winners[1] = "이순신";
	winners[2] = "세종대왕";
	
	request.setAttribute("WIN",winners);
	
	ArrayList<String> lang = new ArrayList<String>();
	
	lang.add("JAVA");
	lang.add("JSP");
	lang.add("C++");
	lang.add("DART");
	
	lang.set(1,"PHP");	// JAVA -> PHP -> C++ -> DART
	request.setAttribute("LANGUAGE", lang);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	WINNER LIST <br>
	1위 : ${WIN[0] } <br>
	2위 : ${WIN[1] } <br>
	3위 : ${WIN[2] } <br><br>
	
	LANGUAGE LIST <br>
	1위 : ${LANGUAGE[0] } <br>
	2위 : ${LANGUAGE[1] } <br>
	3위 : ${LANGUAGE[2] } <br><br>

</body>
</html>