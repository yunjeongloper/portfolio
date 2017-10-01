var AJAX={
	call: function(url,params,cbfunc){
		var callobj={};
		callobj["url"]=url;
		callobj["type"]="POST";
		callobj["data"]=params;
		callobj["cache"]=false;
		callobj["dataType"]="text";
		callobj["success"]=cbfunc;
		callobj["error"]=function(xhr,status,error){
			
		};
		jQuery.ajax(callobj);
	},

	formCall: function (url, params, cbfunc) {
		var callobj = {};
		
		callobj["url"] = url;
		callobj["type"] = "POST";
		callobj["data"] = params;
		callobj["processData"] = false;
		callobj["contentType"] = false;
		callobj["cache"] = false;
		callobj["dataType"] = "text";
		callobj["success"] = cbfunc; 
		callobj["error"] = this.onError;
		
		jQuery.ajax(callobj);
	},

	onError: function (xhr, status, error) {
		if (xhr.status == 0) {
		    alert("네트워크 접속이 원할하지 않습니다.");
		}
		else {
			var str = "code:" + xhr.status + "\n" + "message:" + xhr.responseText + "\n" + "error:" + error;
		    alert(str);
		}
	},
};

var ImageUploader = {
	vwMain: "",
	imageIdx: 0,
	imageList: [],

	init: function (vid) {
		this.vwMain = vid;
		
		$(vid).append("<input id='--photo-input' type='file' style='display:none'>");
        document.getElementById("--photo-input").onchange = function() {
        	if (this.files && this.files[0]) {
        		ImageUploader.add(this.files[0]);
        	}
		};
	},

	open: function () {
		document.getElementById("--photo-input").click();
	},
	
	add: function (file) {
		if(!this.checkType(file.name)) {
			alert("이미지 형식의 파일이 아닙니다.");
			return;
		}
		
		var index = this.imageIdx++;
		
    	var str = "<div id='--photo-" + index + "'>"; 
		str += "<div id='--photo-pane-" + index + "' class='grid-50'>";
		str += "<div id='--photo-img-" + index + "' class='flex-embed'></div>";
		str += "</div></div>";
    	
        $(this.vwMain).append(str);

        var reader = new FileReader();
        reader.onload = function (e) {
            $("#--photo-img-" + index).css('background-image', 'url(' + e.target.result + ')');
        	ImageUploader.imageList.push(file);
        }
        reader.readAsDataURL(file);
	},

	checkType: function (file) {
		var ext = file.split('.').pop().toLowerCase();
		return ($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) ? false : true; 
	},
};