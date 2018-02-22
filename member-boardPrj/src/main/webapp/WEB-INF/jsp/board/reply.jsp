<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<br>

댓글 ${listLength - deletedNum}

<style>
    hr.hr-style {
        border: 0;
        border-bottom: 1px dashed #ccc;
        background: #999;
    }
</style>


<div style="margin:15px">

    <c:forEach items="${replyDTOList2}" var="reply">

        <!-- 댓글 하나 -->
        <c:choose>

            <c:when test="${reply.no != reply.parents_no }">
            <hr class="hr-style">
            <div style="margin-left:30px">
                <form name="comm">
                <div>
                <i class="material-icons" style="font-size: 13px; float:left;">&#xe5da;</i>
            </c:when>

            <c:when test="${reply.no == reply.parents_no && reply.delete_ok == '1' && reply.re_re >= 2}">
            <hr class="hr-style">
                삭제된 댓글입니다.
            <div style="display:none;">
                <form name="comm">
                <div>
            </c:when>

            <c:when test="${reply.no == reply.parents_no && reply.delete_ok == '1' && reply.re_re < 2}">
            <div style="display:none;">
                <form name="comm">
                <div>
            </c:when>

            <c:otherwise>
            <hr class="hr-style">
            <div>
                <form name="comm">
                <div>
            </c:otherwise>

        </c:choose>
                    <div value="${reply.parents_no}">

                        <span style="font-size: 20px;">${reply.writer}</span>
                        <span style="margin-left: 15px; "> <fmt:formatDate value="${reply.write_date}" pattern="yyyy-MM-dd HH:mm" /> </span>

                        <c:if test="${reply.no == reply.parents_no}">
                            <label class="addReply">
                                <i class="material-icons" style="font-size: 10px">&#xe5da;</i>
                                <span>답글 달기</span>
                                <input type="hidden" name="check" value="0">
                                <input type="hidden" name="parents" value="${reply.parents_no}">
                            </label>
                        </c:if>

                        <c:if test="${reply.writer_no eq memberNo}">
                            <label data="${reply.no}" class="update-btn" style="float: right; margin-left: 10px;">
                                <span >
                                    수정
                                </span>
                                <input type="hidden" name="updateCk" id="updateCk" value="0">
                            </label>
                            <label data="${reply.no}" class="delete-btn" style="float: right; margin-left: 10px;">
                            <span>
                                삭제
                            </span>
                            </label>
                        </c:if>

                    </div>
                </div>

                <!-- 내용 -->
                <div class="content">
                        <span> ${reply.content}</span>
                </div>

            </form>
        </div>


    </c:forEach>

    <hr class="hr-style">

    <!-- 입력칸 -->
    <div id="reply">
        <div>
            <form name="form" onsubmit="return false" action="/board/replyInsert.do">

                <table style="width: 100%">
                    <tr>
                        <td>
                            <textarea name="content" style="width: 100%;resize: none" rows="4"></textarea>
                        </td>
                        <td width="10%">
                            <button  name="replybtn" style="margin-left: 10px;" class="btn btn-info"
                                    >등록
                            </button>
                        </td>
                    </tr>
                </table>
                <input type="hidden" name="writer" value="${memberNo}">
                <input type="hidden" name="parents_no" value="0">
                <input type="hidden" name="board_no" value="${boardNum}">
                <input type="hidden" name="no">

            </form>
        </div>
    </div>

</div>

<script src="/resources/js/jquery-3.2.1.min.js"></script>
<script src="/resources/js/bootstrap/bootstrap.min.js"></script>
<script src="/resources/js/app.min.js"></script>
<script src="/resources/summernote/summernote.js"></script>
<script src="/resources/js/stringBuffer.js"></script>
<script>

  $(document).on('click','button[name=replybtn]',function () {
    url = $(this).closest('form').attr('action');
    var queryString = $(this).closest('form').serialize();
    $.ajax({
      url: url,
      type: 'get',
      data: queryString,
      success: function (data) {
        window.location.reload();
      }
    })
  });

  $('.addReply').on('click', function () {
    var parentsNo = $(this).find('[name=parents]').val();
    var t = $(this).closest('form').closest('div');
    var check = $(this).find('[name=check]');
    if (check.val() == 0) {
      t.append('<hr class="hr-style reply-line">');
      t.append($('#reply').children('div').html());
      var addchildForm = t.children('[name=form]');
      addchildForm.children('[name=parents_no]').val(parentsNo);
      addchildForm.find('tr').prepend('<td width="30px"><i class="material-icons" style="margin-left: 15px;font-size: 20px">&#xe5da;</i></td>');
      check.val(1);
      $(this).find('span').text("답글 취소");
    } else {
      t.children('.reply-line').remove();
      t.children('[name=form]').remove();
      check.val(0);
      $(this).find('span').text("답글 달기");
    }
  });

  $('.update-btn').on('click',function () {
    var update = $(this).find('[name=updateCk]');
    var content = $(this).closest('form').closest('div').find('.content');
    var no = $(this).attr('data');

    if(update.val()==0) {
      update.val(1);
      $(this).find('span').text("수정 취소");
      content.find('span').css('display','none');
      content.append($('#reply').children('div').html());
      var contentForm = content.children('[name=form]');
      contentForm.attr('action','/board/replyUpdate.do');

      // 테스트/

      contentForm.children('[name=no]').val(no);
      contentForm.find('textarea').val(content.find('span').text());
      contentForm.find('button').text("수정");
      console.log(contentForm.children('[name=no]').val());
    } else {
      $(this).find('span').text("수정");
      update.val(0);
      content.children('[name=form]').remove();
      content.find('span').css('display','block');
    }
  });

  $('.delete-btn').on('click',function () {
    var no = $(this).attr('data');
    var change = confirm("정말 댓글을 삭제하시겠습니까?");
    if (change) {
      $.ajax({
        url: '/board/replyDelete.do',
        type: 'post',
        data: {no: no},
        success: function (data) {
          window.location.reload();
        }
      })
    }
  });

</script>