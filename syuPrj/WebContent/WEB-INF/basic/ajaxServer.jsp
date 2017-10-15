<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

나는 ajaxServer입니다.<br>

<%
	String key = request.getParameter("key");
	int len = key.length();
	
	// 5 10
	if(len<5)
	{
		out.print("<font color='#FF0000'>위험합니다.</font>"); 
	} else if(len<10)
	{
		out.print("안전도 보통");
	} else
	{
		out.print("<font color='#00FF00'>안전합니다.</font>");
	}
%>

</body>
</html>