<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<!-- 
create table users (
	idx		int(10)		auto_increment,
	id		char(20)	unique,
	name	char(20),
	age		int(3)		default '10',
	dept	char(30),
	tel		char(15),
	primary key(idx)
);
 -->
 
<script>
	function checkError()
	{
		var f = document.uForm;
		
		var regEx;
		
		regEx = /^[a-z0-9]{4,10}$/;
		if( !regEx.test(f.id.value) )
		{
			alert('아이디는 소문자와 숫자로 4~10글자입니다');
			f.id.focus();
			return false;
		}
		
		regEx = /^01[016789]-\d{4}-\d{4}$/;
		if( !regEx.test(f.tel.value) )
		{
			alert('전화번호는 010-1234-5678 형식입니다.');
			f.tel.focus();
			return false;
		}
		
	}
</script>

<a href='http://www.syu.ac.kr'>삼육대학교</a><br>
 
<form name=uForm method=post action="d06insert.jsp" onSubmit="return checkError()">

<c:if test="${empty itemIdx }">
	<form name=uForm method=post action="d06insert.jsp" onSubmit="return checkError()">
</c:if>

<c:if test="${!empty itemIdx }">
	<form name=uForm method=post action="d10update.jsp" onSubmit="return checkError()">
	<input type=hidden name=idx value=${itemIDx }>
</c:if>

	<table border=1>
		<tr>
			<td colspan="4"> 
				<c:if test="${empty itemIdx }">등록</c:if>
				<c:if test="${!empty itemIdx }">수정</c:if>
			</td>
		</tr>
		<tr>
			<td>아이디</td>
			<td><input type=text name=id class=input value="${itemId }"></td>
			<td>이름</td>
			<td><input type=text name=name class=input value="${itemName }"></td>
		</tr>
		<tr>
			<td>나이</td>
			<td>
				<select name=age>
					<c:forEach var="i" begin="1" end="99">
						<c:if test="${itemAge eq i }">
							<option value="${i }" selected> ${i }</option>
						</c:if>
						<c:if test="${itemAge ne i }">
							<option value="${i }"> ${i }</option>
						</c:if>
					</c:forEach>
				</select>
			</td>
			<td>학과</td>
			<td><input type=text name=dept class=input value="${itemDept }"></td>
		</tr>
		<tr>
			<td>전화</td>
			<td><input type=text name=tel class=input value="${itemTel }"></td>
			<td colspan="2">	
				<c:if test="${empty itemIdx }">
					<input type=submit value="등록">	
				</c:if>		
				<c:if test="${!empty itemIdx }">
					<input type=submit value="수정">	
				</c:if>		
			</td>
		</tr>
	
	</table>
</form>

<jsp:include page="d07getlist.jsp"></jsp:include>
	
	list size = ${listSize }<br>
	
	<c:if test="${listSize gt 0 }">
	
		<script>
			function confirmDelete(pidx)
			{
				if(confirm('복구 불가능합니다.\n\n정말 삭제할래?'))
				{
					location.href='d08delete.jsp?idx='+pidx;
				}
			}		
			function gotoUrl(pidx)
			{
				location.href='d09getItem.jsp?idx='+pidx;
			}		
		</script>
		
		<table border=1>
			<tr height=30>
				<td>idx</td>
				<td>아이디</td>
				<td>이름</td>
				<td>나이</td>
				<td>부서</td>
				<td>전화번호</td>
				<td>비고</td>
			</tr>
			
			<c:forEach var="i" begin="0" end="${listSize-1 }">
				<tr height=30>
					<td>${idxList[i] }</td>
					<td>${idList[i] }</td>
					<td>${nameList[i] }</td>
					<td>${ageList[i] }</td>
					<td>${deptList[i] }</td>
					<td>${telList[i] }</td>
					<td>
						<input type=button name=upBtn onClick="gotoUrl(${idxList[i]})" value="수정">
						<input type=button name=delBtn onClick="confirmDelete(${idxList[i]})" value="삭제">
					</td>
				</tr>
			</c:forEach>
		</table>
	</c:if>
	

</body>
</html>