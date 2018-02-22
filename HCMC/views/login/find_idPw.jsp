<%@ page contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>

	<div id="findId">
		<div>아이디 찾기 (휴대폰 인증)</div>
		<div class="findGroup">
			<input class="phone" title="휴대폰" type="text" placeholder="휴대폰" name="tel"/>
	   		<button type="button" onClick="signUp.sendSMSMsg(this, 'findIdByPhone')">인증</button>
		</div>
	</div>
	<br>
	<div id="findPw">
		<div>비밀번호 찾기 (휴대폰 인증)</div>
		<div>
			<input class="userId" type="text" title="아이디" placeholder="아이디를 입력하세요">
		</div>
		<div class="findGroup">
			<input class="phone" title="휴대폰" type="text" placeholder="휴대폰번호"/>
			<button type="button" onClick="signUp.sendSMSMsg(this, 'findPwByPhone') ">인증</button>
		</div>
	</div>
	
	
	