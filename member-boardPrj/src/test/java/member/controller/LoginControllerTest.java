package member.controller;


import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import com.devunlimit.project.admin.service.AdminService;
import com.devunlimit.project.member.controller.LoginController;
import com.devunlimit.project.member.domain.dto.MemberDTO;
import com.devunlimit.project.member.service.AccountService;
import java.util.HashMap;
import java.util.Map;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration
public class LoginControllerTest {

  private MemberDTO memberDTO;

  @Autowired
  private LoginController loginController;

  @Autowired
  private AccountService accountService;

  @Before
  public void setup() throws Exception {

    // 초기 로그인 시 테스트 Mockito
    Map<String, String> status = new HashMap<>();
    status.put("status", "200");
    status.put("memberNo", "1");
    Mockito.when(this.accountService.login("yj", "1234")).thenReturn(status);

    // 중복 로그인 시 테스트 Mockito
    Map<String, String> sessStatus = new HashMap<>();
    sessStatus.put("sessInfo", "used");
    Mockito.when(this.accountService.login("used", "1234")).thenReturn(sessStatus);
  }

  // 로그인 페이지로의 이동 테스트
  @Test
  public void testHandleLogin() throws Exception {
    MockMvc mockMvc = MockMvcBuilders.standaloneSetup(this.loginController).build();

    mockMvc.perform(post("/loginform.do"))
        .andDo(print())
        .andExpect(status().isOk())
        .andExpect(view().name("member/login"));
  }

  // 로그인 기능 실행 & 세션 값 할당 테스트
  @Test
  public void testHandleLoginSess() throws Exception {
    MockMvc mockMvc = MockMvcBuilders.standaloneSetup(this.loginController).build();
    mockMvc.perform(post("/login.do")
        .param("id", "yj")
        .param("pass", "1234"))
        .andDo(print())
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.status").value("200"))
        .andReturn();
  }

  @Test
  public void testHandleLogoutSess() throws Exception {
    MockMvc mockMvc = MockMvcBuilders.standaloneSetup(this.loginController).build();
    mockMvc.perform(post("/logout.do")
        .param("id", "used")
        .param("pass", "1234"))
        .andDo(print())
        .andExpect(status().isMovedTemporarily())
        .andReturn();
  }


  @Configuration
  public static class LoginControllerTestConfiguration {

    @Bean
    public LoginController loginController() {

      return new LoginController();
    }

    @Bean
    public AccountService accountService() {

      return Mockito.mock(AccountService.class);
    }

    @Bean
    public AdminService adminService() {
      return Mockito.mock(AdminService.class);
    }
  }
}
