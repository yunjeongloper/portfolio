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

	<jsp:include page="modelGetDetail.jsp"></jsp:include>

	<h2>제품 상세 보기</h2>
	
	<script>
		function recalculatePrice()
		{
			var f = document.mform;
			var price = ${price};
			var cnt = f.count.value;
			var total = price * cnt;
			
			f.totalPrice.value=total;
			
			if(total == 0)
			{
				f.submit.disabled=true;
			} else
			{
				f.submit.disabled=false;
			}
		}
		
		function checkError()
		{
			var f = document.mform;

			if(f.color.value=="빈값")
			{
				alert("색상을 선택하세요");
				f.color.focus();
				return false;
			}
			
			if(f.size.value=="빈값")
			{
				alert("사이즈를 선택하세요");
				f.size.focus();
				return false;
			}
			
			if(f.count.value=="0")
			{
				alert("수량을 선택하세요");
				f.count.focus();
				return false;
			}
		}
	
	</script>
	
	<%
		String ip = request.getRemoteAddr();
	%>
	
	ip = <%=ip %>

	<table border=1 width=90%>
		<form name=mform method=post action="putCart.jsp" onSubmit="return checkError()">
		<input type=hidden name=midx value='${idx }'>
		<input type=hidden name=price value='${price }'>
		
		<tr height=250>
			<td width=40%>
				<img src="upload/2/${file1 }" style='cursor:pointer;' onClick="javascript:window.open('upload/3/${file1 }','PHOTOWIN','resizable=yes scrollbars=yes width=800 height=600')"><br>
				◀이전		<a href=# onClick="javascript:window.open('upload/3/${file1 }','PHOTOWIN','resizable=yes scrollbars=yes width=800 height=600')">확대</a>		다음▶
			</td>
			<td width=10%>여백</td>
			<td width=50%>
				<table border=1 width=100%>
					<tr height=30>
						<td class=detailLeft>제품명</td>
						<td class=detailCenter></td>
						<td class=detailRight>${title }</td>
					</tr>					
					<tr height=30>
						<td class=detailLeft>색상</td>
						<td class=detailCenter></td>
						<td class=detailRight>
							<select name=color class='inputModel'>
								<option value="빈값">==선택==</option>
								<c:forTokens var="c" items="${color }" delims=",">
									<option value="${c }">${c }</option>
								</c:forTokens>
							</select>
						</td>
					</tr>			
					<tr height=30>
						<td class=detailLeft>사이즈</td>
						<td class=detailCenter></td>
						<td class=detailRight>
							<select name=size class='inputModel'>
								<option value="빈값">==선택==</option>		
								<c:forTokens var="s" items="${size }" delims=",">
									<option value="${s }">${s }</option>
								</c:forTokens>
							</select>
						</td>
					</tr>			
					<tr height=30>
						<td class=detailLeft>가격</td>
						<td class=detailCenter></td>
						<td class=detailRight><fmt:formatNumber value="${price }" groupingUsed="true" />	</td>
					</tr>			
					<tr height=30>
						<td class=detailLeft>수량</td>
						<td class=detailCenter></td>
						<td class=detailRight>
							<select name=count class='inputModel' onChange="recalculatePrice()">
								<option value="0">==선택==</option>
								<c:forEach var="i" begin="1" end="10">
								
									<c:if test='${i eq 1 }'>
										<option value="${i }" selected>${i }개</option>
									</c:if>
									<c:if test='${i ne 1 }'>
										<option value="${i }">${i }개</option>
									</c:if>
									
								</c:forEach>
							</select>
						</td>
					</tr>				
					<tr height=30>
						<td class=detailLeft>합계</td>
						<td class=detailCenter></td>
						<td class=detailRight>
							<input type=text name=totalPrice class=totalPrice readonly value='${price }'>
						</td>
					</tr>			
				
				</table>
			</td>
		</tr>	
		
		<tr>
			<td></td>
			<td></td>
			<td>
				<input type="submit" name="submit" value="장바구니">
				<input type="button" value="구매하기">
			</td>
		</tr>	
		</form>
		<tr>
			<td colspan=3>
				설명사진
			</td>
		</tr>	
	
	
	</table>
	
</body>
</html>
