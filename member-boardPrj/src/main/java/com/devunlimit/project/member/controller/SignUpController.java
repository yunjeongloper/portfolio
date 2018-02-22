package com.devunlimit.project.member.controller;

import com.devunlimit.project.member.domain.dto.MemberDTO;
import com.devunlimit.project.member.service.SignUpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

@Controller
public class SignUpController {


  @Autowired
  SignUpService signUpService;

  @RequestMapping(value = "/signup.do", method = RequestMethod.GET)
  public ModelAndView form() {
    ModelAndView mav = new ModelAndView();
    mav.setViewName("member/sign Up");
    return mav;
  }

  @RequestMapping(value = "/signup.do", method = RequestMethod.POST)
  @ResponseBody
  public Map signUp(@ModelAttribute MemberDTO memberDTO) {

    Map<String, String> status = new HashMap<>();
    status.put("status", "200");
    status.put("message", "회원가입이 완료되었습니다.");

    try {
      signUpService.signUp(memberDTO);
    } catch (IllegalStateException failLength) {

      status.put("status","400");
      status.put("message",failLength.getMessage());
    }
    return status;
  }

  @RequestMapping(value = "/checkId.do", method = RequestMethod.POST)
  @ResponseBody
  public Map checkId(@RequestParam("id") String id) {
    return signUpService.checkId(id);
  }
}


