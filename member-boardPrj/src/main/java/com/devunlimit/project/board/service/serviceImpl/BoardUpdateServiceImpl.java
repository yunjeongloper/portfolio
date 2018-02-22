package com.devunlimit.project.board.service.serviceImpl;

import com.devunlimit.project.board.domain.dao.BoardCreateDAO;
import com.devunlimit.project.board.domain.dao.BoardUpdateDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import com.devunlimit.project.board.service.BoardUpdateService;
import com.devunlimit.project.member.domain.dao.AccountDAO;
import com.devunlimit.project.member.domain.dto.MemberDTO;
import com.devunlimit.project.util.UploadUtil;
import java.io.IOException;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Service
public class BoardUpdateServiceImpl implements BoardUpdateService {

  @Autowired
  private BoardUpdateDAO boardUpdateDAO;

  @Autowired
  private BoardCreateDAO boardCreateDAO;

  private UploadUtil uploadUtil = new UploadUtil();

  @Override
  public int updateBoard(BoardDTO boardDTO,MultipartHttpServletRequest request) throws IOException {
    List<BoardFileDTO> list = uploadUtil.upload(request, boardDTO.getNo());
    for (int i = 0; i < list.size(); i++) {
      boardCreateDAO.insertFile(list.get(i));
    }
    return boardUpdateDAO.updateBoard(boardDTO);
  }

  @Override
  public int defaultChangeDelete(String boardNum) {
    return boardUpdateDAO.defaultChangeDelete(boardNum);
  }

  @Override
  public int usingFile(String boardNum, String no) {
    return boardUpdateDAO.usingFile(boardNum,no);
  }

  @Override
  public String loginId(String no) {
    return boardUpdateDAO.longinUser(no);
  }
}
