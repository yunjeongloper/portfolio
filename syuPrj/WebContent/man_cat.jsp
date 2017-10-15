<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>man_cat.jsp</title>
</head>
<body>
	<c:if test="${sessionScope.sessLevel lt 9 or empty sessionScope.sessLevel  }">
		<script>
			alert('잘못된 접근입니다.');
			location.href='main.jsp';
		</script>
	</c:if>


	분류 관리<br>
	
	<table border=1 width=90%>
		<tr height=30>
			<td width=25%>분류코드</td>
			<td width=25%>분류명</td>
			<td width=25%>사용</td>
			<td width=25%>비고</td>
		</tr>
		<form name=cForm method=post action='catInsert.jsp'>
		<tr height=30>
			<td width=25%><input type=text name=code required></td>
			<td width=25%><input type=text name=name required></td>
			<td width=25%>
				<input type=radio name=useflag value='1' checked>Y  
				<input type=radio name=useflag value='0'>N
			</td>
			<td width=25%><input type=submit value='등록'></td>
		</tr>
		</form>
		
		<jsp:include page="catGetList.jsp"></jsp:include>
		
		
		<script>
			function deleteConfirm(pidx)
			{
				if(confirm('정말 삭제하시겠습니까?'))
				{
					location.href='catDelete.jsp?idx='+pidx;	
				}
				
			}
		</script>
		
		<c:forEach var="i" begin="0" end="${catSize -1 }">
		
			<form name=cForm method=post action='catUpdate.jsp?idx=${catIdxList[i] }'>
			<tr height=30>
				<td width=25%><input type=text name=code value="${catCodeList[i] }" required></td>
				<td width=25%><input type=text name=name value="${catNameList[i] }" required></td>
				<td width=25%>
				
					<c:if test="${catUseList[i] eq 1 }">
						<input type=radio name=useflag value='1' checked>Y  
						<input type=radio name=useflag value='0'>N
					</c:if>
					<c:if test="${catUseList[i] ne 1 }">
						<input type=radio name=useflag value='1' >Y  
						<input type=radio name=useflag value='0' checked>N
					</c:if>
					
				</td>
				<td width=25%>
					<input type=submit value='변경'> 
					<input type=button value='삭제' onClick="deleteConfirm(${catIdxList[i]})">
				</td>
			</tr>
			</form>
		
		
		</c:forEach>
		
	</table>

	
	
	
	
	
	
	
	
	
	

</body>
</html>