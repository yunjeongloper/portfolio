<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<script>

	$(document).ready(function () {
		
		//폼 동적활용
		if("${member != null}" == "true"){
			
			$(document.signUP).attr("action", "updateMember.do");
			$(document.signUP.sSubmit).text("변경하기");
		} else {
			$(document.signUP).attr("onsubmit",'return signUp.checkCertify()')
		}
		
		//도면사진 미리보기
		$("#homeimg").change(function () {
			
			var $that = $(this);
		
			if(this.files.length != 0) {
				if(window.FileReader) {
					
					$("form[name=signUP] input[name=fileExist]").val("Y");
					
					alert($("input[name=fileExist]").val());
					
					var reader = new FileReader();
					width = "400px";
					height = "400px";
					
					reader.onload = function(e) {
						
						$(".imgMirror").remove();
						var src = e.target.result;
						$that.parent().prepend('<img src="'+src+'" class="imgMirror" width="'+width+'" height="'+height+'">');
					}
					
					reader.readAsDataURL(this.files[0]);
				}
			}
		});
	});
	
   $(function() {
      
      $("signUp").submit(
            function() {
               var tel_pattern = /^01[016789]-\d{4}-\d{4}$/;
               var email_pattern = /^([0-9a-zA-Z_-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
               if ($("#id").val() ==""){
                  alert("아이디를 입력해 주세요.");
                  $("#id").focus();
                  return false;
                  
               }else if($("#pw").val() == ""){
                  alert("비밀번호를 입력해 주세요.");
                  $("#pw").focus();
                  return false;
                  
               }else if($("#pw2").val() == ""){
                  alert("비밀번호확인를 입력해 주세요.");
                  $("#pw2").focus();
                  return false;
                  
               }else if($("#pw").val() != $("#pw").val() ) {
                  alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                  $("#pw").focus();
                  return false;
                  
               }else if($("#tel").val() == "" ) {
                  alert("핸드폰번호를 입력해주세요");
                  $("#tel").focus();
                  return false;
                  
/*                }else if(tel_pattern.text($(#"tel").val()) != true ) {
                  alert("핸드폰번호를 다시 입력해주세요");
                  $("#tel").focus();
                  return false; */
                  
               }else if($("#uname").val() == "" ) {
                  alert("이름을 입력해주세요");
                  $("#uname").focus();
                  return false;
                  
               }
            })
   })
</script>

<div class="legi_container" style="">
	<div id="legi7" class="legi_section">
	<form name="signUP" action="insertMember.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="fileExist" value="N"/>
		<input type="hidden" name="beforeImgCode" value="<c:out value='${member.homeimg}' default='0'/>" />
		<input type="hidden" name="beforeImgPath" value="<c:out value='${member.pPath}' default='x'/>" />
         <div>
            <input id="id" title="아이디" type="text" placeholder="아이디" name="id" value="${member.id}">
            <c:if test="${member == null}">
            	<input id="idcheck" type="button" value="중복확인" onClick="signUp.checkDuplicate(this)">
            </c:if>
         </div>
         <div><input id="pw" type="text" placeholder="패스워드" name="pw" value="${member.pw}"></div>
         <c:if test="${member == null}">
	         <div><input id="pw2" type="text" placeholder="패스워드 확인"></div>
         </c:if>
         <div>
            <input id="tel" title="휴대폰" type="text" placeholder="휴대폰" name="tel" value="${member.tel}">
            <c:if test="${member == null}">
            	<button type="button" onClick="signUp.sendSMSMsg(this)">인증</button>
            </c:if>
         </div>
         <div>
            <input id="uname" type="text" placeholder="이름" name="name" value="${member.name}">
         </div>
         
         
		<div class="legi_box2">
			<div class="question-answer">
				<div class="inner-btn-wrap">
					<div class="row" style="margin:0;padding:0;">
						<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12" style="padding: 0 1px;">
							<input type="text" class="form-control inner-btn-input" placeholder="장소를 검색하세요." 
							id="search-location-input" autocomplete="off"/>
						</div>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12" style="padding: 0 1px;">
							<div class="inner-btn-button">
								<button type="button" class="btn" id="search-location-btn" onClick="javascript:searchA()">검색</button>
							</div>
						</div>
					</div>
					<ul class="auto-complete-container" id="location-auto-complete" style="display: none;">
					</ul>
				</div>
				<ul id="selected-location-container"></ul>
				<div id="enrollMap" style="width: 100%; height: 500px;"></div>
			</div>
		</div> 	  
         <div>
         	<c:if test="${member.homeimg != null}">
         		<img class="imgMirror" src="${member.pPath}" width="400px" height="400px"/>
         	</c:if>
         	<c:if test="${member.homeimg == null}">
         		<div class="imgMirror" style="display:inline-block; width:400px; height:400px; background-color: gray; line-height: 400px; text-align: center;">도면사진 없음</div>
         	</c:if>
            <input type="file" id="homeimg" name="homeimg">
         </div>
         <div>
			 <input name="sSubmit" type="submit" value="등록하기">
			 <input type="reset" value="취소">
		 </div>
 	</form>
	</div>
</div>
   <!-- 전체 화면 끝 -->

<script>
// 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
var infowindow = new daum.maps.InfoWindow({zIndex:1});

var mapContainer = document.getElementById('enrollMap'), // 지도를 표시할 div 
    mapOption = {
        center: new daum.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new daum.maps.Map(mapContainer, mapOption); 
var markers = [];

//주소-좌표 변환 객체를 생성합니다
var geocoder = new daum.maps.services.Geocoder();

// 장소 검색 객체를 생성합니다
var ps = new daum.maps.services.Places(); 

// 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
// LatLngBounds 객체에 좌표를 추가합니다
var bounds = new daum.maps.LatLngBounds();
var markerObject ="";
var keyword =""

// 키워드로 장소를 검색합니다
function searchA () {
	keyword = $(".inner-btn-input").val();
	
	if (keyword != "") {
		
		ps.keywordSearch(keyword, placesSearchCB); 
		return;
	} else {
		
		alert("장소를 입력해주세요!");
		return;
	}	
}


// 키워드 검색 완료 시 호출되는 콜백함수 입니다

function placesSearchCB (status, data, pagination) {
    if (status === daum.maps.services.Status.OK) {

        for (var i=0; i<data.places.length; i++) {
        	
        	markerObject = data.places[i];
            var which = new daum.maps.LatLng(markerObject.latitude, markerObject.longitude);
            
            searchDetailAddrFromCoords(which, function(status, result) {
            	if (status === daum.maps.services.Status.OK) {
            		var index = 0;
	            	var juso = markerObject.title; 
	            	juso += !!result[0].roadAddress.name ? ": "+result[0].roadAddress.name : '';
	            	juso += ": "+result[0].jibunAddress.name;
	            	
	            	var li = '<li data-latitude="'+which.getLat()+'" data-longitude="'+which.getLng()+'" onClick="javascript:setBounds(\''+which.getLat()+'\', \''+which.getLng()+'\', \''+juso+'\')">'+juso+'</li>';
	            	index++;
	                $("#location-auto-complete").attr("style", "display: block;");
	                $("#location-auto-complete").append(li); 
             	}
            });

        }       
    } 
}

function setBounds (Lat, Lng, juso) {
	
    bounds.extend(new daum.maps.LatLng(Lat, Lng));
    map.setBounds(bounds);
    $("#location-auto-complete li").remove();
    $("#location-auto-complete").attr("style", "display: none"); 
    
    var li = "";
    if($(".location-list").length < 1) {
	    
    		alert("0개째");
	    	li +=   "<li class='location-list'>"
	    	   + 		"<div class='input-radio-wrap left'>"
	    	   +			"<input type='radio' name='main_location' value='"+juso+"' checked='checked'" 
	    	   +			"onClick='javascript:mainLocationChange(this)'/>"
	    	   +		"</div>"
	    	   +		"<span class='main_location'>(대표위치)</span>"
	    	   +		"<span class='location-item'" 
	    	   +		"data-lat='"+Lat+"' data-lng='"+Lng+"'>"
	    	   +		juso+"</span>"
	    	   +		"<button type='button' style='background-color: rgba(0,0,0,0);' class='btn btn-large removeSchedule' onClick='javascript:removeLocation(this)'><em class='fa fa-close'></em></button>"
	    	   +		"<input type='hidden' name='address' value='"+juso+"'/>"
	    	   +		"<input type='hidden' name='lat' 	  value='"+Lat+"'/>"
	    	   +		"<input type='hidden' name='lng'	  value='"+Lng+"'/>"
	    	   +	"</li>";
    } else {
    	
    		alert("1개이상째");
	    	li +=   "<li>"
	    	   + 		"<div class='input-radio-wrap left'>"
	    	   +			"<input type='radio' name='main_location' value='"+juso+"'"
	    	   +			"onClick='javascript:mainLocationChange(this)'/>"
	    	   +		"</div>"
	    	   +		"<span class='main_location'></span>"
	    	   +		"<span class='location-item'" 
	    	   +		"data-lat='"+Lat+"' data-lng='"+Lng+"'>"
	    	   +		juso+"</span>"
	    	   +		"<button type='button' style='background-color: rgba(0,0,0,0);' class='btn btn-large removeSchedule' onClick='javascript:removeLocation(this)'><em class='fa fa-close'></em></button>"
	    	   +		"<input type='hidden' name='address' value='"+juso+"'/>"
	    	   +		"<input type='hidden' name='lat' 	  value='"+Lat+"'/>"
	    	   +		"<input type='hidden' name='lng'	  value='"+Lng+"'/>"
	    	   +	"</li>";
    	
    }
    alert("li는 재대로인가?"+li);
    $("#selected-location-container").append(li);
    alert("추가는 됬니?" + $("#selected-location-container").children("li").length);
    
	displayMarker(Lat, Lng, juso);
    		
};

// 지도에 마커를 표시하는 함수입니다
function displayMarker(Lat, Lng, juso) {
    
    // 마커를 생성하고 지도에 표시합니다
    var marker = new daum.maps.Marker({
        map: map,
        position: new daum.maps.LatLng(Lat, Lng) 
    });
    
    markers.push(marker);

    var title = juso.substring(0,juso.indexOf(':'));
    
    // 마커에 클릭이벤트를 등록합니다
    daum.maps.event.addListener(marker, 'click', function() {
    	var which = marker.getPosition();
        searchDetailAddrFromCoords(which, function(status, result) {
            if (status === daum.maps.services.Status.OK) {
                var detailAddr = '<div>'+title+'</div>';
                detailAddr 	   += !!result[0].roadAddress.name ? '<div>도로명주소 : ' + result[0].roadAddress.name + '</div>' : '';
                detailAddr += '<div>지번 주소 : ' + result[0].jibunAddress.name + '</div>';
                
                var content = '<div class="bAddr">' +
                                detailAddr + 
                              '</div>';

                // 마커를 클릭한 위치에 표시합니다 
                marker.setPosition(which);
                marker.setMap(map);

                // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
                infowindow.setContent(content);
                infowindow.open(map, marker);
            }   
        });
    });
}

function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2detailaddr(coords, callback);
}   

function mainLocationChange (HTMLLIElement) {
		
		$this = $(HTMLLIElement);
		if ($this.prop("checked")) {
			
			$(".location-list .main_location").text("");
			$(".location-list").removeClass("location-list");
			
			$this.parent().parent("li").addClass("location-list");
			$this.attr("checked", "checked");
			$this.parent().parent("li").children(".main_location").text("(대표장소)");
		}
};    

function removeLocation (HTMLBTNElement) {
		
		$this = $(HTMLBTNElement);
		$this.parent().remove();
		
		var lis = $("#selected-location-container li");
		$("#selected-location-container li").remove();
		
		markers.forEach(function(value, index) {
			
			value.setMap(null);
		});
		
		lis.each(function (index, value) {
			
			var lat = $(value).children(".location-item").attr("data-lat");
			var lng = $(value).children(".location-item").attr("data-lng");
			var juso = $(value).children(".location-item").text();
			
			setBounds(lat, lng, juso);
		});
};    
</script>   