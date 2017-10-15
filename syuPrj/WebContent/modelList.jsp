<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>제품 목록 보기</h2>

<%
	String cat = request.getParameter("cat");
	out.print("cat = "+cat);
%>

<jsp:include page="modelGetList.jsp?cat=<%=cat %>"></jsp:include>

	확인 : ${modelSize }
	
	<c:if test="${modelSize ge 1 }">
		<table border=1 width=90%>
			<c:forEach var="i" begin="0" end="${modelSize-1 }">
				<c:if test="${i mod 3 eq 0 }">
					<tr height=250>
				</c:if>
				<td>
					<a href="main.jsp?cmd=modelDetail.jsp?idx=${modelIdxList[i] }&cat=${param.cat }"><img class=listImg src="upload/2/${modelFile1List[i] }"></a><br>
					${modelTitleList[i] }<br>
					가격 : 
					<b><fmt:formatNumber value="${modelPriceList[i] }" groupingUsed="true" /></b>
				</td>
			</c:forEach>
		</table>
	</c:if>

</body>
</html>