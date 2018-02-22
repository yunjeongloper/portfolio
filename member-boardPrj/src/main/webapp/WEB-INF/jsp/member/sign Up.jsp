<%--
  Created by IntelliJ IDEA.
  User: myhoem
  Date: 2017-12-18
  Time: 오전 12:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link href="/resources/css/components-md.css" rel="stylesheet" type="text/css">
    <link href="/resources/css/common.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="center-body login">
    <div class="portlet box blue m-grid-col-center m-grid-col-md-3">
        <div class="portlet-title">
            <h3>회원가입</h3>
        </div>
        <div class="portlet-body">
            <form role="form" name="signUpForm" id="signUpForm">
                <div class="form-body">

                    <!-- 이름  -->
                    <div class="form-group form-md-line-input form-md-floating-label">
                        <input type="text" class="form-control" id="name" name="name" maxlength="10">
                        <label for="name">이름</label>
                        <span class="help-block" id="help-name"></span>
                    </div>
                    <!-- 이름  -->

                    <!-- 아이디 -->
                    <div class="form-group form-md-line-input form-md-floating-label">
                        <div class="input-group input-group-sm">
                            <div class="input-group-control">
                                <input type="text" class="form-control input-sm" name="id" id="checkId" maxlength="10">
                                <label for="checkId">아이디</label>
                                <span class="help-block" id="help-Id">중복 확인을 해주세요</span>
                            </div>
                            <span class="input-group-btn btn-right">
                                <button class="btn green-haze" type="button" id="check">중복검사</button>
                            </span>
                        </div>
                    </div>
                    <!-- 아이디 -->

                    <!-- 비밀번호 -->
                    <div class="form-group form-md-line-input form-md-floating-label">
                        <input type="password" class="form-control" id="pwd" name="pwd" maxlength="20">
                        <label for="pwd">비밀번호</label>
                        <span class="help-block" id="help-pwd">최대 20자까지 입니다.</span>
                    </div>
                    <!-- 비밀번호 -->

                    <!-- 비밀번호 확인 -->
                    <div class="form-group form-md-line-input form-md-floating-label">
                        <input type="password" class="form-control" id="pwd_ck" name="pwd_Ok" maxlength="20">
                        <label for="pwd_ck">비밀번호 확인</label>
                        <span class="help-block" id="help-pwd_ck"></span>
                    </div>
                    <!-- 비밀번호 확인 -->

                    <!-- 휴대폰 번호 -->
                    <div class="form-group form-md-line-input form-md-floating-label">
                        <input type="text" class="form-control" id="phone" name="phone">
                        <label for="phone">휴대폰 번호</label>
                        <span class="help-block" id="help-phone"></span>
                    </div>
                    <!-- 휴대폰 번호 -->
                    <input type="hidden" id="status" value="400">
                </div>
                <div class="form-actions noborder">
                    <button type="button" class="btn blue" id="submit">회원가입</button>
                    <button type="button" class="btn default" id="cancle">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="/resources/js/jquery-3.2.1.min.js"></script>
<script src="/resources/js/jquery.mask.js"></script>
<script src="/resources/js/bootstrap/bootstrap.min.js"></script>
<script src="/resources/js/app.min.js"></script>
<script src="/resources/js/signup.js"></script>
</body>
</html>
