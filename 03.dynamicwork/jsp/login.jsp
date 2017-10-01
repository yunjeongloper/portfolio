<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	System.out.println("uid: "+request.getParameter("uid"));
	System.out.println("upass: "+request.getParameter("upass"));
	
	request.setCharacterEncoding("UTF-8");

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn=DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/theletter",
		"root","asdf");
	Statement st = conn.createStatement();
	
	String sql="SELECT id,password FROM user WHERE id="
			+request.getParameter("uid");

	String id = request.getParameter("uid");
	ResultSet rs=st.executeQuery(sql);
	if(rs.next()==false){
		out.println("NA");
	}
	else{
		String pass=rs.getString("password");
		if(pass.equals(request.getParameter("upass"))==false){
			out.println("PS");
		}
		else{
			// session handling for login 
			// NOTE THAT session check is done by calling session.jsp in each html ...
			if (session.isNew() || session.getAttribute("uid") == null) {
				session.setAttribute("uid", id);
				session.setMaxInactiveInterval(24*60*60);
			}
			out.print("OK");
		}
	}

	rs.close();
	st.close();
	conn.close();	
%>