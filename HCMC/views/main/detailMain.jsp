<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:requestEncoding value="UTF-8"/>


<script>


	function toShowPicturs (deviceCode) {
		
		$("#toShowPictursFrm input").val(deviceCode);
		$("#toShowPictursFrm").submit();
	}
</script>

<div style="height:250px;
    text-align: center;
    position: relative;
    top: 50%;
    -ms-transform: translateY(-50%);
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);">
	<img src="http://210.94.241.121:8080/?action=stream">
	<h1>S T R E A M I N G . . . </h1>
</div>

<form id="toShowPictursFrm" action="toShowPicture.do">
	<input type="hidden" name="deviceCode" value=""/>
</form>

<hr style="border-style:groove" size=30>

<!-- 중앙 아래 왼쪽 네모칸 -->
<div style="float: left;
	border-top-style: none;
    border-right-style: groove;
    border-bottom-style: none;
    border-left-style: none;
 	width: 49.5%; height: 200px; text-align:center; ">
  	<!--안 -->
  	<script>
  	 onClick="toShowPicturs('${cctvInfo.deviceCode}')"
  	</script>
 	<img height=200 width=250 src="JoinDetailPucture.jpg">
</div>
<!-- 중앙 왼쪽 네모칸 끝 -->

<!-- 중앙 오른쪽 네모칸 -->
<div style="float: right; border-style: none; width: 49.5%; height: 200px; text-align:center">
 	<img height=200 width=200 src="TestSound.jpg">
</div>
<!-- 중앙 오른쪽 네모칸 끝 -->

