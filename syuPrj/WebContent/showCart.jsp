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
	장바구니 보기 페이지<br>
	
	정보를 수집해 오고... <br>
	<jsp:include page="getCart.jsp"></jsp:include>
	
	화면에 리스트를 출력 : ${cartSize }
	
	<c:if test="${cartSize gt 0 }">
		<table border=1 width=90%>
			<tr>
				<td>순서</td>
				<td>사진</td>
				<td>제품</td>
				<td>가격</td>
				<td>색상</td>
				<td>사이즈</td>
				<td>수량</td>
				<td>합계</td>
				<td>비고</td>
			</tr>
			
			<c:forEach var="i" begin="0" end="${cartSize-1 }">
				<tr>
					<td>${i+1 }</td>
					<td><img src='upload/1/${cartFileList[i] }'></td>
					<td>${cartTitleList[i] }</td>
					<td>${cartPriceList[i] }</td>
					<td>${cartColorList[i] }</td>
					<td>${cartSizeList[i] }</td>
					<td>${cartCntList[i] }</td>
					<td>${cartPriceList[i] * cartCntList[i]}</td>
					<td><input type=button value="삭제"></td>
				</tr>
			</c:forEach>
			
			<tr>
				<td colspan=6>합계</td>
				<td>${cntTotal }</td>	
				<td>${priceTotal }</td>	
				<td></td>	
			</tr>		
		</table>
	</c:if>
	
	<c:if test="${cartSize eq 0 or empty cartSize }">
		장바구니가 비었다.
	</c:if>
	
	<input type=button value="쇼핑계속" onClick="location.href='main.jsp'">
	<input type=button value="주문하기" onClick="location.href='main.jsp?cmd=getInputOrder.jsp'">
	
</body>
</html>