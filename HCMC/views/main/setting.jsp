<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:requestEncoding value="UTF-8"/>

<h1>body default page</h1>

<script>
	function toShowPicturs (deviceCode) {
		
		$("#toShowPictursFrm input").val(deviceCode);
		$("#toShowPictursFrm").submit();
	}
</script>

<div onClick="pageSubmit('toMypage.do')">
	내 정보 수정하기
</div>
<div onClick="pageSubmit('toMypage.do')">
	로그아웃
</div>