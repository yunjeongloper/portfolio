<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name=viewport content="width=device-width, initial-scale=1, user-scalable=0"> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="css/core.css">
<link rel="stylesheet" href="css/core2.css" media="only screen and (min-width:800px)">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
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
		<form name=writeform method=post action="write_ok.jsp">
		<table class="table">
		<tbody>
	     <tr>
	       <th>제목</th>
	     <td><input type="text" placeholder="제목을 입력하세요. " name="title" class="form-control"/></td>
	     </tr>
	     <tr>
	       <th>이름</th>
	     <td><input type="text" placeholder="제목을 입력하세요. " name="name" class="form-control"/></td>
	       </tr>
	         <tr>
	         <th>비밀번호</th>
	         <td><input type="password" placeholder="비밀번호를 입력하세요" name="password" class="form-control"/></td>
	         </tr>
	        <tr>
	          <th>내용</th>
	          <td><textarea cols="35" rows="8" placeholder="내용을 입력하세요. " name="memo" class="form-control"></textarea></td>
	        </tr>
			<tr>
			<td colspan="2">
			<div class="form-write" onclick="javascript:location.href='list.jsp'">목록으로</div>
			<div class="form-write" onclick="javascript:writeCheck();">등록</div>
	        </td>
	        </tr>
		</tbody>
		</table>
		</form>
	</table>
</body>
</html>
<script src="js/jquery-1.12.0.min.js"></script>
<script src="js/core.js"></script>
<script language = "javascript"> // 자바 스크립트 시작
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
function writeCheck()
  {
   var form = document.writeform;
   
   if( !form.name.value )   // form 에 있는 name 값이 없을 때
   {
    alert( "이름을 적어주세요" ); // 경고창 띄움
    form.name.focus();   // form 에 있는 name 위치로 이동
    return;
   }
   
   if( !form.password.value )
   {
    alert( "비밀번호를 적어주세요" );
    form.password.focus();
    return;
   }
   
  if( !form.title.value )
   {
    alert( "제목을 적어주세요" );
    form.title.focus();
    return;
   }
 
  if( !form.memo.value )
   {
    alert( "내용을 적어주세요" );
    form.memo.focus();
    return;
   }
 
  form.submit();
  }
</script>


