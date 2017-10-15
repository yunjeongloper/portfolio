<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2>Input Test</h2>
	
	<form action="b14result.jsp">
		ID <input type=text name=id value='yourid'><br>
		PW <input type=password name=pass><br>
		GENDER <input type=radio name=gender value=female checked> F &nbsp;
			   <input type=radio name=gender value=male> M <br>
		NATION <select name=nation>
				<option value=''>=== 선택하세요 ===</option>
				<option value='kor' selected>KOREA</option>
				<option value='jpn'>JAPAN</option>
				<option value='usa'>USA</option>
			   </select> <br>
		HOBBY <input type=checkbox name=reading> READING
			  <input type=checkbox name=gaming> GAMING
			  <input type=checkbox name=sleeping checked> SLEEPING <br>
		MEMO <textarea name=memo style="width:400px; height:250px; line-height:180%">
원본 데이터는 여기에
쓰면 되려나
가
나
다
			  </textarea><br>
		<input type=submit value="확인">			  
	</form>

</body>
</html>