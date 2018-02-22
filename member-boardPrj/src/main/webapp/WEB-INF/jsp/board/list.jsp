<%--
  Created by IntelliJ IDEA.
  User: myhoem
  Date: 2017-12-18
  Time: 오전 3:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>게시물 목록</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="/resources/css/common.css" rel="stylesheet" type="text/css">
</head>
<body class="center-body">
<div style="width: 900px;">
    <div style="border-bottom: 1px solid;height: 50px;">
        <div style="float: left;width: 300px;">
            <p style="font-size: 24pt">게시물 목록</p>
        </div>

        <%--------------------bin area--------------------%>

            <div style="float: right;width: 200px;">
                <c:if test="${authority eq 1}">
                    <span style="float: right; margin-left: 10px;"> <a href="/admin.do">관리자</a></span>
                </c:if>
                <span style="float: right; margin-left: 10px;">${userId}</span>
                <span style="float: right"><a href="/logout.do">로그아웃</a></span>
            </div>
        <%------------------------------------------------%>

    </div>
    <form action="/board/list.do" method="get" name="boardListTable">
        <div style="margin-top: 10;height: 30px;">
            <select style="float: left" id="searchType" name="searchType">
                <option value="1">제목</option>
                <option value="2">내용</option>
                <option value="3">작성자</option>
                <option value="4">제목+내용</option>
            </select>
            <input style="float: left" id="searchData" name="searchData" value="${searchData}">
            <button type="button" class="btn btn-default btn-sm" onclick="fnSubmitForm(1)"
                    style="float: left">
                검색 <span class="glyphicon glyphicon-search"></span>
            </button>
            <button style="float: right" id="create" type="button"
                    onclick="location.href='/board/create.do'">등록
            </button>
        </div>
        <table id="boardList" width="100%" class="table table-striped" style="text-align: center">
            <tr>
                <td width="100px">번호</td>
                <td>제목</td>
                <td width="150px">작성자</td>
                <td width="150px">등록일</td>
                <td width="100px">조회수</td>
            </tr>

            <c:forEach items="${noticeList}" var="notice">
                <tr class="notice">
                    <td>${notice.no}</td>
                    <td style="text-align: left">${notice.subject}</td>
                    <td>${notice.writer}</td>
                    <td><fmt:formatDate value="${notice.write_date}" pattern="yyyy-MM-dd" /></td>
                    <td>${notice.count}</td>
                </tr>
            </c:forEach>


            <c:forEach items="${boardList}" var="board">
<%--<<<<<<< HEAD--%>
            	<%--<c:choose>--%>
            	<%--<c:when test="${board.delete_ok==1 && board.cnt>=2 && board.parents_no==board.no}"><!-- 답글이 있는 경우 -->--%>
								<%--<tr><td colspan="5">삭제된 게시글 입니다.</td></tr>--%>
							<%--</c:when>--%>
							<%--<c:when test="${board.delete_ok==1}"><!-- 답글이 없거나 답글인 경우 -->--%>

							<%--</c:when>--%>
							<%--<c:otherwise>--%>
								<%--<tr>--%>
                    <%--<c:choose>--%>
                        <%--<c:when test="${board.parents_no ne board.no}">--%>
                            <%--<td></td>--%>
                        <%--</c:when>--%>
                        <%--<c:otherwise>--%>
                            <%--<td>${board.no}</td>--%>
                        <%--</c:otherwise>--%>
                    <%--</c:choose>--%>
<%--=======--%>
                <c:choose>
                    <c:when test="${board.delete_ok==1 && board.cnt>=2 && board.parents_no==board.no}"><!-- 답글이 있는 경우 -->
                        <tr>
                            <td colspan="5">삭제된 게시글 입니다.</td>
                        </tr>
                    </c:when>
                    <c:when test="${board.delete_ok==1}"><!-- 답글이 없거나 답글인 경우 -->
