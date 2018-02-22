package board.controller;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import com.devunlimit.project.board.service.serviceImpl.ReplyServiceImpl.DeleteReplyErrorException;
import java.sql.Date;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.jdbc.Null;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.WebApplicationContext;


@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/config/spring/dispatcher-servlet.xml", "file:src/main/webapp/WEB-INF/config/context-common.xml", "file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@Transactional
@ActiveProfiles("dev")
public class ReplyControllerTest {

  @Autowired
  private WebApplicationContext context;

  private MockMvc mock;

  private MockHttpSession session = new MockHttpSession();

  @Before
  public void setup() {

    mock = MockMvcBuilders.webAppContextSetup(context).build();

    session.setAttribute("memberNo","20");
  }


  // insertReply -------------------------------------------------------------------------------------------


  public void replyInsertTest(String board_no, String content, String writer, String parents_no, String result, String errorMsg) throws Exception {

    mock.perform(get("/board/replyInsert.do").session(session)
        .param("board_no", board_no)
        .param("content", content)
        .param("parents_no", parents_no)
        .param("writer", writer))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.result").value(result))
        .andExpect(jsonPath("$.errorMsg").value(errorMsg))
        .andDo(MockMvcResultHandlers.print());
  }

  @Test
  public void insertReply_fail() throws Exception {

    replyInsertTest("","하하하","72","0","0","java.lang.IllegalStateException: BoardNumError");
    replyInsertTest("3","","72","0","0","java.lang.IllegalStateException: ContentNullError");
    replyInsertTest("3","하하하","","0","0","java.lang.IllegalStateException: WriterNumError");
    replyInsertTest("3","하하하","72","","0","java.lang.IllegalStateException: ParentsNumError");
  }

  @Test
  public void insertReply_success() throws Exception {

    replyInsertTest("3","하하하","72","0","1",null);
  }


  // deleteReply -------------------------------------------------------------------------------------------


  @Test
  public void deleteReply_IllegalFail() throws Exception {

    mock.perform(post("/board/replyDelete.do").session(session)
        .param("no", ""))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.result").value("0"))
        .andExpect(jsonPath("$.errorMsg").value("java.lang.IllegalStateException"))
        .andDo(MockMvcResultHandlers.print());
  }

  @Test
  public void deleteReply_InvalidFail() throws Exception {

    mock.perform(post("/board/replyDelete.do").session(session)
        .param("no", "567894567"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.result").value("0"))
        .andExpect(jsonPath("$.errorMsg").value("com.devunlimit.project.board.service.serviceImpl.ReplyServiceImpl$DeleteReplyErrorException"))
        .andDo(MockMvcResultHandlers.print());
  }

  @Test
  public void deleteReply_success() throws Exception {

    mock.perform(post("/board/replyDelete.do").session(session)
        .param("no", "33"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.result").value("1"))
        .andDo(MockMvcResultHandlers.print());
  }


  // updateReply -------------------------------------------------------------------------------------------


  @Test
  public void updateReply_contentIllegalFail() throws Exception {

    mock.perform(get("/board/replyUpdate.do").session(session)
        .param("no", "77")
        .param("content",""))
        .andExpect(status().isOk())
        .andExpect(model().attribute("message", equalTo("java.lang.IllegalStateException")))
        .andDo(MockMvcResultHandlers.print());
  }

  @Test
  public void updateReply_replyNoIllegalFail() throws Exception {

    mock.perform(get("/board/replyUpdate.do").session(session)
        .param("no", "")
        .param("content","5678"))
        .andExpect(status().isOk())
        .andExpect(model().attribute("message", equalTo("java.lang.IllegalStateException")))
        .andDo(MockMvcResultHandlers.print());
  }

  @Test
  public void updateReply_replyNoInvalidFail() throws Exception {

    mock.perform(get("/board/replyUpdate.do").session(session)
        .param("no", "34567543234567")
        .param("content","댓글이 존재하지 않음"))
        .andExpect(status().isOk())
        .andExpect(model().attribute("message", equalTo("com.devunlimit.project.board.service.serviceImpl.ReplyServiceImpl$UpdateReplyErrorException")))
        .andDo(MockMvcResultHandlers.print());
  }

  @Test
  public void updateReply_success() throws Exception {

    mock.perform(get("/board/replyUpdate.do").session(session)
        .param("no", "33")
        .param("content","수정테스트"))
        .andExpect(status().isOk())
        .andDo(MockMvcResultHandlers.print());
  }


}
