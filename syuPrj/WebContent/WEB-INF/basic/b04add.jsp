<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

당신이 입력한 첫번째 값은 <%=request.getParameter("num1") %>입니다. <br>
당신이 입력한 두번째 값은 <%=request.getParameter("num2") %>입니다. <br>

내장객체(built-in object)를 이용한 redirect 하기<br>

<% response.sendRedirect("http://www.syu.ac.kr"); %>

</body>
</html>