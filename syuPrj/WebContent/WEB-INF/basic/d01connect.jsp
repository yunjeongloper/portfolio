<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2> MYSQL Connect</h2>
<%
	Class.forName("com.mysql.jdbc.Driver");
	
	out.print("Driver Loading OK<br>");
	
	Connection conn = DriverManager.getConnection(
				"jdbc:mysql://localhost:3306/syudb?characterEncoding=utf8",
				"syu",
				"syupass"
			);
	
	if(conn != null)
	{
		out.print("Connection OK");
		
		conn.close();
	} else{
		out.print("Connection Error");
	}
%>

</body>
</html>