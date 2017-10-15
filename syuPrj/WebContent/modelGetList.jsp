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

	<h2>modelGetList.jsp</h2>

<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		int cat = Integer.parseInt(request.getParameter("cat"));
		
		// get connection
		conn = ds.getConnection();
		String sql = null;
		sql = String.format("select * from model_table where cat='%d' and useflag='1' order by idx",cat);;
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		// Attribute 설정할 리스트를 각각 만들기
		List<Integer> modelIdxList = new ArrayList<Integer>();
		List<String> modelTitleList = new ArrayList<String>();
		List<Integer> modelPriceList = new ArrayList<Integer>();
		List<String> modelFile1List = new ArrayList<String>();
		
		while(rs.next())
		{
			modelIdxList.add(rs.getInt("idx"));
			modelTitleList.add(rs.getString("title"));
			modelPriceList.add(rs.getInt("price"));
			modelFile1List.add(rs.getString("file1"));
		}
		
		request.setAttribute("modelIdxList", modelIdxList);
		request.setAttribute("modelTitleList", modelTitleList);
		request.setAttribute("modelPriceList", modelPriceList);
		request.setAttribute("modelFile1List", modelFile1List);
		request.setAttribute("modelSize", modelFile1List.size());
		
		
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