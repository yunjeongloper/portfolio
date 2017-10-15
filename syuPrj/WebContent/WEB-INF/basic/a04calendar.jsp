<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

1 ~ 100 까지의 합 구하기 <br>

<%
	int sum = 0;

	for( int i=1; i<=100; i++)
	{
		sum = sum + i;
	}
	
	out.println("sum = " + sum + "<br>");

%>

	<form method=post action="Add100">
		<input type=submit value="1000까지 합구하기">
	</form>

</body>
</html>