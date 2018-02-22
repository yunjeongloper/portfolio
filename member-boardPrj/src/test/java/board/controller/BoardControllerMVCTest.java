package board.controller;

import com.devunlimit.project.board.domain.dto.BoardDTO;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.fileUpload;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/config/spring/dispatcher-servlet.xml",
    "file:src/main/webapp/WEB-INF/config/context-common.xml",
    "file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@ActiveProfiles("dev")
@Transactional
public class BoardControllerMVCTest {

  @Autowired
  private WebApplicationContext context;

  private MockMvc mock;

  @Autowired
  MockHttpSession session;

  @Before
  public void setup() {
    session.setAttribute("memberNo", 20);
    mock = MockMvcBuilders.webAppContextSetup(context).build();
  }

  //게시물 등록 뷰 체크
  @Test
  public void create() throws Exception {

    mock.perform(get("/board/create.do").session(session)).andExpect(status().isOk())
        .andExpect(view().name("board/create"));

  }

  //게시물 정보 반환 체크
  @Test
  public void checkBoardList() throws Exception {

    MvcResult mvcResult = mock.perform(get("/board/list.do")
        .session(session)
        .param("page", "1")
        .param("searchData", "1번")
        .param("searchType", "1")).andExpect(status().isOk())
        .andExpect(model().attributeExists("boardList"))
        .andExpect(model().attributeExists("noticeList"))
        .andExpect(model().attributeExists("pageUtil")).andReturn();

    List<BoardDTO> checkList = (List<BoardDTO>) mvcResult.getModelAndView().getModel()
        .get("boardList");
    assertEquals(checkList.size(), 0);
  }

  //게시물 상세보기
  @Test
  public void boardDetail() throws Exception {

    mock.perform(get("/board/detailView.do")
        .session(session)
        .param("boardNum", "3"))
        .andExpect(status().isOk())
        .andExpect(view().name("board/detail"));

  }

  //게시물 등록 데이터 처리
  @Test
  public void boardCreate() throws Exception {

    MockMultipartFile firstFile = new MockMultipartFile("data.text", "", "text/plain",
        "qwrwrqrqr qwrqwr".getBytes());
    MockMultipartFile secondFile = new MockMultipartFile("data2.text", "", "text/plain",
        "1234r".getBytes());

    mock.perform(fileUpload("/board/create.do").file(firstFile).file(secondFile).session(session)
    .param("subject","test3").param("content","qwe")
            .param("wrtier","20").param("checkNotice","false")
        .param("image","{'30','31'")
    ).andExpect(status().isOk()) .andExpect(jsonPath("$.result").value("200"));

  }

  @Test
  public void imageUpload() throws Exception {

    MockMultipartFile firstFile = new MockMultipartFile("data.jpg", "", "image/jpeg",
        "qwrwrqrqr qwrqwr".getBytes());

    mock.perform(fileUpload("/board/imageUpload.do").file(firstFile).session(session))
        .andExpect(status().isOk()).andDo(MockMvcResultHandlers.print());

  }


}
