<%@ page contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<script>
</script>

<div  style="height:350px;
    text-align: center;
    position: relative;
    top: 60%;
    -ms-transform: translateY(-50%);
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);">
    
<h2>LOGIN</h2>

<hr>

<form id="loginFrm" action="isUser.do" method="post">
	<table>
		<tr>
			<td><input id="uid" name="uid" type="text" placeholder="아이디"></td>
		</tr>
		<tr>
			<td><input id="upass" name="upass" type="text" placeholder="패스워드"></td>
		</tr>
		<tr>
			<td>
				<input type="button" value="ID/PW 찾기" onclick="pageSubmit('toFindIdPw.do')"/>
				<input type="button" value="회원가입하기" onclick="pageSubmit('signUp.do')"/>
				<input type="submit" value="로그인">
			</td>
		</tr>
	</table>
</form>
</div>



