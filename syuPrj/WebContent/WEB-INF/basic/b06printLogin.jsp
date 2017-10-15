<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

b06printLogin.jsp <br>

<script>

	function checkError()
	{
		// document.loginForm.id.value 대신 아래와 같은 방법을 사용함
		
		var f = document.loginForm;
		
		if(f.id.value.length<4)
		{
			alert("아이디는 4자 이상입니다.");
			f.id.focus();
			return false;
		}

		if(f.pass.value.length<4)
		{
			alert("비밀번호는 4자 이상입니다.");
			f.pass.focus();
			return false;
		}		
	}

</script>

세션 정보를 읽어오기 <br>
<%
	String myId = (String)session.getAttribute("sessId");
	String myName = (String)session.getAttribute("sessName");

%>

id = <%=myId %><br>
name = <%=myName %><br>

<%
	if(myId != null && myName != null)
	{
%>
		<%=myId %>님 반갑습니다. <input type=button value="Exit" onClick="location.href='b08logout.jsp'">
<%
	} else
	{
%>	
		<form name="loginForm" method="post" action="b07login.jsp" onSubmit="return checkError()">
			ID <input type="text" name="id"> <br>
			PW <input type="text" name="pass"><br>
			<input type="submit" value="로그인">
		</form>
<%
	}
%>



</body>
</html>