<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	1. sum = <%=request.getAttribute("MYSUM") %> <br>
	
	2. Expression Language : ${MYSUM } <br>
	
	3. EL2 = ${MYSUM + 11} <br>
	      원칙 MYSUM = ${requestScope.MYSUM } <br>
	      
	4. param num = ${num }, ${param.num } <br>

</body>
</html>