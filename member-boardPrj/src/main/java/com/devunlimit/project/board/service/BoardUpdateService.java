package com.devunlimit.project.board.service;

import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.member.domain.dto.MemberDTO;
import java.io.IOException;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface BoardUpdateService {

  int updateBoard(BoardDTO boardDTO,MultipartHttpServletRequest request) throws IOException;

  int defaultChangeDelete(String boardNum);

  int usingFile(String boardNum, String no);

  String loginId(String id);

}
