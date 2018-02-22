<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<fmt:requestEncoding value="UTF-8"/>

  <head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="">

    <!-- jQuery -->
    <script src="assets/lib/jquery.min.js"></script>
    <script src="assets/lib/jquery-ui.js"></script>
    <script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.2.js"></script>
    
    <script src="https://unpkg.com/leaflet@1.0.3/dist/leaflet.js"
	integrity="sha512-A7vV8IFfih/D732iSSKi20u/ooOfj/AGehOKq0f4vLT1Zr2Y+RX7C+w8A1gaSasGtRUZpF/NZgzSAu4/Gc41Lg=="
	crossorigin=""></script>

    <title>흥청망청</title>
    <!-- Google Font(s) -->
    <link href="https://fonts.googleapis.com/css?family=Capriola|Roboto" rel="stylesheet">

 	<!-- Daum map -->
    <script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=10d44bdc22885a555686cd67fdb5b69b&libraries=services,clusterer"></script>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet">
    <!-- Bootstrap-->
    <link href="assets/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Awesome Icons Font -->
    <link href="assets/fonts/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <!-- Listing Filter -->
    <link href="assets/lib/bootstrap-select-master/dist/css/bootstrap-select.min.css" rel="stylesheet">
    <!-- Lightbox -->
    <link href="assets/lib/lightbox2-master/dist/css/lightbox.min.css" rel="stylesheet">
    <!-- Map -->
    <link href="assets/lib/Leaflet-1.0.2/dist/leaflet.css" rel="stylesheet">
   	<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.0.3/dist/leaflet.css"
	integrity="sha512-07I2e+7D8p6he1SIM+1twR5TIrhUQn9+I6yjqD53JQjFiMf8EtC93ty0/5vJTZGF8aAocvHYNEDJajGdNx1IsQ=="
	crossorigin="" />
    <!-- City Listing Icons -->
    <link href="assets/fonts/icons/css/import-icons.css" rel="stylesheet">
    <!-- Main CSS -->
    <link href="assets/css/style.css" rel="stylesheet">
   	<!-- upload css -->
    <link href="assets/css/uploadfile.css" rel="stylesheet" type="text/css" />
    <!-- jquery-ui css -->
    <link href="assets/css/jquery-ui.css" rel="stylesheet" type="text/css" />
  </head>
  
  <script>
  
		//회원가입 관리
		var signUp = {
			
			certify : {phoneCertify : false, duplicateCertify : false},
			allCertify : false,
			ranNum : Math.floor(Math.random() * 999999) + 1,	
			phoneNumber : "",
				
			//핸드폰 인증번호 발송
			sendSMSMsg : function (BtnEle, callback) {
				
				var $this = this;
				var $target = $(BtnEle);
				var $phone = $target.prev();
				this.phoneNumber = $phone.val();
				//휴대폰 번호 nullcheck
				alert("폰번호 : "+$phone.val()+" / ranNum : "+this.ranNum);
				
				if($phone.val()) {
				
					if($phone.val().search(/^01[016789]-\d{4}-\d{4}$/) == -1) {
						
						alert($phone.attr("title")+"의 형식이 올바르지 않습니다.");
						return false;
					} 
				} else {
					
					alert($phone.attr("title")+"을 입력해주세요.");
					return false;
				} 
				
				$.ajax({
					
					url 	: "sendSMSMsg.do",
					data	: {msg : "인증번호 : "+$this.ranNum, rphone : $phone.val()},
					async	: false,
					success : function (sendResult) {
						
						if(sendResult == "success") {
							//번호입력칸 출력 -> 기존 버튼 삭제
							var inputForNum = "<input type='text' placeholder='인증번호를 입력하세요'/>"
											  +"<button type='button' onClick='signUp.checkSMSMsg(this, "+callback+")'>인증하기</button>";
							$target.after(inputForNum);
							$target.remove();
						}
						
					}, error: function () {}
					
				})
			},
			
			//핸드폰 인증번호 검사
			checkSMSMsg : function (inputEle, callback) {
				
				$this = this;
				$num = 	$(inputEle).prev();
				
				if($num.val().trim() == this.ranNum) {
					
					//휴대폰 번호 중복검사
					$.ajax({
						
						url		: "findIdByPhone.do",
						data	: {phone : $this.phoneNumber},
						async	: false,
						success : function (findResult) {
							
							//중복x면
							if (findResult == "FAIL") {
								
								alert("인증되었습니다.");
								$this.certify["phoneCertify"] = true;
								
								if($this.certify["duplicateCertify"] == true)
									$this.allCertify = true;
								
								if(callback != undefined)
									callback();
								
							} else {
								
								alert("해당 휴대폰은 이미 다른 사용자에게 인증되었습니다.");
							}
						},error	: function () {
							
							
						}
					})
				} else {
					
					alert("인증번호가 알맞지 않습니다. 다시입력하세요.");
					$num.val("");
				}
			},
			
			//아이디 중복검사
			checkDuplicate : function (BtnEle) {
				
				$this = this;
				$target = $(BtnEle).prev().val();
				
				if(!$target) {
					
					alert("아이디를 입력해주세요.");
					return false;
				}
				
				$.ajax({
					
					url 	: "checkUserDuplicate.do",
					data 	: {userId : $target},
					asyc	: false,
					success : function (result) {
						
						alert(result);
						
						if(result == "FINE") {
							
							$this.certify["duplicateCertify"] = true;
							if($this.certify["phoneCertify"])
								this.allCertify = true;
								
							alert("사용해도 좋은 아이디 입니다.");
						} else 
							alert("중복된 아이디 입니다. 다시 입력해주세요.");
						
					}, error: function (result) {
						
						alert("error");
					}
				})
				
			},
			
			//all 인증 통과여부 확인
			checkCertify : function () {
				
				if(!this.allCertify) {
					
					if(!this.certify["duplicateCertify"]) 
						alert("중복확인 체크를 완료하세요.");
					 else 
						alert("휴대폰 인증을 완료하세요.");					
					
					return false;
				} else
					return true;	
			}
		}
  	
		
		//아이디 찾기
		function findIdByPhone () {
			
			var phoneVar = $("#findId .phone").val();
			
			$.ajax({
				
				url		: "findIdByPhone.do",
				data	: {phone : phoneVar},
				async	: false,
				success : function (findResult) {
					
					if (findResult == "FAIL") {
						alert("아이디 찾기에 실패했습니다.");
					}
					
					var findedId = "<div>아이디 : "+findResult+"</div>";
					$("#findId .findGroup").append(findedId);
					
				},error	: function () {
					
					
				}
			})
			
		}
		
		//비밀번호 찾기 (부가기능)
		function findPwByPhone () {
			
			//핸드폰 인증 후, 해당 핸드폰 번호가 회원정보와 일치하는지 체크
			var idVar = $("#findPw .userId").val();
			var phoneVar = $("#findPw .phone").val();
			
			$.ajax({
				
				url 	: "checkPhone.do",
				data	: {id : idVar, phone : phoneVar},
				async	: false,
				success : function (checkResult) {
					
					if(checkResult == "isValid") {
						
						var inputNewPw = "<div>"
									   +	"<input id='newPw' type='text'/>"
									   +	"<button type='button' onClick='updatePw()'>변경하기</button"
									   + "</div>";
							
						$("#findPw .findGroup").append(inputNewPw);
					}
					
				}, error: function () {}
				
			})
		}
		
		//새 비밀번호로 변경
		function updatePw () {
			
			var idVar = $("#findPw .userId").val();
			var newPwVar = $("#newPw").val();
			
			$.ajax({
				
				url		: "updatePw.do",
				data	: {id : idVar, newPw : newPwVar},
				async	: false,
				success : function (updateResult) {
					
					if (updateResult == "FAIL") {
						alert("새 비밀번호 변경에 실패했습니다.");
					}
						alert("비밀번호가 변경되었습니다.");
						window.location.href = "login.do";
					
				},error	: function (updateResult) {
					
					alert("error : "+updateResult);
				}
			})
		}		
		
		
		
  </script>
  
