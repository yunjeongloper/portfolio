
package com.devunlimit.project.member.controller;

import com.devunlimit.project.admin.service.AdminService;
import com.devunlimit.project.member.service.AccountService;
import com.devunlimit.project.util.session.LoginManager;
import java.util.HashMap;
import java.util.Map;
import javax.naming.AuthenticationException;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {

  public static final String ACCOUNT_ATTRIBUTE = "account";

  private LoginManager loginManager = LoginManager.getInstance();

  @Autowired
  AccountService accountService;

  @Autowired
  AdminService adminService;

  // / 주소값 매핑
  @RequestMapping(value = "/", method = RequestMethod.GET)
  public String home() {

    return "redirect:/loginform.do";
  }

  // 로그인 페이지로의 이동
  @RequestMapping(value = "/loginform.do", method = {RequestMethod.GET, RequestMethod.POST})
  public ModelAndView handleLogin() {

    ModelAndView mav = new ModelAndView();

    mav.setViewName("member/login");

    return mav;
  }

  // 로그인 기능 실행 & 세션 값 할당
  @RequestMapping(value = "/login.do", method = RequestMethod.POST)
  @ResponseBody
  public Map handleLoginSess(@RequestParam String id, @RequestParam String pass,
      HttpSession session) throws AuthenticationException {

    // 전달받은 id와 password로 로그인. 성공시 객체 받아옴
    // MemberDTO memberDTO = this.accountService.login(id, pass);
    Map<String, String> status = new HashMap<>();

    status.put("status", "200");

    try {

      Map<String, String> serviceStatus = accountService.login(id, pass);

      String memberNo = serviceStatus.get("memberNo");

      session.setAttribute("memberNo", memberNo);

      if (loginManager.isUsing(memberNo)) {

        status.put("message", "duplicated");

        status.put("sessId", "memberNo");

      } else {

        loginManager.setSession(session, memberNo);

        status.put("message", "로그인 성공함");

      }

      //Bin area------------------------------------------------------------------------------------
      //로그인한 아이디가 관리자 인지 아닌지 확인
      if ((adminService.checkAdmin(id)) == 1) {
        //관리자 아이디일 경우 세션값 1
        session.setAttribute("authority",1);

      } else {
        //일반 아이디일 경우 세션값 0
        session.setAttribute("authority",0);

      }
      //--------------------------------------------------------------------------------------------

    } catch (AuthenticationException failLength) {

      status.put("status", "400");

      status.put("message", failLength.getMessage());

    }

    return status;

  }

  @RequestMapping(value = "/logout.do", method = {RequestMethod.GET, RequestMethod.POST})
  public ModelAndView logout(HttpSession session) {

    ModelAndView mav = new ModelAndView();

    String memberNo = (String) session.getAttribute("memberNo");
    // String memberNo = loginManager.getUserID(session);

    if (memberNo != null) {

      // 기존의 접속(세션)을 끊는다.
      loginManager.removeSession(memberNo);
    }

    mav.setViewName("redirect:/loginform.do");

    return mav;
  }

}