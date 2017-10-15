<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

	int sum = 0;

	for(int i=1; i<=100; i++)
	{
		sum += i;
	}
	
	request.setAttribute("MYSUM",new Integer(sum));
	
	// page 이동
	
	RequestDispatcher rd = request.getRequestDispatcher("b12result.jsp?num=33");
	rd.forward(request, response);

%>