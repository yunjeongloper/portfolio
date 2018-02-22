package board.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/config/spring/dispatcher-servlet.xml",
    "file:src/main/webapp/WEB-INF/config/context-common.xml",
    "file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@Transactional
@ActiveProfiles("dev")
public class BoardDeleteControllerTest {

	@Autowired
	private WebApplicationContext context;
	
	private MockMvc mockMvc;
	
	@Autowired
	MockHttpSession session;
	
	@Before
	public void setUp(){
		session.setAttribute("memberNo", 20);
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}
	
	@Test
	public void testBoardDeleteController() throws Exception{//게시물 삭제 컨트롤러 테스트

		mockMvc.perform(get("/board/delete.do")
				.session(session)
				.param("no", "3")
				.param("pagae", "1")
				.param("searchData", "1")
				.param("searchType", "1"))
				.andExpect(status().isMovedTemporarily())
				.andExpect(view().name("redirect:/board/list.do"));
	}

}
