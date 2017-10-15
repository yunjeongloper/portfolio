<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2> DB Connection Pool 확인 </h2>
	
	<sql:query var="rs" dataSource="jdbc/syudb_pool">
		select idx, id, name, tel from users
	</sql:query>
	
	<h3> DB 검색결과 </h3>
	
	<c:forEach var="row" items="${rs.rows }">
		IDX: ${row.idx }, NAME: ${row.name }, TEL: ${row.tel } <br>
	</c:forEach>

</body>
</html>