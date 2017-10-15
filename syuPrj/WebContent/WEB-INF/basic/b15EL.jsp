<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2> Expression Language </h2>
	
	EL에 사용되는 연산자 <br>
	
	1. 산술 연산자 : +, -, *, /, %(modular), mod, div <br>
	
	2. 비교 연산자 : &lt; (less than), &gt;(greater than), < > <= >= == !=<br>
				lt, gt, ge, le, eq, ne (shell script?)
	
	3. 논리 연산자 : && ||(pipe*2) !, and or not <br>
	
	4. Empty 연산자 : empty <br>
	
	5. [] 첨자 연산자, dot 연산자 : [ ] - array, . - member <br>
	
	6. () 괄호 연산자 : 우선순위를 정할 때  <br>
	
	7. 3항 연산자 : ? <br>
	
	안녕하세요, ${empty param.id? "손님" : param.id } 님

</body>
</html>