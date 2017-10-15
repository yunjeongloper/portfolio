<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
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

	<h2> MYSQL Connect</h2>
<%
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;

	try{
		Class.forName("com.mysql.jdbc.Driver");
		out.print("Driver Loading OK<br>");

		conn = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/syudb?characterEncoding=utf8",
					"syu",
					"syupass"
				);
		
		if(conn != null)
		{
			out.print("Connection OK<br>");
			
			stmt = conn.createStatement();
			String sql = null;
			
			int idx = Integer.parseInt(request.getParameter("idx"));
			
			sql = String.format("delete from users where idx='%d'",idx);
			
			int affectedRow = stmt.executeUpdate(sql);
			
			
		} else
		{
			out.print("Connection Error");
		}
	} catch(Exception e){
		
		out.print("Error : " + e.getMessage() + "<br>");
	} finally //사후처리
	{
		try
		{
			if(conn != null)
				conn.close();
			
			if(stmt != null)
				stmt.close();
			
			if(rs != null)
				rs.close();
		} catch(Exception e)
		{
			
		}
	}

	RequestDispatcher rd = request.getRequestDispatcher("d05db.jsp");
	rd.forward(request,response);
	
%>

</body>
</html>