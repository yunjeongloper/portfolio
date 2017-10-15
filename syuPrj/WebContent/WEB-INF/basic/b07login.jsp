<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

admin,	1111,	관리자라고 가정 <br>
test,	1111,	테스터라고 가정 <br>

<%
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	String msg;
	
	if( id.equals("admin") && pass.equals("1111"))
	{
		session.setAttribute("sessId", id);
		session.setAttribute("sessName", "관리자");
		msg = "관리자님 반갑습니다.";

	} else if( id.equals("test") && pass.equals("1111"))
	{
		session.setAttribute("sessId", id);
		session.setAttribute("sessName", "테스터");
		msg = "테스터님 반갑습니다.";
	} else
	{
		msg = "아이디와 비밀번호를 확인하세요.";
	}

%>

<script>
	alert('<%=msg %>');
	location.href='b06printLogin.jsp';
</script>

</body>
</html>