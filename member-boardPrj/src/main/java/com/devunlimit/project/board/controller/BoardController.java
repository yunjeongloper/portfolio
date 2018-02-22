package com.devunlimit.project.board.controller;

import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import com.devunlimit.project.board.service.BoardCreateService;
import com.devunlimit.project.board.service.BoardDeleteService;
import com.devunlimit.project.board.service.BoardListService;
import com.devunlimit.project.board.service.BoardUpdateService;
import com.devunlimit.project.boardDetail.service.BoardDetailService;
import com.devunlimit.project.util.PageUtil;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class BoardController {

  @Autowired
  private BoardListService boardListService;

  @Autowired
  private BoardCreateService boardCreateService;

  @Autowired
  private BoardDeleteService boardDeleteService;

  @Autowired
  private BoardDetailService boardDetailService;

  @Autowired
  private BoardUpdateService boardUpdateService;

  @RequestMapping(value = "/create.do", method = RequestMethod.GET)
  public ModelAndView create(@RequestParam(value = "boardNum", required = false) String boardNum,
      HttpSession session) {

    ModelAndView mav = new ModelAndView();

    mav.setViewName("board/create");
    mav.addObject("parentsNo",boardNum);
    mav.addObject("userId",boardUpdateService.loginId(session.getAttribute("memberNo").toString()));
    return mav;

  }

  @RequestMapping(value = "/create.do", method = RequestMethod.POST)
  @ResponseBody
  public Map create_ok(MultipartHttpServletRequest multipartReq, HttpSession session) {

    String subject = multipartReq.getParameter("subject");
    String content = multipartReq.getParameter("content");
    String notice = multipartReq.getParameter("checkNotice");
    String parents = multipartReq.getParameter("parentsNo");
    String[] filesNo = multipartReq.getParameter("image").split(",");

    BoardDTO boardDTO;

    Map<String, String> result = new HashMap<>();
    result.put("result", "200");

    if (subject.length() != 0 && !subject.equals("") && content.length() != 0 && !content.equals("")) {

      if (notice.equals("true")) {
        boardDTO = new BoardDTO(subject, content, session.getAttribute("memberNo").toString(),
            true);
      } else {
        boardDTO = new BoardDTO(subject, content, session.getAttribute("memberNo").toString(),
            false);
      }
      try {
        boardCreateService.insertBoard(boardDTO, parents, multipartReq);
      } catch (IOException e) {
        result.put("result", "400");
      }

      for(String fileNo : filesNo) {
        boardCreateService.updateFileNo(boardDTO.getNo(),fileNo);
      }


    } else {
      result.put("result", "400");
    }
    return result;
  }

  @RequestMapping(value = "/list.do", method = RequestMethod.GET)
  public ModelAndView list(PageUtil pageUtil, String searchType, String searchData,
      HttpSession session) {

    ModelAndView mav = new ModelAndView();

    pageUtil.pageCalculate(boardListService.totalCount(searchType, searchData));

    mav.addObject("noticeList", boardListService.noticeList());
    mav.addObject("pageUtil", pageUtil);
    mav.addObject("searchData", searchData);
    mav.addObject("searchType", searchType);
    mav.addObject("boardList", boardListService
        .selectList(pageUtil.getRowStart(), pageUtil.getDisplayRowCount(), searchType, searchData));
    mav.addObject("userId",boardUpdateService.loginId(session.getAttribute("memberNo").toString()));
    mav.setViewName("board/list");

    return mav;

  }

  @RequestMapping(value = "/delete.do", method = RequestMethod.GET)
  public ModelAndView delete(String no, Integer page, String searchType, String searchData) {
    ModelAndView mav = new ModelAndView("redirect:/board/list.do");

    boardDeleteService.delete(no);
    
    //답글이 없는 경우만 실행해야 함
    //boardDeleteService.imgDelete(no);
    
    mav.addObject("page", page);
    mav.addObject("searchData", searchData);
    mav.addObject("searchType", searchType);

    return mav;
  }

  @RequestMapping(value = "/imageUpload.do", method = RequestMethod.POST)
  @ResponseBody
  public BoardFileDTO imageUpload(MultipartHttpServletRequest multipartHttpServletRequest)
      throws IOException {

    Map<String, String> fileNum = new HashMap<>();

    BoardFileDTO boardFileDTO = boardCreateService.insertImage(multipartHttpServletRequest);

    return boardFileDTO;
  }

  @RequestMapping(value = "/modify.do",method = RequestMethod.GET)
  public ModelAndView update(@Param("boardNum") String boardNum,HttpSession session)
      throws Exception {

    ModelAndView mav = new ModelAndView();

    //상세게시물조회
    BoardDTO boardDetail = boardDetailService.selectBoardDetail(boardNum);

    List<BoardFileDTO> fileList = boardDetailService.selectUploadFile(boardNum);

    // 첨부파일 기본 값 삭제로 변경
    boardUpdateService.defaultChangeDelete(boardNum);

    mav.addObject("board",boardDetail);
    mav.addObject("parentsNo",boardDetail.getParents_no());
    mav.addObject("fileList",fileList);
    mav.addObject("userId",boardUpdateService.loginId(session.getAttribute("memberNo").toString()));

    mav.setViewName("board/create");

    return mav;
  }

  @RequestMapping(value = "/modify.do",method = RequestMethod.POST)
  @ResponseBody
  public Map update_ok(BoardDTO boardDTO,@RequestParam(value = "checkNotice",required = false) String notice,
      MultipartHttpServletRequest request) {

    String[] usingFile = request.getParameter("fileList").split(",");

    Map<String,String> result = new HashMap<>();

    if (notice.equals("true")) {
      boardDTO.setNotice(true);
    } else {
      boardDTO.setNotice(false);
    }

    result.put("result","200");
    try {
      boardUpdateService.updateBoard(boardDTO,request);
      for(String fileNo : usingFile) {
        boardUpdateService.usingFile(boardDTO.getNo(),fileNo);

      }
    } catch (Exception e) {
      result.put("result","400");
    }

    return result;

  }
}
