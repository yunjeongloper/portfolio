package com.devunlimit.project.board.controller;

import com.devunlimit.project.board.domain.dto.ReplyDTO;
import com.devunlimit.project.board.service.ReplyService;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/board")
public class ReplyController {

  @Autowired
  private ReplyService replyService;


  @RequestMapping(value = "/replyInsert.do", method = RequestMethod.GET)
  @ResponseBody
  public Map replyInsert(@ModelAttribute ReplyDTO replyDTO, HttpSession session, String boardNum) {

    Map<String, String> status = new HashMap<>();

    // default 999
    status.put("result", "999");

    try {

      // 성공하면 1
      int resultBoolean = replyService.insertReply(replyDTO);
      status.put("result", String.valueOf(resultBoolean));

    } catch (Exception failLength) {

      // 실패하면 0
      status.put("result", "0");
      status.put("errorMsg", failLength.toString());
    }

    return status;

  }


  @RequestMapping(value = "/replyDelete.do", method = RequestMethod.POST)
  @ResponseBody
  public Map replyDelete(@ModelAttribute("no") String no) {


    Map<String, String> status = new HashMap<>();

    // default 999
    status.put("result", "999");

    try {

      // 성공하면 1
      int resultBoolean = replyService.deleteReply(no);
      status.put("result", String.valueOf(resultBoolean));

    } catch (Exception failLength) {

      // 실패하면 0
      status.put("result", "0");
      status.put("errorMsg", failLength.toString());
    }

    return status;

  }


  @RequestMapping(value = "/replyUpdate.do", method = RequestMethod.GET)
  public ModelAndView replyUpdate(@ModelAttribute ReplyDTO replyDTO) {

    ModelAndView mav = new ModelAndView();

    try {

      // 성공하면 1
      int resultBoolean = replyService.updateReply(replyDTO.getNo(), replyDTO.getContent());
      mav.addObject("result", String.valueOf(resultBoolean));

    } catch (Exception failLength) {

      // 실패하면 0
      mav.addObject("result", "0");
      mav.addObject("message", failLength.toString());
    }

    mav.setViewName("board/detail");

    return mav;

  }

}
