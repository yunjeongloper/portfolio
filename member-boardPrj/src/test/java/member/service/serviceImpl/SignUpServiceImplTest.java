package member.service.serviceImpl;

import com.devunlimit.project.member.domain.dao.SignUpDAO;
import com.devunlimit.project.member.domain.dto.MemberDTO;
import com.devunlimit.project.member.service.SignUpService;
import com.devunlimit.project.member.service.serviceImpl.SignUpServiceImpl;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mindrot.jbcrypt.BCrypt;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;

import static org.junit.Assert.*;

@RunWith(MockitoJUnitRunner.class)
public class SignUpServiceImplTest {

  @Mock
  private SignUpDAO signUpDAO = Mockito.mock(SignUpDAO.class);

  @InjectMocks
  private SignUpService signUpService = new SignUpServiceImpl();

  MemberDTO memberDTO = new MemberDTO("박근호", "1234", "123", "123", "010-7723-8677");

  String check = BCrypt.hashpw("시발테스트입니다.", BCrypt.gensalt());

  @Before
  public void setup() {

    //아이디가 있을 때
    Mockito.when(signUpDAO.checkId("test1")).thenReturn(1);
    //아이디가 없을 때
    Mockito.when(signUpDAO.checkId("qwrwqr")).thenReturn(0);

    //아이디가 잘못 들어 왔을 때
    Mockito.when(signUpDAO.checkId("")).thenReturn(0);

    //회원 가입 정상 처리 시
    Mockito.when(signUpDAO.signUp(memberDTO)).thenReturn(1);

  }

  //아이디 중복체크
  @Test
  public void checkId() {

    //아이디가 있을때
    assertEquals(signUpService.checkId("test1").get("status"), "400");

    //아이디가 없을 때
    assertEquals(signUpService.checkId("qwrwqr").get("status"), "200");

    //아이디가 잘못 들어 왔을 때
    assertEquals(signUpService.checkId("").get("status"), "400");
    assertEquals(signUpService.checkId("").get("message"), "아이디를 입력해 주세요");

  }

  //회원가입 성공
  @Test
  public void signUpSuccess() {
    assertEquals(signUpService.signUp(memberDTO), 1);
  }

  //받아 오는정보에서 아이디가 없을시
  @Test(expected = IllegalStateException.class)
  public void signUpIdFail() {
    signUpService.signUp(new MemberDTO("박근호", "", "123", "123", "010-7723-8677"));
  }

  //받아 오는정보에서 비밀번호가 미일치시
  @Test(expected = IllegalStateException.class)
  public void signUpPwdFail() {
    signUpService.signUp(new MemberDTO("박근호", "123", "12214", "1234", "010-7723-8677"));
  }

  //받아 오는정보에서 이름이 없을시
  @Test(expected = IllegalStateException.class)
  public void signUpNameFail() {
    signUpService.signUp(new MemberDTO("", "123", "123", "123", "010-7723-8677"));
  }

  //받아 오는정보에서 핸드폰번호가 없을시
  @Test(expected = IllegalStateException.class)
  public void signUpPhoneFail() {
    signUpService.signUp(new MemberDTO("124", "123", "123", "123", ""));
  }

  //이름 값 길이가  최대값을 넘엇을 때
  @Test(expected = IllegalStateException.class)
  public void signUpNameLengthFail() {
    signUpService.signUp(new MemberDTO("12341234121", "123", "123", "123", "010-7723-8677"));
  }

  //아이디 값 길이가  최대값을 넘엇을 때
  @Test(expected = IllegalStateException.class)
  public void signUpIdLengthFail() {
    signUpService.signUp(new MemberDTO("박근호", "12341234121", "123", "123", "010-7723-8677"));
  }

  //비밀번호 값 길이가 최대값을 넘엇을 때
  @Test(expected = IllegalStateException.class)
  public void signUpPwdLengthFail() {
    signUpService.signUp(new MemberDTO("박근호", "1234", "012345678901234567891", "012345678901234567891", "010-7723-8677"));
  }

  //핸드폰 값 길이가  최대값을 넘엇을 때
  @Test(expected = IllegalStateException.class)
  public void signUpPhoneLengthFail() {
    signUpService.signUp(new MemberDTO("박근호", "1234", "1234", "1234", "010-7723-8677111"));
  }

  //암호화 테스트
  @Test
  public void changePwd() {
    boolean test = BCrypt.checkpw("시발테스트입니다.",check);
    assertEquals(true,test);
  }


}
