package board.service.serviceImpl;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.fail;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import com.devunlimit.project.board.domain.dao.ReplyDAO;
import com.devunlimit.project.board.domain.dto.ReplyDTO;
import com.devunlimit.project.board.service.ReplyService;
import com.devunlimit.project.board.service.serviceImpl.ReplyServiceImpl;
import com.devunlimit.project.board.service.serviceImpl.ReplyServiceImpl.DeleteReplyErrorException;
import com.devunlimit.project.board.service.serviceImpl.ReplyServiceImpl.InsertReplyErrorException;
import com.devunlimit.project.board.service.serviceImpl.ReplyServiceImpl.UpdateReplyErrorException;
import java.util.ArrayList;
import java.util.List;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration
public class ReplyServiceImplTest {

  @Configuration
  static class ReplyServiceTestContextConfiguration {

    @Bean
    public ReplyService replyService() {
      return new ReplyServiceImpl();
    }

    @Bean
    public ReplyDAO replyDAO() {
      return mock(ReplyDAO.class);
    }
  }

  @Autowired
  ReplyService replyService;

  @Autowired
  ReplyDAO replyDAO;

  String boardNo = "3";

  String replyNo = "1";

  String reContent = "수정테스트";

  ReplyDTO replyDTO = new ReplyDTO(replyNo, "3", "하하하", "72", "1");


  // insertReply -------------------------------------------------------------------------------------------


  private void whenInsertParamsIllegal(String board_no, String content, String writer,
      String parents_no) {

    runInsertParamsAssertEx(board_no, content, writer, parents_no, IllegalStateException.class);
  }

  private void whenInsertParamsNull(String board_no, String content, String writer,
      String parents_no) {

    runInsertParamsAssertEx(board_no, content, writer, parents_no, NullPointerException.class);
  }

  private void whenInsertParamsInvalid(String board_no, String content, String writer,
      String parents_no) {

    runInsertParamsAssertEx(board_no, content, writer, parents_no, InsertReplyErrorException.class);
  }

  private void runInsertParamsAssertEx(String board_no, String content, String writer,
      String parents_no, Class<? extends RuntimeException> exceptionType) {

    Exception thrownEx = null;
    try {
      replyService.insertReply(new ReplyDTO(board_no, content, writer, parents_no));
      fail();
    } catch (Exception ex) {
      thrownEx = ex;
    }
    assertThat(thrownEx, instanceOf(exceptionType));
  }

  // 글번호가 비정상인 경우 (쉬운, 정상에서 벗어난)
  // 내용이 비정상인 경우 (쉬운, 정상에서 벗어난)
  // 작성자번호가 비정상인 경우 (쉬운, 정상에서 벗어난)
  // 부모번호 비정상인 경우 (쉬운, 정상에서 벗어난)
  @Test
  public void insertReplyIllegalFailTest() {

    whenInsertParamsIllegal("", "글번호오류", "72", "1");
    whenInsertParamsIllegal("3", "", "72", "1");
    whenInsertParamsIllegal("3", "작성자번호오류", "", "1");
    whenInsertParamsIllegal("3", "부모번호오류", "72", "");
  }

  @Test
  public void insertReplyNullFailTest() {

    whenInsertParamsNull(null, "글번호오류", "72", "1");
    whenInsertParamsNull("3", null, "72", "1");
    whenInsertParamsNull("3", "작성자번호오류", null, "1");
    whenInsertParamsNull("3", "부모번호오류", "72", null);
  }

  // 게시글번호가 존재하지 않는 경우(정상에서 벗어난)
  // 작성자번호가 존재하지 않는 경우(정상에서 벗어난)
  // 부모번호가 존재하지 않는 경우(정상에서 벗어난)
  @Test
  public void insertReplyInvalidFailTest() {

    whenInsertParamsInvalid("22222234334334343433", "글번호오류", "72", "0");
    whenInsertParamsInvalid("30", "작성자번호오류", "2222223434343433", "0");
    whenInsertParamsInvalid("30", "부모번호오류", "74", "2222223434343433");
  }

  // 댓글 삽입 성공
  @Test
  public void insertReplySuccessTest() {

    // 댓글 등록 성공시
    when(replyDAO.insertReply(replyDTO)).thenReturn(1);
    when(replyDAO.updateReplyParents(replyNo)).thenReturn(1);

    assertThat(replyDAO.insertReply(replyDTO), is(1));
  }


  // selectList -------------------------------------------------------------------------------------------


  // 게시판 번호 비정상 (Illegal)
  @Test(expected = IllegalStateException.class)
  public void selectListBoardNoIllegalTest() {

    replyService.selectList("");
  }

  // 게시판 번호 비정상 (Null)
  @Test(expected = NullPointerException.class)
  public void selectListBoardNoNullTest() {

    replyService.selectList(null);
  }

  // 댓글 조회 성공
  @Test()
  public void selectListSuccessTest() {

    // 댓글 리스트 조회시
    List<ReplyDTO> replyDTOList = new ArrayList<>();
    replyDTOList.add(replyDTO);
    when(replyDAO.selectList(boardNo)).thenReturn(replyDTOList);

    assertThat(replyService.selectList(boardNo), is(replyDTOList));
  }


  // deleteReply -------------------------------------------------------------------------------------------


  // 댓글 번호 비정상 (Illegal)
  @Test(expected = IllegalStateException.class)
  public void deleteReplyIllegalTest() {

    replyService.deleteReply("");
  }

  // 댓글 번호 비정상 (Null)
  @Test(expected = NullPointerException.class)
  public void deleteReplyNullTest() {

    replyService.deleteReply(null);
  }

  // 일치하는 댓글 존재하지 않는 경우
  @Test(expected = DeleteReplyErrorException.class)
  public void deleteReplyInvalidTest() {

    replyService.deleteReply("3423423");
  }

  // 댓글 삭제 성공
  @Test()
  public void deleteReplySuccessTest() {

    // 댓글 삭제 성공시
    when(replyDAO.deleteReply(replyNo)).thenReturn(1);
    when(replyDAO.deleteUpdate(replyNo)).thenReturn(1);

    assertThat(replyService.deleteReply(replyNo), is(1));
  }


  // updateReply -------------------------------------------------------------------------------------------


  // 수정 내용 비정상 (Illegal)
  @Test(expected = IllegalStateException.class)
  public void updateReplyFailTest() {

    replyService.updateReply(replyNo, "");
  }

  // 수정 내용 비정상 (Null)
  @Test(expected = NullPointerException.class)
  public void updateReplyFailTest3() {

    replyService.updateReply(replyNo, null);
  }

  // 댓글 번호 비정상 (Illegal)
  @Test(expected = IllegalStateException.class)
  public void updateReplyFailTest2() {

    replyService.updateReply("", "하하하");
  }

  // 댓글 번호 비정상 (Null)
  @Test(expected = NullPointerException.class)
  public void updateReplyFailTest4() {

    replyService.updateReply(null, "하하하");
  }

  // 일치하는 댓글 존재하지 않는 경우
  @Test(expected = UpdateReplyErrorException.class)
  public void updateReplyFailTest5() {

    replyService.updateReply("3456789876543456", "하하하");
  }

  // 댓글 수정 성공
  @Test()
  public void updateReplySuccessTest() {

    // 댓글 수정 성공시
    when(replyDAO.updateReply(replyNo, reContent)).thenReturn(1);

    assertThat(replyService.updateReply(replyNo, reContent), is(1));
  }

}
