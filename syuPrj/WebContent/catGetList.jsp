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

	<h2>catGetList.jsp</h2>

<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		// get connection
		conn = ds.getConnection();
		String sql = "select * from cat_table order by code ASC";
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		// Attribute 설정할 리스트를 각각 만들기
		List<Integer> catIdxList = new ArrayList<Integer>();
		List<Integer> catCodeList = new ArrayList<Integer>();
		List<Integer> catUseList = new ArrayList<Integer>();
		List<String> catNameList = new ArrayList<String>();
		
		while(rs.next())
		{
			catIdxList.add(rs.getInt("idx"));
			catUseList.add(rs.getInt("useflag"));
			catCodeList.add(rs.getInt("code"));
			catNameList.add(rs.getString("name"));
		}
		
		request.setAttribute("catIdxList", catIdxList);
		request.setAttribute("catUseList", catUseList);
		request.setAttribute("catCodeList", catCodeList);
		request.setAttribute("catNameList", catNameList);
		request.setAttribute("catSize", catIdxList.size());
		
		
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



</body>
</html>