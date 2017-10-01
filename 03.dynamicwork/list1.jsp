<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name=viewport content="width=device-width, initial-scale=1, user-scalable=0"> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="css/core.css">
<link rel="stylesheet" href="css/core2.css" media="only screen and (min-width:800px)">
<title>THE LETTER</title>
</head>
<body>
	<div class="page-hdr" style="cursor:pointer;" onclick="home()">THE LETTER</div>
	<span class="menubtn" onclick="openNav()">&#9776;</span>
	<div id="mySidenav" class="sidenav">
	  <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
	  <a href="about.html">About</a>
	  <div class="section mbot-30"></div>
	  <a id="books" href="list.jsp">Books</a>
	  <a id="movies" href="list1.jsp">Movies</a>
	  <a id="exhibits" href="list2.jsp">Exhibitions</a>
	  <a id="loginbtn" class="login" onclick="login()">login</a>
	  <a id="logoutbtn" class="login" onclick="logout()">logout</a>
	</div>
<%
	Class.forName("com.mysql.jdbc.Driver");
 	Connection conn = DriverManager.getConnection (
 			"jdbc:mysql://localhost:3306/theletter",
 			"root", "asdf"
 			);
	int total = 0;
	
	try {
		Statement stmt = conn.createStatement();

		String sqlCount = "SELECT COUNT(*) FROM board1";
		ResultSet rs = stmt.executeQuery(sqlCount);
		
		if(rs.next()){
			total = rs.getInt(1);
		}
		rs.close();
		
		String sqlList = "SELECT NUM, USERNAME, TITLE, HIT from board1 order by NUM DESC";
		rs = stmt.executeQuery(sqlList);
		
%>
	<div class="section mtop-20"></div>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr height="1" bgcolor="#F2CB61"><td colspan="6" width="752"></td></tr>
	 <tr height="1"><td width="5"></td></tr>
	 <tr height="40" style="text-align:center;">
	   <td width="5"></td>
	   <td width="73">번호</td>
	   <td width="250">제목</td>
	   <td width="73">작성자</td>
	   <td width="58">조회수</td>
	   <td width="7"></td>
	  </tr>
	  <tr height="1" bgcolor="#D2D2D2"><td colspan="6"></td></tr>
	  
<%
	if(total==0) {
%>
	<tr align="center" bgcolor="#FFFFFF" height="30">
	<td colspan="6">등록된 글이 없습니다.</td>
	</tr>
<%
	 } else {
	 	while(rs.next()) {
			int idx = rs.getInt(1);
			String name = rs.getString(2);
			String title = rs.getString(3);
			int hit = rs.getInt(4);
%>

<tr height="35" align="center"class="board">
<td>&nbsp;</td>
	<td><%=idx %></td>
	<td align="left"><a href="view1.jsp?idx=<%=idx%>"
	style="color:black;text-decoration:none"><%=title %></a></td>
	<td align="center"><%=name %></td>
	<td align="center"><%=hit %></td>
	<td>&nbsp;</td>
</tr>
<tr height="1" bgcolor="#D2D2D2"><td colspan="6"></td></tr>
<% 
		}
	} 
	rs.close();
	stmt.close();
	conn.close();
	} 
	catch(SQLException e) {
	out.println( e.toString() );
}
%>
<tr height="1" bgcolor="#F2CB61"><td colspan="6" width="752"></td></tr>
 </table>
 
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td colspan="4" height="5"></td></tr>
  <tr align="center">
   <td><div class="form-submit mtop-30" onclick="window.location='write1.jsp'">WRITE MY LETTER</div>
  </tr>
</table>
</body>
</html>
<script src="js/jquery-1.12.0.min.js"></script>
<script src="js/core.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	AJAX.call("jsp/session.jsp", null, function (data) {
		var id = data.trim();
		if (id == "NA") {
			$("#logoutbtn").hide();
		}
		else {
			start(id);
		}
	});
});

function start(id) {
	$("#loginbtn").hide();
	$("#logoutbtn").show();
}

function logout() {
	if(confirm("로그아웃 하시겠습니까??") == true) {
		AJAX.call("jsp/logout.jsp", null, function (data) {
			window.location.href = "main.html";
		});
	}
}

function home(){
	window.location.href="main.html";
}

function login(){
	window.location.href="log_in.html";
}
function writeNew() {
	window.location.href = "write.html";
}

/* Set the width of the side navigation to 250px and the left margin of the page content to 250px */
function openNav() {
    document.getElementById("mySidenav").style.width = "150px";
    document.getElementById("main").style.marginLeft = "250px";
}

/* Set the width of the side navigation to 0 and the left margin of the page content to 0 */
function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("main").style.marginLeft = "0";
}
</script>