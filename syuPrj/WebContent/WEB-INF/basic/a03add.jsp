<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JAVA/JSP의 전송방식비교2</title>
</head>
<body>

두 수를 더해 봅시다.<br>

<%
	String str1 = request.getParameter("num1");
	int num1 = Integer.parseInt(str1);
	
	int num2 = Integer.parseInt(request.getParameter("num2"));
	
	out.print(num1 + " + " + num2 + " = " + (num1 + num2) );
%>

<br>또 다른 방법으로 표기해 보겠습니다. <br>

<%=num1 %> + <%=num2 %> = <%=(num1+num2) %>


</body>
</html>