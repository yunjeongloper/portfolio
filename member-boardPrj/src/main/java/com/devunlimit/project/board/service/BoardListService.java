package com.devunlimit.project.board.service;

import com.devunlimit.project.board.domain.dto.BoardDTO;

import java.util.List;

public interface BoardListService {
    List<BoardDTO> selectList(int start , int displayDataCount, String searchType, String searchData);

    int totalCount(String searchType, String searchData);

    List<BoardDTO> noticeList();
}
