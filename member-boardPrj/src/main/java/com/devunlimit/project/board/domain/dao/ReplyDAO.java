package com.devunlimit.project.board.domain.dao;

import com.devunlimit.project.board.domain.dto.ReplyDTO;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ReplyDAO {

  List<ReplyDTO> selectList(@Param("boardNum") String boardNum);

  int insertReply(@Param("reply") ReplyDTO replyDTO);

  int updateReplyParents(@Param("replyNo") String replyNo);

  int deleteReply(@Param("no") String no);

  int deleteUpdate(@Param("no") String no);

  int updateReply(@Param("no") String replyNo, @Param("content") String reContent);

  int deletedReplyNum(@Param("boardNum") String boardNum);

}
