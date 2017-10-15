<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	c09jstl.jsp<br>
	JSTL = JSP Standard Tag Library<br>
	http://archive.apache.org/dist/jakarta/taglibs/standard/binaries/ <br><br>
	
	custom action 예 <br>
	<c:set var="num1" value="5" />
	<c:set var="num2" value="7" />
	
	<c:set var="result" value="${num1*num2 }" />
	${num1 } * ${num2 } = ${result } or ${num1 * num2 } <br>
	
	큰 값을 찾아봅시다. <br>
	
	<c:if test="${num1 ge num2 }">
		큰 값은 ${num1 }입니다.
	</c:if>
	<c:if test="${num1 le num2 }">
		큰 값은 ${num2 }입니다.
	</c:if>
	
	
</body>
</html>