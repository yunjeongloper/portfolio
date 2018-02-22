<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:requestEncoding value="UTF-8"/>

<script>
	function toDetailMain (deviceCode) {
		
		$("#toDetailMainFrm input").val(deviceCode);
		$("#toDetailMainFrm").submit();
	}
</script>


<!-- 중앙 위 네모칸 -->
<div style="height:230px;
    text-align: center;
    position: relative;
    top: 35%;
    -ms-transform: translateY(-50%);
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);">
	<form id="toDetailMainFrm" action="toDetailMain.do" method="post">
		<input type="hidden" name="deviceCode" value="1"/>
		<h2>SELECT CCTV</h2>
		<c:forEach items="${devices}" var="devices">
			<div style="font-size:30px" onClick="toDetailMain('${devices.deviceCode}')">
				[${devices.deviceName}]
			</div>
		</c:forEach>
	</form>
</div>

<hr style="border-style:groove" size=30>

<!-- 중앙 아래 왼쪽 네모칸 -->
<div style="float: left;
	border-top-style: none;
    border-right-style: groove;
    border-bottom-style: none;
    border-left-style: none;
 	width: 49.5%; height: 200px; text-align:center; " onClick="pageSubmit('toSound_main.do')">	
	<img height=200 width=200 src="AddSound.jpg">
</div>
<!-- 중앙 왼쪽 네모칸 끝 -->

<!-- 중앙 오른쪽 네모칸 -->
<div style="float: right; border-style: none; width: 49.5%; height: 200px; text-align:center" onClick="pageSubmit('deviceSet.do')">
	<img height=200 width=200 src="JoinRestrictedArea.jpg">
</div>
<!-- 중앙 오른쪽 네모칸 끝 -->

<!-- Main Javascript -->
<script src="assets/js/main.js"></script>
<script src="assets/js/test.js" type="dumb"></script>
<script src="assets/js/jquery.uploadfile.js" type="text/javascript"></script>