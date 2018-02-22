package member.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/config/spring/dispatcher-servlet.xml", "file:src/main/webapp/WEB-INF/config/context-common.xml", "file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@Transactional
@ActiveProfiles("dev")
public class SignUpControllerMVCTest {

  @Autowired
  private WebApplicationContext context;

  private MockMvc mock;

  @Before
  public void setup() {
    mock = MockMvcBuilders.webAppContextSetup(context).build();
  }

  // 폼 양식
  @Test
  public void form() throws Exception {
    mock.perform(get("/signup.do")) // 확인 할 주소값
      .andExpect(status().isOk()) //해당 주소로 들어 갔을때 반환되는 상태값
      .andExpect(view().name("member/sign Up")); // 반환하는뷰 값이 이거냐
  }

  //아이디가 존재 할 경우
  @Test
  public void checkId_Duplicate() throws Exception {
    checkId("테스트", "400");
  }

  //아이디값이 없을 경우
  @Test
  public void checkId_idNull() throws Exception {
    checkId("", "400");
  }

  //아이디를 사용할 수 있을 경우
  @Test
  public void checkId_ok() throws Exception {
    checkId("1", "200");
  }

  // 회원가입이 정상적으로 실행 될 경우
  @Test
  public void signUp_success() throws Exception {
    signCheck("test","박근호","1234","1234","010-7723-8677","200");
  }

  // 회원가입중 오류가 발생했을 경우
  @Test
  public void signUp_fail() throws Exception {
    signCheck("","id","1234","1234","010-7723-8677","400");
    signCheck("123","","1234","1234","010-7723-8677","400");
    signCheck("123","id","12344","1234","010-7723-8677","400");
    signCheck("123","id","1234","1234","","400");
  }

  private void signCheck(String id, String name,String pwd,String pwd_Ok,String phone,String status) throws Exception {
    mock.perform(post("/signup.do")
      .param("name", name)
      .param("id", id)
      .param("pwd", pwd)
      .param("pwd_Ok", pwd_Ok)
      .param("phone", phone))
      .andExpect(jsonPath("$.status").value(status));
  }

  private void checkId(String id, String status) throws Exception {
    mock.perform(post("/checkId.do").param("id", id))
        .andExpect(jsonPath("$.status").value(status));
  }

}
