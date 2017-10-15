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

	<h2>장바구니 담기</h2>

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
		
		// id, midx, size, color, cnt, price
		int midx = Integer.parseInt(request.getParameter("midx"));
		int price = Integer.parseInt(request.getParameter("price"));
		int count = Integer.parseInt(request.getParameter("count"));
		String color = request.getParameter("color");
		String size = request.getParameter("size");
		String id = (String)session.getAttribute("sessID");
		
		String sql = null;
		sql = String.format("insert into cart_table"
				+ "(id, midx, size, color, cnt, price) values "
				+ "('%s', '%d', '%s', '%s', '%d', '%d')"
				, id, midx, size, color, count, price);
		
		pstmt = conn.prepareStatement(sql);
		int affectedRow = pstmt.executeUpdate();
		
		if(affectedRow >=1)
			msg = "장바구니가 등록되었습니다.";
		else
			msg = "장바구니 등록 에러입니다.";
		
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
	location.href='main.jsp?cmd=showCart.jsp';
</script>











</body>
</html>