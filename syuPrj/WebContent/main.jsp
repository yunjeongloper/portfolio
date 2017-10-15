<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
   request.setCharacterEncoding("utf-8");
   response.setContentType("text/html; charset=utf-8");
   
   String cmd = request.getParameter("cmd");
   // main.jsp?cmd=login.jsp
   // main.jsp
   
   if(cmd == null)
      cmd="intro.html";
   
   request.setAttribute("cmd", cmd);
   
   String sessID = (String)session.getAttribute("sessID");
   String sessName = (String)session.getAttribute("sessName");
   //int tmpLevel = (Integer)session.getAttribute("sessLevel");
   int sessLevel = (Integer)session.getAttribute("sessLevel");

%>   


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>삼육 쇼핑몰</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

   <table border=1 width=1000>
      <tr height=100>
         <td width=150><a href='main.jsp'>홈</a></td>
         <td colspan=2>
			<a href="main.jsp?cmd=showCart.jsp">장바구니</a>
			<a href="main.jsp?cmd=manOrder.jsp">주문관리</a>
		</td>
      </tr>
      
      <tr height=500>
         <td valign=top>   
            <jsp:include page="catGetList.jsp"></jsp:include>
         
         
         
            <c:set var="sessID" value="${sessionScope.sessID }" />
            <c:if test="${sessID ne null}">
               ${sessionScope.sessName } 
               <input type=button value='로그아웃' onClick="location.href='logout.jsp'">
               
               <br>
               <hr>
                  <a href='main.jsp?cmd=man_cat.jsp'>분류관리</a> <br>
                  <a href='main.jsp?cmd=man_model.jsp'>제품 등록</a> <br>
                	  주문관리 <br>
               <hr>
               
            </c:if>
            <c:if test="${sessID eq null}">
               <jsp:include page="printLogin.jsp"></jsp:include>
            </c:if>
            
            <hr>
            <table border="1" width=90%>
               <c:if test="${catSize gt 0 }">
                  <c:forEach var="i" begin="0" end="${catSize -1 }">
                     <c:if test="${catCodeList[i] % 10 eq 0 }">
                        <tr height=30 bgcolor='#ABCDEF'>
                           <td>${catNameList[i] }</td>
                        </tr>
                        
                        <tr>
                           
                        </tr>
                        
                     </c:if>
                     
                     <c:if test="${catCodeList[i] % 10 ne 0 }">
                        <tr height=30>
                           <td><a href='main.jsp?cmd=modelList.jsp?cat=${catIdxList[i] }'>${catNameList[i] }</a></td>
                        </tr>
                     </c:if>
                     
                  </c:forEach>
               </c:if>
            </table>
            <hr>
            
         </td>
         <td valign=top width=750 align=center>
         	<center>
            <jsp:include page="${cmd }"></jsp:include>
         	</center>
         </td>
         <td width=100>배너</td>
      </tr>
      
      <tr height=70>
         <td colspan=3>사이트 정보</td>
      </tr>
      
   </table>



</body>
</html>