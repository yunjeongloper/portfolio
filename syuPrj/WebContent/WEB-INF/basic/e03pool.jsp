<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "javax.sql.*, java.sql.*, javax.naming.*" %>

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

	<h2>DB Connection Pool</h2>
	
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		//get connection
		conn = ds.getConnection();
		String sql = "select * from users";
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			out.println("idx = "+rs.getInt("idx"));
			out.println("id = "+rs.getString("id"));
			out.println("name = "+rs.getString("name"));
			out.println("age = "+rs.getInt("age"));
			out.println("<br>");
		}
		
		if(rs != null)
		{
			rs.close();
		}
		if(pstmt != null)
		{
			pstmt.close();
		}
		if(conn != null)
		{
			conn.close();
		}
	} catch(Exception e)
	{
		out.println("오류");
	}


%>

</body>
</html>