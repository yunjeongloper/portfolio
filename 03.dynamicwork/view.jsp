<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%

   Class.forName("com.mysql.jdbc.Driver");
   Connection conn = DriverManager.getConnection (
      "jdbc:mysql://localhost:3306/theletter",
      "root", "asdf"
      );
   int idx = Integer.parseInt(request.getParameter("idx"));
   try {
      Statement stmt = conn.createStatement();
      String sql = "SELECT USERNAME, TITLE, MEMO, TIME, HIT FROM board WHERE NUM=" + idx;
      ResultSet rs = stmt.executeQuery(sql);
      if(rs.next()){
         String name = rs.getString(1);
         String title = rs.getString(2);
         String memo = rs.getString(3);
         String time = rs.getString(4);
         int hit = rs.getInt(5);
            hit++;
%>
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
<table>
  <tr>
   <td>
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
     <tr style="background:url('img/table_mid.gif') repeat-x; text-align:center;">
      </tr>
    </table>
   <table>
 	 <tr height="1" bgcolor="#F2CB61"><td colspan="4" width="407"></td></tr>
     <tr height="35">
      <td width="0">&nbsp;</td>
      <td align="left" width="76">글번호</td>
      <td><%=idx%></td>
      <td width="0">&nbsp;</td>
     </tr>
    <tr height="1" bgcolor="#dddddd"><td colspan="4" width="407"></td></tr>
    <tr height="35">
      <td width="0">&nbsp;</td>
      <td>조회</td>
      <td><%=hit%></td>
      <td width="0">&nbsp;</td>
     </tr>
    <tr height="1" bgcolor="#dddddd"><td colspan="4" width="407"></td></tr>
    <tr height="35">
      <td width="0">&nbsp;</td>
      <td>이름</td>
      <td><%=name%></td>
      <td width="0">&nbsp;</td>
     </tr>
     <tr height="1" bgcolor="#dddddd"><td colspan="4" width="407"></td></tr>
    <tr height="35">
      <td width="0">&nbsp;</td>
      <td>작성일</td>
      <td><%=time%></td>
      <td width="0">&nbsp;</td>
     </tr>
      <tr height="1" bgcolor="#dddddd"><td colspan="4" width="407"></td></tr>
    <tr height="35">
      <td width="0">&nbsp;</td>
      <td>제목</td>
      <td><%=title%></td>
      <td width="0">&nbsp;</td>
     </tr>
     <tr height="1" bgcolor="#dddddd"><td colspan="4" width="407"></td></tr>
                <tr>
      <td width="0"></td>
                   <td class="viewtxt" colspan="2" height="200"><br><%=memo %></td>
                </tr>
                <% 
    sql = "UPDATE board SET HIT=" + hit + " where NUM=" +idx;
    stmt.executeUpdate(sql);
    rs.close();
    stmt.close();
    conn.close();
       } 
   }catch(SQLException e) {
}

%>
     <tr height="1" bgcolor="#dddddd"><td colspan="4" width="407"></td></tr>
     <tr height="1" bgcolor="#F2CB61"><td colspan="4" width="407"></td></tr>
     <div class="mtop-20"></div>
     <tr align="center">
      <td width="0">&nbsp;</td>
		<td colspan="2">
		<div class="form-submit" onclick="javascript:location.href='list.jsp'">목록</div>
    	</td>
    <td width="0">&nbsp;</td>
     </tr>
    </table>
   </td>
  </tr>
 </table>
     <div class="mtop-30"></div>
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