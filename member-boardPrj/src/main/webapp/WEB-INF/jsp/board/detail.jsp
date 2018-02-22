<%--
  Created by IntelliJ IDEA.
  User: myhoem
  Date: 2017-12-18
  Time: 오전 3:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<title>게시판 상세</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="/resources/css/common.css" rel="stylesheet" type="text/css">
<style type="text/css">
#deleteBtn {
  border-width:0px;
  width:100px;
  height:25px;
  background:inherit;
  background-color:rgba(255, 0, 0, 1);
  border:none;
  border-radius:5.66667175292969px;
  -moz-box-shadow:none;
  -webkit-box-shadow:none;
  box-shadow:none;
  font-family:'AppleSDGothicNeo-Bold', 'Apple SD Gothic Neo Bold', 'Apple SD Gothic Neo';
  font-weight:700;
  font-style:normal;
  font-size:14px;
  text-align: center;
  vertical-align: middle;
  color:#FFFFFF;
  cursor: pointer;
  float: left;
  padding-top: 2px;
}
#deleteBtn:hover {
  border-width:0px;
  width:100px;
  height:25px;
  background:inherit;
  background-color:rgba(255, 51, 153, 1);
  border:none;
  border-radius:5.66667175292969px;
  -moz-box-shadow:none;
  -webkit-box-shadow:none;
  box-shadow:none;
  font-family:'AppleSDGothicNeo-Bold', 'Apple SD Gothic Neo Bold', 'Apple SD Gothic Neo';
  font-weight:700;
  font-style:normal;
  font-size:14px;
  color:#FFFFFF;
  cursor: pointer;
  float: left;
}

#acceptBtn {
	border-width:0px;
	width:100px;
	height:25px;
	background:inherit;
	background-color:rgba(0, 147, 0, 1);
	border:none;
	border-radius:5.66667175292969px;
	-moz-box-shadow:none;
	-webkit-box-shadow:none;
	box-shadow:none;
	font-family:'AppleSDGothicNeo-Bold', 'Apple SD Gothic Neo Bold', 'Apple SD Gothic Neo';
	font-weight:700;
	font-style:normal;
	font-size:14px;
	text-align: center;
	vertical-align: middle;
	color:#FFFFFF;
	cursor: pointer;
	float: left;
	padding-top: 2px;
}
#acceptBtn:hover {
	border-width:0px;
	width:100px;
	height:25px;
	background:inherit;
	background-color:rgba(11, 201, 4, 1);
	border:none;
	border-radius:5.66667175292969px;
	-moz-box-shadow:none;
	-webkit-box-shadow:none;
	box-shadow:none;
	font-family:'AppleSDGothicNeo-Bold', 'Apple SD Gothic Neo Bold', 'Apple SD Gothic Neo';
	font-weight:700;
	font-style:normal;
	font-size:14px;
	color:#FFFFFF;
	cursor: pointer;
	float: left;
}
#btn {
  font-family:'AppleSDGothicNeo-Bold', 'Apple SD Gothic Neo Bold', 'Apple SD Gothic Neo';
  font-style:normal;
  font-size:14px;
  color: #0099FF;  
  float: right;
  padding-left: 10px;
  padding-top: 2px;
}
</style>

	<script type="text/javascript">
      function fileDownload(no){
        $('#fileNum').val(no);

        var f = document.myForm;
        var url = '/board/fileDownload.do';
        f.action = url;
        f.submit();
      }
	</script>
</head>
<body class="center-body">
<form name="myForm">
	<input type="hidden" id="fileNum" name="fileNum">
	<div style="width: 900px; padding-top: 20px;">
		<div style="border-bottom: 1px solid; height: 50px;">
			<div style="float: left; width: 300px;">
				<p style="font-size: 24pt">게시판 상세</p>
			</div>
			<div style="float: right; width: 200px;">
				<span style="float: right; margin-left: 10px;">${userId}</span>
				<span style="float: right"><a href="/logout.do">로그아웃</a></span>
			</div>
		</div>
		<div style="width: 780px; margin-top: 10px; margin-left: 60px">
			<div style="height: 55px; border-bottom: 1px solid #bbb;">
				<div style="float: left; padding-top: 20px; font-size: 14pt;">${boardDetail.subject}</div>
				<div style="float: right; padding-top: 20px; font-size: 11pt;">작성자 : ${boardDetail.name}</div>
			</div>
			<!-- 첨부파일영역 -->
			<div style="height: 88px; border-bottom: 1px solid #bbb; padding-top: 5px;">
				<table style="width: 100%; font-size: 10pt;">
					<c:if test="${fileList.size() > 0}">
						<c:forEach var="item" items="${fileList}" varStatus="1">
							<tr height="20">
								<td> <a onclick="javascript:fileDownload('${item.no}')"><p>${item.originName}</p></a></td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${fileList.size() < 1}">
						<tr>
							첨부파일이 없습니다.
						</tr>
					</c:if>
				</table>
			</div>
			<!-- 본문영역 -->
			<div style="border-bottom: 1px solid #bbb; padding-top: 20px; padding-bottom: 20px;">

			${boardDetail.content}

			</div>
			
			<div style="height: 50px; padding-top: 10px;">
				<div style="float: left;">조회수 : ${boardDetail.count} <br/> 등록날짜 : <fmt:formatDate value="${boardDetail.write_date}" pattern="YYYY-MM-DD"></fmt:formatDate></div>
				<div style="float: right;">
				
				<input type="hidden" name="page" value="${page}"/>
				<input type="hidden" name="searchType" value="${searchType}"/>
				<input type="hidden" name="searchData" value="${searchData}"/>
				
					<c:if test="${memberNo==boardDetail.writer}"><div id="deleteBtn" onclick="deleteGo(${boardDetail.no});">삭제하기</div></c:if>
						<script type="text/javascript">
							function deleteGo(num){
								
								var page = document.myForm.page.value;
								var searchType = document.myForm.searchType.value;
								var searchData = document.myForm.searchData.value;
								
								if (confirm("삭제하시겠습니까?")) {
									location.href = "/board/delete.do?no="+num+"&page="+page+"&searchType="+searchType+"&searchData="+searchData;
								}
							}
						</script>
					<c:if test="${replyOk eq '200'}">
					<div id="acceptBtn" onclick="replyGo(${boardDetail.no});">답글쓰기</div>
						<script type="text/javascript">
						  function replyGo(num){
						    location.href = "/board/create.do?boardNum="+num;
						  }
						</script>
					</c:if>

					<c:if test="${memberNo==boardDetail.writer}"><div id="acceptBtn" onclick="modifyGo(${boardDetail.no});">수정하기</div></c:if>
					<script type="text/javascript">
                      function modifyGo(num){
                        location.href = "/board/modify.do?boardNum="+num;
                      }
					</script>

					<div id="acceptBtn" onclick="listGo();">목록보기</div>
					<script type="text/javascript">
                      function listGo(){
                        location.href = "/board/list.do"
                      }
					</script>
				</div>
			</div>
</form>
			<!-- 댓글영역 -->
			<div>
				<jsp:include page="/WEB-INF/jsp/board/reply.jsp" flush="false">
					<jsp:param value="${boardDetail.no}" name="boardNum"/>
				</jsp:include>
				<!-- <span style="float: left">1 댓글</span> -->
			</div>
		</div>
	</div>
</body>
<script src="/resources/js/jquery-3.2.1.min.js"></script>
</html>
