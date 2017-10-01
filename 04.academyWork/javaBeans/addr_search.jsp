<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="ch07.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="addr" class="ch07.AddrBean"/>
<jsp:setProperty name="addr" property="*"/>
<jsp:useBean id="am" class="ch07.AddrManager" scope="application"/>
<%	
	request.setCharacterEncoding("UTF-8"); 
	AddrBean ab = am.searchAddr(request.getParameter("username"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ch07 : 주소록 목록</title>
</head>
<body>

<div align=center>

<H2>주소록</H2>

<HR>

<a href="addr_form.html">주소추가</a><P>

<form method = post action = "addr_search.jsp">
	검색 :<input type = "text" name = "username">
	<input type = "submit" value = "검색">
</form><br>

<table border=1 width=500>
	<tr><td>이름</td><td>전화번호</td><td>이메일</td><td>성별</td></tr>
		<tr>
		<td><%=ab.getUsername() %></td>
		<td><%=ab.getTel() %></td>
		<td><%=ab.getEmail() %></td>
		<td><%=ab.getSex() %></td></tr>
</table>

</div>

</body>
</html>


