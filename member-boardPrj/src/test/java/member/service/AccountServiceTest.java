package member.service;

import com.devunlimit.project.member.domain.dao.AccountDAO;
import com.devunlimit.project.member.domain.dto.MemberDTO;
import com.devunlimit.project.member.service.AccountService;
import com.devunlimit.project.member.service.serviceImpl.AccountServiceImpl;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mindrot.jbcrypt.BCrypt;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.naming.AuthenticationException;

import static org.junit.Assert.*;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration
public class AccountServiceTest {

  @Configuration
  static class AccountServiceTestContextConfiguration {

    @Bean
    public AccountService accountService() {
      return new AccountServiceImpl();
    }

    @Bean
    public AccountDAO accountRepository() {
      return Mockito.mock(AccountDAO.class);
    }
  }

  // We autowired the AccountService bean so that is it injected from the configuration.
  @Autowired
  private AccountService accountService;
  @Autowired
  private AccountDAO accountRepository;

  @Before
  public void setup() throws Exception {
    MemberDTO memberDTO = new MemberDTO("jyj", "vero", BCrypt.hashpw("1234", BCrypt.gensalt()),
        "1234", "9954");
    Mockito.when(accountRepository.findByUsername("vero")).thenReturn(memberDTO);

    MemberDTO memberDTOlog = new MemberDTO(10,"jyj", "vero", BCrypt.hashpw("1234", BCrypt.gensalt()),
        "1234", "9954");
    Mockito.when(accountRepository.findByUsername("verolog")).thenReturn(memberDTO);

    // 아이디가 잠겨있을 경우
    Mockito.when(accountRepository.isAccountLock(10)).thenReturn("Y");
  }

  // 아이디 잘못 입력함
  @Test(expected = AuthenticationException.class)
  public void testLoginIdFailure() throws AuthenticationException {
    assertEquals(accountService.login("fail", "1234").get("status"), "400");
  }

  // 비밀번호 잘못 입력함 -> 로그에 기록해야 함
  @Test(expected = AuthenticationException.class)
  public void testLoginPassFailure() throws AuthenticationException {
    assertEquals(accountService.login("vero", "fail").get("status"), "400");
  }

  // 아이디가 잠겨있는 10번 회원이 로그인을 시도했음
  @Test(expected = AuthenticationException.class)
  public void testLoginAccountLocked() throws AuthenticationException {
    assertEquals(accountService.login("verolog", "fail").get("status"), "400");
    assertEquals(accountService.login("verolog", "fail").get("message"), "accountLocked");
  }


  // 로그인 성공
  @Test()
  public void testLoginSuccess() throws AuthenticationException {
    assertEquals(accountService.login("vero", "1234").get("status"), "200");
  }

}