<%-->>>>>>> origin/new/bin-admin5--%>

                    </c:when>
                    <c:otherwise>
                        <tr>
                            <c:choose>
                                <c:when test="${board.parents_no ne board.no}">
                                    <td></td>
                                </c:when>
                                <c:otherwise>
                                    <td>${board.no}</td>
                                </c:otherwise>
                            </c:choose>

                            <c:choose>
                                <c:when test="${board.parents_no ne board.no}">
                                    <td style="padding-left: 20px;text-align: left">
                                        <a href="/board/detailView.do?boardNum=${board.no}&parentNum=${board.parents_no}&searchType=${searchType}&searchData=${searchData}&page=${page}"><i
                                                class="material-icons" style="font-size: 15px">&#xe5da;</i> ${board.subject}
                                        </a>
                                    </td>
                                </c:when>
                                <c:otherwise>
                                    <td style="text-align: left">
                                        <a href="/board/detailView.do?boardNum=${board.no}&parentNum=${board.parents_no}&searchType=${searchType}&searchData=${searchData}&page=${page}">${board.subject}</a>
                                    </td>
                                </c:otherwise>
                            </c:choose>

                            <td>${board.writer}</td>
                            <td><fmt:formatDate value="${board.write_date}" pattern="yyyy-MM-dd" /></td>
                            <td>${board.count}</td>
                        </tr>
                    </c:otherwise>
                </c:choose>

            </c:forEach>
        </table>

        <c:if test="${pageUtil.totPage>1}">

        <ul class="pagination center-body">
            <li class="page-item <c:if test="${pageUtil.page==1}">disabled</c:if>"
                onclick="fnSubmitForm(1)">
                <a class="page-link " href="#" aria-label="First">
                    <span aria-hidden="true" class="">&laquo;</span>
                    <span class="sr-only">First</span>
                </a>
            </li>

            <li class="page-item <c:if test="${pageUtil.page==1}">disabled</c:if>"
                onclick="fnSubmitForm(${pageUtil.page-1})">
                <a class="page-link " href="#" aria-label="Previous">
                    <span aria-hidden="true">&lsaquo;</span>
                    <span class="sr-only">Previous</span>
                </a>
            </li>
            <c:forEach var="i" begin="${pageUtil.pageStart}" end="${pageUtil.pageEnd}" step="1">
                <c:choose>
                    <c:when test="${i eq pageUtil.page}">
                        <li class="paginate_button active"><a href="#"><c:out value="${i}"/></a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="paginate_button " onclick="fnSubmitForm(${i})"><a href="#"><c:out
                                value="${i}"/></a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <li class="page-item  <c:if test="${pageUtil.page==pageUtil.totPage}">disabled</c:if>"
                onclick="fnSubmitForm(${pageUtil.page+1})">
                <a class="page-link" href="#" aria-label="Next">
                    <span aria-hidden="true">&rsaquo;</span>
                    <span class="sr-only">Next</span>
                </a>
            </li>
            <li class="page-item  <c:if test="${pageUtil.page==pageUtil.totPage}">disabled</c:if>"
                onclick="fnSubmitForm(${pageUtil.totPage})">
                <a class="page-link" href="#" aria-label="End">
                    <span aria-hidden="true">&raquo;</span>
                    <span class="sr-only">End</span>
                </a>
            </li>
        </ul>
        </c:if>
        <input type="hidden" name="page" id="page" value="" />
        <script type="text/javascript">
          function fnSubmitForm(page) {
            document.boardListTable.page.value = page;
            document.boardListTable.submit();
          }

        </script>
    </form>
</div>
<script src="/resources/js/jquery-3.2.1.min.js"></script>
<script>
    $(document).ready(function () {

        var searchType = '${searchType}';
        console.log(searchType);
      if(searchType == null || searchType=="") {
        $('#searchType').val(1);
      } else {
        $('#searchType').val(searchType);
      }
    });
</script>
</body>
</html>
