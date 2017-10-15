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
	String msg = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		//get connection
		conn = ds.getConnection();
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");
		
		String sql;
		sql = String.format("select * from members where id='%s' and pass=password('%s')",id,pass);
		
		out.println(sql);
		
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		if(rs.next())
		{
			session.setAttribute("sessID", rs.getString("id"));
			session.setAttribute("sessName", rs.getString("name"));
			session.setAttribute("sessLevel", rs.getInt("level"));
			
			msg = "반갑습니다." + rs.getString("name") + "님 안녕하세요";
		} else
		{
			// 실패
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
		out.println("REASON: "+e.getMessage()+"<br>");
	}
	

%>
<script>
	alert('<%=msg%>');
	location.href="main.jsp";

</script>
</body>
</html>