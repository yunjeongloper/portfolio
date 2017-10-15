<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
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

	<h2>modelGetDetail.jsp</h2>

<%
	int idx = Integer.parseInt(request.getParameter("idx"));
	int cat = Integer.parseInt(request.getParameter("cat"));

	Connection conn = null;
	PreparedStatement pstmt = null;
	
	String dbgMsg = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		// get connection
		conn = ds.getConnection();
		String sql = "select * from model_table where idx='"+idx+"'";
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
				
		// Attribute 설정할 변수들을 만들기
		String title = null;
		String color = null;
		String size = null;
		int price = 0;
		String file1 = null;
		String file2 = null;
		
		if(rs.next())
		{			
			title = rs.getString("title");
			color = rs.getString("color");
			size = rs.getString("size");
			price = rs.getInt("price");
			file1 = rs.getString("file1");
			file2 = rs.getString("file2");
			
			request.setAttribute("title", title);
			request.setAttribute("color", color);
			request.setAttribute("size", size);
			request.setAttribute("price", Integer.toString(price));
			request.setAttribute("file1", file1);
			request.setAttribute("file2", file2);
			request.setAttribute("idx", idx);
			request.setAttribute("cat", cat);
			
		}
		
		if(rs != null)
			rs.close();
		
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
	//location.href="main.jsp?cmd=modelDetail.jsp";	
</script>

</body>
</html>