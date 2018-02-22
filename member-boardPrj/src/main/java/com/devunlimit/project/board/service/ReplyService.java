package com.devunlimit.project.board.service;

import com.devunlimit.project.board.domain.dto.ReplyDTO;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ReplyService {

  List<ReplyDTO> selectList(String boardNum);

  int insertReply(ReplyDTO replyDTO);

  int deleteReply(String no);

  int updateReply(String no, String content);

  int deletedReplyNum(String boardNum);

}
