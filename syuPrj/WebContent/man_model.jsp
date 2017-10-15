<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>man_model.jsp</title>
</head>
<body>
	<c:if test="${sessionScope.sessLevel lt 9 or empty sessionScope.sessLevel  }">
		<script>
			alert('잘못된 접근입니다.');
			location.href='main.jsp';
		</script>
	</c:if>

	<h2> 제품 등록하기 </h2>

	<script>
		function checkError()
		{
			var f = document.mForm;
			
			if(f.cat.value == '0')
			{
				alert('카테고리를 선택하세요');
				f.cat.focus();
				return false;
			}
		}
	
	</script>


	<form method=post name=mForm enctype="multipart/form-data" action='modelInsert.jsp' onSubmit="return checkError()">
	<table border=1 width=90%>
		<tr height=30>
			<td colspan=4>제품 등록</td>
		</tr>
		
		<tr height=25>
			<td width=20%>제품명</td>
			<td width=30%><input type=text name=title required class=inputModel></td>
			<td width=20%>모델명</td>
			<td width=30%><input type=text name=model class=inputModel></td>
		</tr>
		
		<tr height=25>
			<td width=20%>카테고리</td>
			<td width=30%>
				<select name=cat class=inputModel>
					<option value='0'>=== 선택하세요 ===</option>
					<c:if test="${catSize gt 0 }">
						<c:forEach var="i" begin="0" end="${catSize -1 }">
							<c:if test="${catCodeList[i] % 10 eq 0 }">
								<option value='0'>${catNameList[i]}</option>
							</c:if>
							<c:if test="${catCodeList[i] % 10 ne 0 }">
								<option value='${catIdxList[i] }'>${catNameList[i]}</option>
							</c:if>
						</c:forEach>
					</c:if>			
					
				</select>
			</td>
			<td width=20%>가격</td>
			<td width=30%><input type=text name=price class=inputModel></td>
		</tr>
		
		<tr height=25>
			<td width=20%>사용</td>
			<td width=30%>
				<select name=useflag class=inputModel>
					<option value='1' selected>사용</option>
					<option value='0'>-----</option>			
				</select>
			</td>
			<td width=20%></td>
			<td width=30%></td>
		</tr>
	
		<tr height=25>
			<td width=20%>사이즈</td>
			<td width=30%><input type=text name=size class=inputModel></td>
			<td width=20%>색상</td>
			<td width=30%><input type=text name=color class=inputModel></td>
		</tr>
		
		<tr height=25>
			<td width=20%>대표사진</td>
			<td colspan=3><input type=file name=upfile1 class=inputModel></td>
		</tr>
		<tr height=25>
			<td width=20%>설명사진</td>
			<td colspan=3><input type=file name=upfile2 class=inputModel></td>
		</tr>
		
		<tr height=30>
			<td colspan=4><input type=submit value='등록'></td>
		</tr>
	</table>

	</form>

</body>
</html>