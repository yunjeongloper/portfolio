package com.devunlimit.project.board.service;

import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import java.util.List;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.IOException;

public interface BoardCreateService {

  String insertBoard(BoardDTO boardDTO, String parentsNo, MultipartHttpServletRequest request) throws IOException;

  BoardFileDTO insertImage(MultipartHttpServletRequest multipartHttpServletRequest) throws IOException;

  int updateFileNo(String boardNo, String fileNo);
}
