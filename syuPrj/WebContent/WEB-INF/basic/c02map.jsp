<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	
	HashMap<String, String> protocol = new HashMap<String, String>();
	protocol.put("TCP","Transmission Control Protocol");
	protocol.put("UDP","User Datagram Protocol");
	protocol.put("HTTP","Hyper Text Transfer Protocol");
	protocol.put("IP","Internet address Protocol");
	protocol.put("SMTP","Simple Mail Transfer Protocol");
	
	request.setAttribute("PROTOCOL",protocol);
	
	RequestDispatcher rd = request.getRequestDispatcher("c03protocol.jsp?key=HTTP");
	rd.forward(request, response);
	
%>