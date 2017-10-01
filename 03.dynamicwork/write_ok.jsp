<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("euc-kr");

	System.out.println("글들어감. 이름:"+request.getParameter("name"));
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection (
			"jdbc:mysql://localhost:3306/theletter",
			"root", "asdf"
			);
	String name = request.getParameter("name");
	String password = request.getParameter("password");
	String title = request.getParameter("title");
	String memo = request.getParameter("memo");
	
	try {	
		String sql = "INSERT INTO board(username,password,title,memo) VALUES(?,?,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, name);
		pstmt.setString(2, password);
		pstmt.setString(3, title);
		pstmt.setString(4, memo);
		
		pstmt.execute();
		System.out.println("sql");
		pstmt.close();
		
		conn.close();
} catch(SQLException e) {
	out.println( e.toString() );
	}
%>
<script language=javascript>
   self.window.alert("입력한 글을 저장하였습니다.");
   location.href="list.jsp"; 

</script>

