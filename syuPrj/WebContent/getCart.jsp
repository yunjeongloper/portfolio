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

	<h2>getCart.jsp</h2>

<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		String id = (String) session.getAttribute("sessID");
		
		
		// get connection
		conn = ds.getConnection();
		String sql = null;
		sql = String.format("SELECT * FROM cart_table c "
							+ " INNER JOIN model_table m "
							+ " ON c.midx = m.idx and c.id='%s' "
							+ " ORDER BY c.idx DESC", id);
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		// Attribute 설정할 리스트를 각각 만들기
		List<Integer> cartIdxList = new ArrayList<Integer>();
		List<Integer> cartMidxList = new ArrayList<Integer>();
		List<Integer> cartPriceList = new ArrayList<Integer>();
		List<Integer> cartCntList = new ArrayList<Integer>();
		List<String> cartSizeList = new ArrayList<String>();
		List<String> cartColorList = new ArrayList<String>();
		List<String> cartFileList = new ArrayList<String>();
		List<String> cartTitleList = new ArrayList<String>();
		
		int cntTotal = 0;
		int priceTotal = 0;
		
		while(rs.next())
		{
			int model = rs.getInt("midx");
			
			cartIdxList.add(rs.getInt("idx"));
			cartMidxList.add(rs.getInt("midx"));
			cartPriceList.add(rs.getInt("price"));
			cartCntList.add(rs.getInt("cnt"));
			
			cartSizeList.add(rs.getString("size"));
			cartColorList.add(rs.getString("color"));
			
			cartFileList.add(rs.getString("file1"));
			cartTitleList.add(rs.getString("title"));
		
			cntTotal = cntTotal + rs.getInt("cnt");
			priceTotal = priceTotal + rs.getInt("price") * rs.getInt("cnt");
		}
		
		request.setAttribute("cartIdxList", cartIdxList);
		request.setAttribute("cartMidxList", cartMidxList);
		request.setAttribute("cartPriceList", cartPriceList);
		request.setAttribute("cartSizeList", cartSizeList);
		request.setAttribute("cartColorList", cartColorList);
		request.setAttribute("cartCntList", cartCntList);
		request.setAttribute("cartFileList", cartFileList);
		request.setAttribute("cartTitleList", cartTitleList);
		
		request.setAttribute("cartSize", cartIdxList.size());
		request.setAttribute("cntTotal", cntTotal);
		request.setAttribute("priceTotal", priceTotal);
		
		
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