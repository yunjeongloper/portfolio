<%--
  Created by IntelliJ IDEA.
  User: myhoem
  Date: 2017-12-17
  Time: 오후 7:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인</title>
    <link href="/resources/css/bootstrap/bootstrap.min.css" rel="stylesheet" id="style_components"
          type="text/css">
    <link href="/resources/css/components-md.css" rel="stylesheet" id="style_components"
          type="text/css">
    <link href="/resources/css/common.css" rel="stylesheet" id="style_components" type="text/css">
</head>
<body>
<div class="center-body login">
    <div class="portlet box blue m-grid-col-center m-grid-col-md-3">
        <div class="portlet-title">
            <h3>Devunlimit 로그인</h3>
        </div>
        <div class="portlet-body">
            <form role="form" id="loginForm" action="/login.do" method="post">
                <div class="form-body">
                    <div class="form-group form-md-line-input form-md-floating-label">
                        <input type="text" class="form-control" name="id" id="userId">
                        <label for="userId">아이디</label>
                        <span class="help-block" id="help-id"></span>
                    </div>

                    <div class="form-group form-md-line-input form-md-floating-label">
                        <input type="password" class="form-control" name="pass" id="userPass">
                        <label for="userPass">비밀번호</label>
                        <span class="help-block" id="help-pwd">최대 20자까지 입니다.</span>
                    </div>
                </div>
                <div class="form-actions noborder">
                    <button type="button" class="btn blue btn-block" id="loginbtn"
                            onClick="javascript:formChk()">로그인
                    </button>
                </div>
                <div class="form-body" style="text-align: center"
                     onclick="window.location.href='signup.do'">
                    <br>아이디가 없으시면 회원가입을 해주세요!
                </div>
            </form>
        </div>
    </div>
</div>
<script src="/resources/js/jquery-3.2.1.min.js"></script>
<script src="/resources/js/bootstrap/bootstrap.min.js"></script>
<script src="/resources/js/app.min.js"></script>
<script>

  function formChk() {

    // 아이디 입력이 안됐을 경우
    if (document.getElementById('loginForm').id.value == '') {
      document.getElementById('loginForm').id.focus();
      $('#help-id').text("아이디를 입력해주세요");
      document.getElementById('loginForm').id.closest(".form-md-floating-label").addClass(
          "has-error");

      // 비밀번호 입력이 안됐을 경우
    } else if (document.getElementById('loginForm').pass.value == "") {
      document.getElementById('loginForm').pass.focus();
      $('#help-pwd').text("비밀번호를 입력해주세요");
      document.getElementById('loginForm').id.closest(".form-md-floating-label").addClass(
          "has-error");

    } else if (document.getElementById('loginForm').pass.value.length >= 20) {
      document.getElementById('loginForm').pass.focus();
      $('#help-pwd').text("비밀번호는 최대 20자까지 입력이 가능합니다");
      document.getElementById('loginForm').id.closest(".form-md-floating-label").addClass(
          "has-error");

    } else {
      $.ajax({
        url: '/login.do',
        type: 'post',
        data: $('#loginForm').serialize(),
        success: function (data) {
          // 확인용 alert(data.message);
          if (data.status == "200") {
            if (data.message == "duplicated") {
              var change = confirm("다른 사용자가 같은 아이디로 로그인중입니다! 강제로 로그아웃 하시겠습니까?");
              if (change) {
                $(location).attr('href', "/logout.do");
              } else {
                $(location).attr('href', "/loginform.do");
              }
            } else {
              $(location).attr('href', "/board/list.do");
            }
          } else {
            if (data.message == "accountLock") {
              alert("로그인시도 반복 실패로 계정이 잠겼습니다. 관리자에게 문의해주세요.");
              $(location).attr('href', "/loginform.do");
            }
            document.getElementById('loginForm').id.focus();
            $('#help-id').text("유효하지 않은 회원정보입니다");
            document.getElementById('loginForm').id.closest(".form-md-floating-label").addClass(
                "has-error");
          }
        }
      })
    }
  }

</script>
</body>
</html>
