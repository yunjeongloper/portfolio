<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:requestEncoding value="UTF-8"/>

<script>
	
	$(document).ready(function () {
		
		//로그인 o
		if("${sessId != null}" == "true")
			$(".afterLogin").css("display","block");
		else {
			$(".beforeLogin").css("display","block");
		}
	})
</script>

	<%-- <c:if test="${sessId ne null}">
	<h1 style="float: right;" onClick="pageSubmit('toSetting.do')">설정</h1>
</c:if> --%>

  <header class="header" style="margin-bottom: 60px;">
	<!-- Start Logo -->
	<div class="logo">
		<a href="#" onclick="pageSubmit('main.do')"
		class="logo-color-bg"> <img alt="" src="assets/images/logo22.png" />
		</a>
	</div>
	<!-- End Logo -->
	<!-- Start Navbar -->
	<div class="navbar navbar-inverse" role="navigation" id="slide-nav" style="margin-right: 50px;">
		<div class="container">
			<div id="slidemenu">
				<ul class="nav navbar-nav navbar-right" id="targetMenu">
					<li class="beforeLogin"><a href="#" data-toggle="modal" data-target="#Login_Modal2">Login</a></li>
					<li class="beforeLogin"><a href="#" data-toggle="modal" data-target="#Join_Modal">SignUp</a></li>
					<li class="dropdown afterLogin">
						<a href="#" style="top:-17px;" class="dropdown-toggle user-login"
						data-toggle="dropdown"></a>
						<ul class="dropdown-menu">
							<li><a href="toSetting.do">MyInfo</a></li>
							<li><a href="logout.do">LogOut</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- End Navbar -->
</header>         