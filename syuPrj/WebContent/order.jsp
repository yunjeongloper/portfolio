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

	<h2> 주문 등록</h2>
	
	1. 사용자 입력값을 삽입 <br>
	2. 최근 삽입된 데이터를 검색해서 키값(주문번호) 찾기<br>
	3. 카트에 있는 데이터를 item으로 복사<br>

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
	
		msg = "접속 성공";
		
		// code, name, useflag

		String oname = request.getParameter("oname");
		String rname = request.getParameter("rname");
		
		String otel = request.getParameter("otel");
		String rtel = request.getParameter("rtel");
		
		String omobile = request.getParameter("omobile");
		String rmobile = request.getParameter("rmobile");
		
		String oaddr = request.getParameter("oaddr");
		String raddr = request.getParameter("raddr");
		
		String memo = request.getParameter("memo");
		String id = request.getParameter("id");
	
		msg="변수 수집";
		
		
		
		String sql = null;
		sql = String.format("insert into order_table "
				+ "(id, oname, otel, omobile, oaddr, rname, rtel, rmobile, raddr, memo, status, day, time )"
				+ "values "
				+ "('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '1' , now(), now())" 
				, id, oname, otel, omobile, oaddr, rname, rtel, rmobile, raddr, memo);
						
		pstmt = conn.prepareStatement(sql);
		int affectedRow = pstmt.executeUpdate();

	
		if(affectedRow >=1)
		{
			msg = "주문 1차 성공";
		
			sql = "SELECT * FROM order_table order by idx desc limit 1";
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				int oidx = rs.getInt("idx");
				msg = "주문번호 = " + oidx;
				
				sql = String.format("select * from cart_table where id='%s' order by idx desc", id);
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while(rs.next())
				{
					// insert
					
					sql = String.format("INSERT INTO item_table "
								+ "(oidx, midx, size, color, cnt, price)"
								+ " values "
								+ "('%d', '%d', '%s', '%s', '%d', '%d' )"
								, oidx 
								, rs.getInt("midx") 
								, rs.getString("size")
								, rs.getString("color")
								, rs.getInt("cnt")
								, rs.getInt("price")
							);
					PreparedStatement pstmt1 = null;
					pstmt1 = conn.prepareStatement(sql);
					pstmt1.executeUpdate();
				}
				
				sql = String.format("DELETE FROM cart_table WHERE id='%s' ", id);
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
			}
		}
		else
			msg = "주문 에러입니다.";
		
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
	location.href='main.jsp';
</script>


</body>
</html>