package com.devunlimit.project.board.domain.dao;

import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface BoardCreateDAO {

  int insertBoard(@Param("board") BoardDTO boardDTO);

  int updateBoardParents(@Param("boardNo") String boardNo, @Param("parentsNo") String parentsNo);

  int insertFile(@Param("file") BoardFileDTO boardFileDTO);

  int insertImage(@Param("file") BoardFileDTO boardFileDTO);

  int updateFileNo(@Param("boardNo") String boardNo, @Param("no") String no);
}
