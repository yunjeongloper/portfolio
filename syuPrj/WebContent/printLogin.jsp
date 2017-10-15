<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<form name=loginForm method=post action='login.jsp'>
<table border=1 width=90%>
	<tr height=30>
		<td width=100%>
			<input type=text name=id required style='width:90%;' placeholder='아이디'>
		</td>	
	</tr>
	<tr height=30>
		<td width=100%>
			<input type=password name=pass required style='width:90%;' placeholder='비밀번호'>
		</td>	
	</tr>
	<tr height=30>
		<td width=100%>
			<input type=submit value='로그인'>
			<input type=button value='가입'>
		</td>	
	</tr>
</table>
</form>