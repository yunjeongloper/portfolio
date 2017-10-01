<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	System.out.println("uid: "+request.getParameter("uid"));
	System.out.println("uname: "+request.getParameter("uname"));
	System.out.println("upass: "+request.getParameter("upass"));
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn=DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/theletter",
		"root","asdf");
	Statement st = conn.createStatement();
	
	String sql="SELECT id FROM user WHERE id="
			+request.getParameter("uid");
	ResultSet rs=st.executeQuery(sql);
	System.out.println(sql);
	if(rs.next()){
		out.println("EX");
		return;
	}
	
	sql="INSERT INTO user(id,name,password) VALUES("+
		request.getParameter("uid")+",'"+
		request.getParameter("uname")+"','"+
		request.getParameter("upass")+"')";	
	out.println("OK");
	st.executeUpdate(sql);

	rs.close();
	st.close();
	conn.close();
%>