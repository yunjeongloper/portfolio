<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	ArrayList<String> lang = new ArrayList<String>();
	
	lang.add("JAVA");
	lang.add("JSP");
	lang.add("C++");
	lang.add("DART");
	
	lang.set(1,"PHP");	// JAVA -> PHP -> C++ -> DART
	request.setAttribute("LANGUAGE", lang);
	request.setAttribute("SIZE", lang.size());
	
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%-- 	<c:forEach var="i" begin="0" end="${SIZE-1 }">
		${LANGUAGE[i] }<br>
	</c:forEach> --%>
	
	<c:forEach var="lang" items="${LANGUAGE }">
		${lang }<br>
	</c:forEach>

</body>
</html>