<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="javax.sql.*, java.sql.*, javax.naming.*" %>

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

	<h2> 카테고리 변경</h2>

<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	String msg = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		// get connection
		conn = ds.getConnection();
		
		// code, name, useflag, idx
		int code = Integer.parseInt(request.getParameter("code"));
		int idx = Integer.parseInt(request.getParameter("idx"));
		int useflag = Integer.parseInt(request.getParameter("useflag"));
		String name = request.getParameter("name");
		
		String sql = null;
		sql = String.format("UPDATE cat_table set code='%d', useflag='%d', name='%s' WHERE idx='%d' ", code, useflag, name, idx);
		pstmt = conn.prepareStatement(sql);
		int affectedRow = pstmt.executeUpdate();
		
		if(affectedRow >=1)
			msg = "카테고리가 변경되었습니다.";
		else
			msg = "카테고리 변경 에러입니다.";
		
		if(pstmt != null)
			pstmt.close();
		
		if(conn != null)
			conn.close();
		
		
	}catch(Exception e)
	{
		out.println("REASON: " + e.getMessage() + "<br>");
	}
	
%>

<script>
	alert('<%=msg%>');
	location.href='main.jsp?cmd=man_cat.jsp';
</script>


</body>
</html>