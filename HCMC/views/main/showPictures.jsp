<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:requestEncoding value="UTF-8" />

<h4>사진보기</h4>

<c:forEach var="i" begin="1" end="10">

<%-- 	<c:if test="${i mod 3 eq 0 }">
		<tr height=250>
	</c:if> --%>
	
	<img src="${i}.jpg" height=150 width=150>
	
</c:forEach>
