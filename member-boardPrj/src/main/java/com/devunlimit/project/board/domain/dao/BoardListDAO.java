package com.devunlimit.project.board.domain.dao;

import com.devunlimit.project.board.domain.dto.BoardDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BoardListDAO {
    List<BoardDTO> selectLIst(@Param("start") int start, @Param("displayDataCount") int displayDataCount,
                              @Param("searchType") String searchType, @Param("searchData") String searchData);

    int totalCount(@Param("searchType") String searchType, @Param("searchData") String searchData);

    List<BoardDTO> noticeList();
}