<form id="pSubmit" method="post">

</form>

			<div id="Login_Modal2" style="margin-top:100px;"  class="login-modal modal fade" role="dialog" aria-hidden="true">
               <div class="modal-dialog">
                   <!-- Modal content-->
                   <div class="modal-content">
                       <div class="login-failed-desc">
                           <em class="icon-ban"></em>
                       </div>
                       <div class="row loginModalRow">
                           <div class="hidden-lg hidden-md hidden-sm col-xs-12 loginModalBar">
                               로그인
                               <button type="button" class="closeModalButton" data-dismiss="modal"><em class="fa fa-close"></em></button>
                           </div>
                       </div>
                       <!-- 로그인 버튼 눌렀을때 모달창 가려지는 마스크 -->
                       <div class="modal-header">
                       </div>
                       <div class="modal-login-button" id="modal_LoginForm">

                           <div id="social-login-button">
<!--                                  <div class="facebookLoginButton"><img src="http://moccozy.blob.core.windows.net/icon/icon_modal_facebook.png" />페이스북으로 시작하기</div> -->
                           </div>
                           <div class="login-or-separator" style="text-align: center;">
                               <span class="h6 signup-or-separator-text">또는</span>
                           </div>
                           <form method="post" accept-charset="utf-8" action="userLogin.do" id="formLoginUser" name="formLoginUser">
                               <div class="form-group" id="input-UserEmail">
                                   <div class="icon-addon addon-md">
                                       <input id="uid" class="form-control" name="uid" type="text" placeholder="아이디">
                                   </div>
                               </div>
                               
                               <div class="form-group" id="input-UserPassword">
                                   <div class="icon-addon addon-md">
                                       <input id="upass" class="form-control" name="upass" type="text" placeholder="패스워드">
                                   </div>
                               </div>
                               
                               <div class="form-group" id="input-KeepLoginWrap">
                                   <a class="forgotIDandPASS" href="#" data-toggle="modal" data-target="#findUser_Modal" data-keyboard="false" id="findUserModal_button">비밀번호를 잊으셨나요?</a>
                               </div>
                               <span id="login-false-desc"></span>
                               <input type="hidden" name="applicationType" value="0" />
                               <center><button style="width: 83%;" class="btn btn-large btn-default">로그인</button></center>
                           </form>
                       </div>
                       <div class="modal-footer" id="login-Modal-Footer">
                           <p class="modal-footer-desc">
                               	아이디가 없으신가요?
                               <button type="button" class="btn btn-default " id="joinUserButton" data-toggle="modal" data-target='#Join_Modal' onclick="modalChange()">회원가입</button>
                           </p>
                       </div>
                   </div>
               </div>
           </div>


			<div id="Join_Modal" style="margin-top:100px;" name="aa" class="join-modal modal fade" role="dialog" aria-hidden="true" >
                <div class="modal-dialog">
                    <div class="login-failed-desc">
                        <em class="icon-ban"></em>
                    </div>
                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="row loginModalRow">
                            <div class="hidden-lg hidden-md hidden-sm col-xs-12 loginModalBar">
                               	 회원가입
                                <button type="button" class="closeModalButton" data-dismiss="modal"><em class="fa fa-close"></em></button>
                            </div>
                        </div>
                        <div class="registerMask">
                           <!--  <img class="loadingImage" src="http://moccozy.blob.core.windows.net/icon/loading_medium.gif" /> -->
                        </div>
                        <div class="modal-header"></div>
                        <div class="modal-body">
                            <form id="email-Join-Form" method="post" accept-charset="utf-8">
								<div class="emailGroup" style="text-align: center;">
	                                <input type="text" title="email" style="width:290px;; display: inline-block;" class="form-control" name="email" placeholder="이메일을 입력해주세요" autocomplete="off" />
	                                <div class="card-selector-container" style="text-align: center; vertical-align: middle; width: 178px; display: inline-block; border-radius: 4px;">
		                                <div id="emailSelect" class="card-selector dropdown-toggle" style="padding: 0px;" data-toggle="dropdown" aria-expanded="false">
		                                	<div style="padding-left:10px; display: table-cell; vertical-align: middle;">@</div>
		                                	<div class="title">이메일 직접입력</div>
		                        			<div class="button" style="background: rgba(255,255,255,0.7);">
												<em class="fa fa-sort-desc"></em>
											</div>
		                                </div>
	                                    <ul id="emailC" class="card-selector-list dropdown-menu open" role="menu" aria-labelledby="emailSelect" style="top:55px;">
	                                		<li>naver.com</li>
	                                		<li>daum.net</li>
	                                		<li>gmail.com</li>
	                                		<li>이메일 직접입력</li>
	                                	</ul>
		                            </div>
                                </div>
                                <div id="userId_validation" class="join-validation" style="margin-left: 48.281px;"></div>
                                
                                <div class="emailGroup" style="text-align: center;">
                                	<input type="password" title="password" class="form-control" name="password" maxlength="16" placeholder="특수문자를 제외한 6자 이상으로 입력해주세요." autocomplete="off" />
                                </div>
                                <div class="join-validation"></div>
			
								<div class="emailGroup" style="text-align: center;">
                                <input type="text" title="userName" class="form-control" name="userName" placeholder="사용자 이름을 입력해주세요" />
                                </div>
                                <div class="join-validation"></div>
                                
                                
                                <div class="verify" style="width:83%; margin: 10px auto;">
                                    <input type="tel" title="userPhone" name="userPhone" class="form-control" placeholder="휴대폰 번호 입력( '-' 제외 ) " maxlength="11" />
                                    <button type="button" style="margin-left:6px; width:22%; height:51px;" class="btn btn-primary phoneVertifyButton" id="phoneVerifiedButton">인증하기</button>
                                </div>
                                <div class="join-validation"></div>
                                
                                <div class="verify" style="width:83%; margin: 10px auto;">
                                    <input type="text" title="autoCode" name="authCode" class="form-control" placeholder="인증번호 입력" maxlength="6" disabled="disabled" />
                                    <button type="button" style="margin-left:6px; width:22%; height:51px;" class="btn btn-primary phoneVertifyButton" id="authCodeButton">확인</button>
                                </div>
                                <div class="timer" style="display:none;">
                                    	인증번호가 발송되었습니다. ( 유효시간 : <span id="timerMinutes"></span> 분 <span id="timerSecond"></span> 초 )
                                </div>
                                <div style="width:83%; margin: 10px auto;">
									<div class="_radio radio-inline">
									  <input type="radio" name="sex" id="sex0" value="남자">
									  <label for="sex0" style="margin-right: 30px;"><mark></mark>남자</label>
									</div>
									<div class="_radio radio-inline">
									  <input type="radio" name="sex" id="sex1" value="여자">
									  <label for="sex1"><mark></mark>여자</label>
									</div>
                                    <div id="gender_validation" class="join-validation" style="margin:0;"></div>
                                </div>

                                <div class="agreement-description" style="width:83%; margin: 10px auto;">
                                    회원가입을 하면 흥청망청의
                                    <a href="http://www.moccozy.com/term/serviceUse">서비스 이용약관</a>,
                                    <a href="http://www.moccozy.com/term/userPrivate">개인 정보 보호 정책</a>,
                                    <a href="http://www.moccozy.com/term/location">위치정보 서비스 이용약관</a>
                                    에 동의하는 것으로 간주됩니다
                                </div>
                                <center><button style="width: 83%; height: 51px;" type="button" id="joinSubmit" class="btn btn-primary joinSubmit" onClick="resultCheck('userJoin')">회원가입</button></center>
                            </form>

                        </div>
                        <div class="modal-footer" id="login-Modal-Footer">
                            <p class="modal-footer-desc">
                                이미 흥청망청 회원이신가요 ?
                                <button type="button" class="btn btn-large btn-default" id="backLoginModal" data-toggle="modal" data-target='#Login_Modal2' onclick="modalChange()">로그인</button>
                            </p>
                        </div>
                    </div>
                </div>
            </div>        
            
			<div id="dDetailModel" style="margin-top:100px;" name="aa" class="join-modal modal fade" role="dialog" aria-hidden="true" >
				<div class="modal-dialog">
		            <!-- Modal content-->
		  	        <div class="modal-content">
                       <!-- 로그인 버튼 눌렀을때 모달창 가려지는 마스크 -->
                       <div class="modal-header">
                       		<h4 class="modal-title" id="myModalLabel">Modal title</h4>
                       </div>
                       <div class="modal-body">
							<form id="matchFrm" action="matchSpeack_Music.do" method="post">
								<input type="hidden" name="speakerCode" value="${matchInfo.deviceCode}"/>
								<div title="deviceName">장치명 : ${matchInfo.deviceName}</div>	
								<div title="musicList">		
									<c:if test="${fn:length(musics)} == 0">
											<div>음원이 없습니다.</div>
									</c:if> 
									<select name="musicCode">
										<c:forEach items="${musics}" var="musics">
											<c:if test="${matchInfo.musicCode eq musics.musicCode}">
												<option value="${musics.musicCode}" selected>${musics.mOriName}</option>
											</c:if>
											<c:if test="${matchInfo.musicCode ne musics.musicCode}">
												<option value="${musics.musicCode}">${musics.mOriName}</option>
											</c:if>
										</c:forEach>
									</select>
								</div>
								<input type="submit" value="저장">
						</div>
						<div class="modal-footer">
							<input type="button" value="소리 테스트하기">
							</form>
						</div>
					</div>
				</div>
			</div>
<script>

	function pageSubmit (pageName) {
		
		$("#pSubmit").attr("action",pageName);
		$("#pSubmit").submit();
	}
	
	function modalChange () {
		
		$("#Login_Modal2").modal("hide");
		$("#Join_Modal").modal("hide");
	}
	 	
	$(document).ready(function () {
		
		console.log("head");
	});

</script>            