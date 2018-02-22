<%--
  Created by IntelliJ IDEA.
  User: myhoem
  Date: 2017-12-18
  Time: 오전 12:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>게시물 등록</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="/resources/css/bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="/resources/css/components-md.css" rel="stylesheet" type="text/css">
    <link href="/resources/css/common.css" rel="stylesheet" type="text/css">
    <link href="/resources/summernote/summernote.css" rel="stylesheet" type="text/css">

    <style>
        #dropzone {
            border: 2px dotted #3292A2;
            width: 100%;
            line-height: 25px;
            height: 50px;
            color: #92AAB0;
            padding-top: 10px;
            text-align: center;
            margin-top: 10px;
        }

        #fileUploadButton {
            width: 100px;
            float: left;
            border: 1px solid #b7daf3;
            margin-left: 10px;
        }

        #fileUploadButton:hover {
            background-color: #EBF7FF;
        }
    </style>

</head>
<body class="center-body">
<div style="width: 900px;">
    <div style="height: 50px;">
        <div style="float: left;width: 300px;">
            <span style="font-size: 24pt">게시물 목록</span>
        </div>
        <div style="float: right; width: 200px;">
            <span style="float: right; margin-left: 10px;">${userId}</span>
            <span style="float: right"><a href="/logout.do">로그아웃</a></span>
        </div>
    </div>
    <div style="width:700px; margin-top: 10px; margin-left: 100px">
        <div class="form-group form-md-line-input form-md-floating-label has-info">
            <div class="input-group input-group-sm">
                <div class="input-group-control" style="width: 550px;">
                    <input type="text" class="form-control input-sm" name="subject" id="subject" value="${board.subject}">
                    <label for="subject">제목</label>
                </div>
                <div class="md-checkbox md-checkbox-inline has-success"
                     style="margin-left: 50px;">
                    <input type="checkbox" id="checkNotice" name="checkNotice" class="md-check" <c:if test="${board.notice == true}">checked</c:if>>
                    <label for="checkNotice">
                        <span ></span>
                        <span class="check"></span>
                        <span class="box"></span> 공지여부 </label>
                </div>
            </div>
        </div>

        <div>내용</div>
        <div id="summernote">${board.content}</div>


        <div id="dropzone">
            <div id="fileUploadButton">
                <i class="material-icons" style="font-size: 15px;">&#xe2c6;</i>
                파일업로드
            </div>
            <span>파일을 드롭해주세요</span>
        </div>
        <div style="margin-top: 10px;">
            <table id="fileInfo">
                <c:forEach items="${fileList}" var="file">
                    <tr>
                        <td>${file.originName}
                            <input type="hidden" name="file" value="${file.no}">
                        </td>
                        <td><span id='${file.originName}' data="${file.no}" onclick='check(this)'>취소</span></td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <div style="height: 50px; width: 100%;" class="center-body">
            <button class="btn btn-info" onclick="submit()">등록</button>
            <button class="btn btn-default" style="margin-left: 10px;" onclick="location.href='/board/list.do'">취소</button>
        </div>
        <input type="hidden" name="parentsNo" id="parentsNo" value="${parentsNo}">
        <input type="hidden" id="idx" value="${board.no}">
        <input id="uploadFile" name="uploadFile[]" type="file" style="display: none;" multiple>
    </div>
</div>
<script src="/resources/js/jquery-3.2.1.min.js"></script>
<script src="/resources/js/bootstrap/bootstrap.min.js"></script>
<script src="/resources/js/app.min.js"></script>
<script src="/resources/summernote/summernote.js"></script>
<script src="/resources/js/stringBuffer.js"></script>
<script>

  var fileList = $('#uploadFile')[0];
  var form = new FormData();
  var num = new Array();
  var checkdata = new Array();

  function uploadFile(files) {
    if(checkdata.length >5 || checkdata.length+files.length >5) {
      alert("파일 갯수 5개 초과 입니다.");
      return false;
    } else {
      for (var i = 0; i < files.length; i++) {
        if (  files[i].name.length <= 20) {
          form.append(files[i].name, files[i]);
          var tag = createTag(files[i].name);
          $('#fileInfo').append(tag);
        } else {
          alert(files[i].name + "은(는) \n  이름이 20자 이상입니다.");
        }
      }
    }
  }

  function createTag(fileName) {
    var name = fileName;
    var tag = new StringBuffer();
    tag.append('<tr>');
    tag.append('<td>' + name + '</td>');
    tag.append("<td><span id='" + name + "' onclick='check(this)'>취소</span></td>");
    tag.append('</tr>');
    return tag.toString();
  }

  function check(e) {
    //선택한 창의 아이디가 파일의 form name이므로 아이디를 받아온다.
    var formName = e.id;
    //form에서 데이터를 삭제한다.
    form.delete(formName);

    checkdata.splice(checkdata.indexOf(e.data),1);
    // tr을 삭제하기 위해
    $(e).parents('tr').remove();
  }

  function imageUpload(image) {
    var imageData = new FormData();
    imageData.append(image.name, image);
    $.ajax({
      data : imageData,
      type : "POST",
      url : "/board/imageUpload.do",
      cache : false,
      contentType : false,
      processData : false,
      success : function(data) {
        $('#summernote').summernote('insertImage',"/resources/uploadImage/"+data.saveName,data.originName);
        num.push(data.no);
      }
    });
  }

  function submit() {

    var url ="";
    if($('#idx').val()!=null && $('#idx').val()!="") {
      url = "/board/modify.do";
      form.append("no",$('#idx').val());
    } else {
      url = '/board/create.do';
    }

    form.append('subject', $('#subject').val());
    form.append('parentsNo',$('#parentsNo').val());
    form.append('content', $('#summernote').summernote('code'));
    form.append('image',num);
    form.append('fileList',checkdata);
    if ($("input:checkbox[id='checkNotice']").is(":checked")) {
      form.append('checkNotice',true);
    } else {
      form.append('checkNotice',false);
    }
    $.ajax({
      url: url,
      type: 'post',
      data: form,
      contentType : false,
      processData : false,
      cache : false,
      success: function (data) {
        if(data.result=="200") {
          alert("작성완료");
          $(location).attr('href', "/board/list.do");
        } else {
          alert("작성 도중 문제 발생");
          form = new FormData();
        }

      }
    })

  }

  $(document).ready(function () {

    $("input[name='file']").each(function (i) {
      checkdata.push($("input[name='file']").eq(i).val());
    });
    $('#summernote').summernote({
      toolbar: [
        // [groupName, [list of button]]
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['font', ['strikethrough', 'superscript', 'subscript']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['height', ['height']]
      ],
      height: 300,
      callbacks: {
        onImageUpload: function (files) {
          imageUpload(files[0]);
        },
      },
      lang : 'ko-KR'
    });

    $('#uploadFile').on('change', function () {

      uploadFile(fileList.files);

    });


    $('#fileUploadButton').on('click', function () {
      $('#uploadFile').click();
    });

    $(function () {
      var obj = $("#dropzone");

      obj.on('dragenter', function (e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).css('border', '2px solid #5272A0');
      });

      obj.on('dragleave', function (e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).css('border', '2px dotted #8296C2');
      });

      obj.on('dragover', function (e) {
        e.stopPropagation();
        e.preventDefault();
      });

      obj.on('drop', function (e) {
        e.preventDefault();
        $(this).css('border', '2px dotted #8296C2');

        var files = e.originalEvent.dataTransfer.files;
        if (files.length < 1)
          return;

        uploadFile(files);

      });
    });
  });
</script>
</body>
</html>