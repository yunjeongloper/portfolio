<%--
  Created by IntelliJ IDEA.
  User: myhoem
  Date: 2017-12-18
  Time: 오전 3:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>게시물 목록</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="/resources/css/common.css" rel="stylesheet" type="text/css">
    <script src="/resources/js/jquery-3.2.1.min.js"></script>
    <script type="text/javascript">
      $(document).ready(function () {

        var searchType = $("#searchType option:selected").val();

        if (searchType == 'state') {
          $("#searchState").show();
          $("#searchValue").hide();
        } else {
          $("#searchState").hide();
          $("#searchValue").show();
        }

        $("#searchType").change(function () {
          if ($("#searchType option:selected").val() == 'state') {
            $("#searchState").show();
            $("#searchValue").hide();
          } else {
            $("#searchState").hide();
            $("#searchValue").show();
          }
        });
      });

      function fnSubmitForm(page) {
        document.memberListForm.page.value = page;
        document.memberListForm.submit();
      }

      function unlockID() {
        var no = new Array();
        $("input[type='checkbox']:checked").each(function (index) {
          no[index] = $(this).val();
          $(location).attr('href', 'modify.do?no=' + no);
        });
      }

      function search() {
        var searchType = $("#searchType option:selected").val();
        var data;
        if (searchType === "state") {
          data = $("#searchState").val();
        } else {
          data = $("#searchValue").val();
        }
        $(location).attr('href', 'search.do?val=' + searchType + '&data=' + encodeURI(
            encodeURIComponent(data)));
      }

    </script>
</head>
<body class="center-body">
<div style="width: 900px; padding-top: 10px;">
    <div style="border-bottom: 1px solid; height: 50px;">
        <div style="float: left; width: 300px;">
            <a href="/admin.do"><p style="font-size: 24pt">관리자페이지</p></a>
        </div>

        <div style="float: right;"><a href="/board/list.do">게시판으로 이동</a></div>
    </div>

    <form action="" name="memberListForm" method="post">

        <div style="margin-top: 10; height: 30px;">
            <select style="height: 25px;" id="searchType" name="searchType">
                <option value="id" <c:if test="${searchType=='id'}">selcted</c:if>>아이디</option>
                <option value="name" <c:if test="${searchType=='name'}">selected</c:if>>이름</option>
                <option value="phone" <c:if test="${searchType=='phone'}">selected</c:if>>핸드폰번호
                </option>
                <option value="state" <c:if test="${searchType=='state'}">selected</c:if>>상태
                </option>
            </select>
            <select style="height: 25px;" id="searchState" name="searchState">
                <option value="N">N</option>
                <option value="Y">Y</option>
            </select>

            <input id="searchValue" name="searchValue" value="">
            <button type="button" class="btn btn-default btn-sm"
                    onclick="search()" style="">검색 <span
                    class="glyphicon glyphicon-search"></span>
            </button>
            <button style="float: right" id="create" type="button" onclick="unlockID()">잠금해제
            </button>
        </div>

        <table id="" width="100%" class="table table-striped" style="text-align: center">

            <tr>
                <td width="120">회원번호</td>
                <td>이름</td>
                <td>아이디</td>
                <td>핸드폰번호</td>
                <td>상태</td>
                <td>선택</td>
            </tr>

            <c:forEach items="${member}" var="m">
                <tr class="notice">
                    <td>${m.no}</td>
                    <td>${m.name}</td>
                    <td style="text-align: left">${m.id}</td>
                    <td>${m.phone}</td>
                    <td>${m.is_account_lock}</td>
                    <td><input type="checkbox" name="modify" value="${m.no}"></td>
                </tr>
            </c:forEach>

        </table>

        <c:if test="${pageUtil.totPage>1}">

            <ul class="pagination center-body">
                <li
                        class="page-item <c:if test="${pageUtil.page==1}">disabled</c:if>"
                        onclick="fnSubmitForm(1)"><a class="page-link " href="#"
                                                     aria-label="First"> <span aria-hidden="true"
                                                                               class="">&laquo;</span>
                    <span class="sr-only">First</span>
                </a></li>

                <li
                        class="page-item <c:if test="${pageUtil.page==1}">disabled</c:if>"
                        onclick="fnSubmitForm(${pageUtil.page-1})"><a
                        class="page-link " href="#" aria-label="Previous"> <span
                        aria-hidden="true">&lsaquo;</span> <span class="sr-only">Previous</span>
                </a></li>
                <c:forEach var="i" begin="${pageUtil.pageStart}"
                           end="${pageUtil.pageEnd}" step="1">
                    <c:choose>
                        <c:when test="${i eq pageUtil.page}">
                            <li class="paginate_button active"><a href="#"><c:out
                                    value="${i}"/></a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="paginate_button " onclick="fnSubmitForm(${i})"><a
                                    href="#"><c:out value="${i}"/></a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <li
                        class="page-item  <c:if test="${pageUtil.page==pageUtil.totPage}">disabled</c:if>"
                        onclick="fnSubmitForm(${pageUtil.page+1})"><a
                        class="page-link" href="#" aria-label="Next"> <span
                        aria-hidden="true">&rsaquo;</span> <span class="sr-only">Next</span>
                </a></li>
                <li
                        class="page-item  <c:if test="${pageUtil.page==pageUtil.totPage}">disabled</c:if>"
                        onclick="fnSubmitForm(${pageUtil.totPage})"><a
                        class="page-link" href="#" aria-label="End"> <span
                        aria-hidden="true">&raquo;</span> <span class="sr-only">End</span>
                </a></li>
            </ul>
        </c:if>
        <input type="hidden" name="page" value=""/>
    </form>
</div>
</body>
</html>
