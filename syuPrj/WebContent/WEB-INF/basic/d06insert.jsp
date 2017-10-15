<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

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

	<h2> MYSQL Connect</h2>
<%
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;

	try{
		Class.forName("com.mysql.jdbc.Driver");
		out.print("Driver Loading OK<br>");

		conn = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/syudb?characterEncoding=utf8",
					"syu",
					"syupass"
				);
		
		if(conn != null)
		{
			out.print("Connection OK<br>");
			
			stmt = conn.createStatement();
			String sql = null;
			
			String id = request.getParameter("id");
			String name = request.getParameter("name");
			int age = Integer.parseInt(request.getParameter("age"));
			String dept = request.getParameter("dept");
			String tel = request.getParameter("tel");
			
			sql = String.format("insert into users (id, name, age, dept, tel) values('%s', '%s', '%d', '%s','%s')",id,name,age,dept,tel);
			
			int affectedRow = stmt.executeUpdate(sql);
			
			sql = "select * from users";
			
			rs = stmt.executeQuery(sql);

			List<String> idList = new ArrayList<String>();
			List<String> nameList = new ArrayList<String>();;
			List<String> telList = new ArrayList<String>();;
			List<String> deptList = new ArrayList<String>();
			List<Integer> ageList = new ArrayList<Integer>();
			List<Integer> idxList = new ArrayList<Integer>();
			
			while(rs.next())	// rs.next = fetch
			{
				// idx, id, name, age, dept, tel
				int pidx = rs.getInt("idx");
				String pid = rs.getString("id");
				String pname = rs.getString("name");
				int tage = rs.getInt("age");
				String pdept = rs.getString("dept");
				String ptel = rs.getString("tel");
				
				out.print("(ID,NAME,AGE)="+"("+pid+","+pname+","+tage+")<br>");
				
				idxList.add(pidx);
				idList.add(pid);
				nameList.add(pname);
				ageList.add(tage);
				deptList.add(pdept);
				telList.add(ptel);
			}

			request.setAttribute("idxList",idxList);
			request.setAttribute("idList",idList);
			request.setAttribute("nameList",nameList);
			request.setAttribute("ageList",ageList);
			request.setAttribute("deptList",deptList);
			request.setAttribute("telList",telList);
			
			request.setAttribute("listSize",Integer.toString(idList.size()));
			
		} else
		{
			out.print("Connection Error");
		}
	} catch(Exception e){
		
		out.print("Error : " + e.getMessage() + "<br>");
	} finally //사후처리
	{
		try
		{
			if(conn != null)
				conn.close();
			
			if(stmt != null)
				stmt.close();
			
			if(rs != null)
				rs.close();
		} catch(Exception e)
		{
			
		}
	}

	RequestDispatcher rd = request.getRequestDispatcher("d05db.jsp");
	rd.forward(request,response);
	
%>

</body>
</html>