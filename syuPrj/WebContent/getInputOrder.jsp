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
	주문입력<br>
	
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
				</tr>
			</c:forEach>
			
			<tr>
				<td colspan=6>합계</td>
				<td>${cntTotal }</td>	
				<td>${priceTotal }</td>	
			</tr>		
		</table>
	</c:if>
	
	<c:if test="${cartSize eq 0 or empty cartSize }">
		장바구니가 비었다.
	</c:if>
	
	<script>
		function setSame()
		{
			var f = document.oForm;
			if(f.same.checked == true)
			{
				f.rname.value = f.oname.value;
				f.rtel.value = f.otel.value;
				f.rmobile.value = f.omobile.value;
				f.raddr.value = f.oaddr.value;
			}	
		}
		
		function checkError()
		{
			alert('TODO : 에러검사 통과되었다고 가정');
		}
	</script>
	
	<br><br>
	<form name=oForm method=post action='order.jsp' onSubmit="return checkError()">
	<table border=1 width=90%>
		<tr>
			<td colspan=4> 주문자 정보</td>		
		</tr>
		<tr>
			<td>이름</td>
			<td><input type=text name=oname value="${sessionScope.sessName }"></td>
			<td>아이디</td>
			<td><input type=text name=id readonly value="${sessionScope.sessID }"></td>
		</tr>
		<tr>
			<td>전화번호</td>
			<td><input type=text name=otel></td>
			<td>휴대전화</td>
			<td><input type=text name=omobile></td>
		</tr>
		<tr>
			<td>주소</td>
			<td colspan=3><input type=text name=oaddr></td>
		</tr>
			
		<tr>
			<td colspan=4> 수령인 정보 (<input type=checkbox name=same onClick="setSame()">주문자와 동일) </td>		
		</tr>
		<tr>
			<td>이름</td>
			<td><input type=text name=rname></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td>전화번호</td>
			<td><input type=text name=rtel></td>
			<td>휴대전화</td>
			<td><input type=text name=rmobile></td>
		</tr>
		<tr>
			<td>주소</td>
			<td colspan=3><input type=text name=raddr></td>
		</tr>
		<tr>
			<td>요청사항</td>
			<td colspan=3><textarea name=memo style='width:90%; height:100px; line-height:100%'></textarea></td>
		</tr>
		<tr>
			<td colspan=4><input type=submit value="주문실행"></td>
		</tr>
	</table>
	</form>
	
	create table order_table (
		idx		idx(10) 	auto_increment,
		id		char(20),
		
		oname	char(20),
		otel	char(20),
		omobile	char(20),
		oaddr	char(255),
		
		rname	char(20),
		rmobile	char(20),
		rtel	char(20),
		raddr	char(255),
		
		memo 	blob,
		
		status	int(3) defualt '1',
		-- 1 : 접수중
		-- 2 : 결제완료
		-- 3 : 배송준비중
		
		day		date,
		time	time,
		
		primary key(idx)		
	);
	
	create table item_table(
		idx		int(10)		auto_increment,
		oidx	int(10)		default '0',		
		midx 	int(10)		default '0',
		size	char(30),
		color	char(30),
		cnt		int(3)		default '0',
		price	int(10)		default '0',		
		primary key(kdx)
	);
	
	<br><br>
	
</body>
</html>