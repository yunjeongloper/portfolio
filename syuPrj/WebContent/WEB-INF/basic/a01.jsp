<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>첫번째 JSP 파일입니다.</title>

<meta name="viewport"
	content="width=device-width, user-scaleable=yes,
			initial-scale=1.0, maximum-scale=3.0" />

</head>
<body>

<script>

	var xmlhttp;

	function testAjax()
	{
		var obj = document.getElementById('id');
		
		xmlhttp = getXmlHttpObject();
		if(xmlhttp == null)
		{
			alert("당신의 브라우저는 AJAX를 이용할 수 없습니다.");
			return;
		}
		
		var url = "ajaxServer.jsp?key="+obj.value;
		xmlhttp.onreadystatechange = myAjax;
		xmlhttp.open("POST",url,true);
		xmlhttp.send(null);

	}
	
	function myAjax()
	{
		if(xmlhttp.readyState == 4)
		{
			var result = document.getElementById('safeOrNot');
			result.innerHTML = xmlhttp.responseText;
		}
	}
	
	function getXmlHttpObject()
	{
		if(window.XMLHttpRequest)
			// 대부분은 여기서 걸림
			return new XMLHttpRequest();
		
		if(window.ActiveXObject)
			// 7보다 아래에 있는 익스플로러 버전 처리
			return new ActiveXObject("Microsoft.XMLHTTP");
		
		return null;
	}

</script>

아이디 <input type=text name=id id=id onKeyUp=testAjax()><br>
비밀번호 <input type=password name=pass><br>
<div id=safeOrNot>결과창</div>

첫번째
두번째

<%
	for(int i=1; i<=100; i++)
	{
		out.print(i+"<br>");
	}

%>

마지막
</body>
</html>