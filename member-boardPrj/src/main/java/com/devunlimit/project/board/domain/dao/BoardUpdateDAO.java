package com.devunlimit.project.board.domain.dao;

import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.member.domain.dto.MemberDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface BoardUpdateDAO {

  int updateBoard(@Param("board") BoardDTO boardDTO);

  int defaultChangeDelete(@Param("boardNum") String boardNum);

  int usingFile(@Param("boardNum") String boardNum, @Param("no") String no);

  String longinUser(@Param("no") String no);

}
