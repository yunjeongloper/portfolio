<%@ page contentType="text/html; charset=UTF-8"%>
    
<jsp:useBean id = "login" class = "ch07.loginBean" scope = "page" />
<jsp:setProperty name = "login" property="*" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<div style = "text-align:center;">
<h2>로그인 실행</h2>
<hr>
<%
	/* String userId = request.getParameter("userId");
	String userPw = request.getParameter("userPw");
	
	loginBean login = new loginBean();
	login.setUserId(userId);
	login.setUserPw(userPw); */
	
	if(!login.checkUser()){
		out.println("<h3>로그인 실패 TT<br></h3>");	
	} else {
		out.println("<h3>로그인 성공 ^^<br></h3>");
	}
%>

사용자 아이디 : <jsp:getProperty name = "login" property = "userId" /><br>
사용자 비밀번호 : 비밀
</div>

</body>
</html>