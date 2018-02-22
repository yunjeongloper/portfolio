<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<fmt:requestEncoding value="UTF-8" />


<script>

	$(document).ready(function () {
		
		if("${uploadMsg}" != "")
		alert("uploadMsg : "+"${uploadMsg}");
	});

	function addInputFile() {
		
		var inputFile = "<input type='file' name='sound[]' multiple onChange='addInputFile()'/>";
		var lastInput = $("input[type=file]").last();
		lastInput.after(inputFile);
	}
	
	function checkAndInsert () {
		
		var result = true;
		
		var frm = $("#addSoundFrm");
		var sounds = frm.children("input[type=file]");
		console.log(sounds.length);
		sounds.each(function(index, sound){
			
			var dotLeng = sound.value.lastIndexOf(".");
			var endLeng = sound.value.length;
			var soundTTC = sound.value.substring(dotLeng+1, endLeng).toLowerCase();
			
			if (sound.files.length == 0 || soundTTC != "mp3") {
				
				if(frm.children("input[type=file]").length > 1)
					sound.remove();
			}
		});
		
		if(frm.children("input[type=file]").last()[0].files.length == 0) {
			
			alert($("#addSoundFrm").attr("title")+"할 요소가 없습니다.");
			result = false;
		}
		
		if(result)
			frm.submit();
	}
	
	function checkAndDeletet () {
		
		var result = true;
		
		var frm = $("#delSoundFrm");		
		var sounds = $("#delSoundFrm input").filter(":checked");
		
		if(sounds.length == 0) {
			alert($("#delSoundFrm").attr("title")+"할 요소가 없습니다.");
			result = false;
		}
		
		if(result)
			frm.submit();
	}
</script>

<!-- 중앙  위 가운데 네모칸 -->
<div style="height:200px;
    text-align: center;
    position: relative;
    top: 30%;
    -ms-transform: translateY(-50%);
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);">
 <h2>sound_main page</h2>
	<form id="delSoundFrm" action="deleteSound.do" title="음원삭제">
		<c:if test="${fn:length(musics)} == 0">
			<div>음원이 없습니다.</div>
		</c:if>
		<c:forEach items="${musics}" var="musics">
			<div><input type="checkbox" name="delMusics" value="${musics.musicCode}"/>${musics.mOriName}</div>
		</c:forEach>
	</form> 
</div>
<!-- 중앙 위 가운데 네모칸 -->

<hr style="border-style:groove" size=30>

<!-- 중앙 아래 왼쪽 네모칸 -->
<div style="float: left;
	border-top-style: none;
    border-right-style: groove;
    border-bottom-style: none;
    border-left-style: none;
 	width: 33%; height: 200px; text-align:center;">
	<!-- 멀티 업로드 -->
	<form id="addSoundFrm" title="음원추가" action="insertSound.do" method="post" enctype="multipart/form-data">
		<img height=140 width=140 src="AddSound.jpg">
		<input type="file" name="sound[]" onChange="addInputFile()" multiple onChange="addInputFile()"/>
		<div>
			<input type="button" value="더 등록하기" onClick="addInputFile()">
			<input type="button" value="등록" onClick="checkAndInsert()">
		</div>
	</form>
</div>
<!-- 중앙 왼쪽 네모칸 끝 -->

<!-- 중앙 아래 가운데 네모칸-->
<div style="float: left;
	border-top-style: none;
    border-right-style: groove;
    border-bottom-style: none;
    border-left-style: none;
 	width: 33%; height: 200px; text-align:center; " onClick="checkAndDeletet($('#delSoundFrm'))">
	<img height=200 width=200 src="DeleteSound.jpg">
 </div>
<!-- 중앙 아래 가운데 네모칸 끝 -->

<!-- 중앙 오른쪽 네모칸 -->
<div style="float: left;
	border-top-style: none;
    border-right-style: groove;
    border-bottom-style: none;
    border-left-style: none;
 	width: 33%; height: 200px; text-align:center; ">
 	<img height=200 width=200 src="TestSound.jpg">
</div>
<!-- 중앙 오른쪽 네모칸 끝 -->
