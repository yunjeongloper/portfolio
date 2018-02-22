package com.devunlimit.project.board.service.serviceImpl;

import com.devunlimit.project.board.domain.dao.ReplyDAO;
import com.devunlimit.project.board.domain.dto.ReplyDTO;
import com.devunlimit.project.board.service.ReplyService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ReplyServiceImpl implements ReplyService {

  @Autowired
  private ReplyDAO replyDAO;

  @Override
  public List<ReplyDTO> selectList(String boardNum) {

    List<ReplyDTO> replyDTOList = null;

    if ( boardNum.length() == 0 || boardNum.isEmpty() ) {

      throw new IllegalStateException();

    } else {

      replyDTOList = replyDAO.selectList(boardNum);

    }

    return replyDTOList;
  }

  @Override
  public int insertReply(ReplyDTO replyDTO) {

    checkInfo(replyDTO);

    int insertResult = replyDAO.insertReply(replyDTO);
    int updateResult = 0;

    // replyDTO가 정상적으로 insert 됨
    if( insertResult == 1) {

      // replyDTO의 부모값 업데이트 함
      updateResult = replyDAO.updateReplyParents(replyDTO.getNo());

    } else {

      throw new InsertReplyErrorException();
    }

    return updateResult;
  }

  @Override
  public int deleteReply(String no) {

    int deleteResult = 0;

    if ( no.length() == 0 || no.isEmpty()) {

      throw new IllegalStateException();

    } else {

      deleteResult = replyDAO.deleteReply(no);

      if (deleteResult == 1) {

        replyDAO.deleteUpdate(no);

      } else {

        throw new DeleteReplyErrorException();
      }

    }
    return deleteResult;
  }

  @Override
  public int updateReply(String no, String content) {

    int updateResult = 0;

    if ( content.length() == 0 || content.isEmpty() || no.length() == 0 || no.isEmpty()) {

      throw new IllegalStateException();

    } else {

      updateResult = replyDAO.updateReply(no, content);

      if(updateResult == 1){

      } else {

        throw new UpdateReplyErrorException();
      }
    }

    return updateResult;
  }

  @Override
  public int deletedReplyNum(String boardNum) {

    return replyDAO.deletedReplyNum(boardNum);
  }

  // insert 데이터 유효성 검사
  private void checkInfo(ReplyDTO replyDTO) {
    if ( replyDTO.getBoard_no().length() == 0 || replyDTO.getBoard_no().isEmpty()) {
      throw new IllegalStateException("BoardNumError");
    } else if ( replyDTO.getContent().length() == 0 || replyDTO.getContent().isEmpty() ) {
      throw new IllegalStateException("ContentNullError");
    } else if ( replyDTO.getWriter().length() == 0 || replyDTO.getWriter().isEmpty()) {
      throw new IllegalStateException("WriterNumError");
    } else if ( replyDTO.getParents_no().length() == 0 || replyDTO.getParents_no().isEmpty()) {
      throw new IllegalStateException("ParentsNumError");
    }
  }

  public static class InsertReplyErrorException extends RuntimeException {

  }

  public static class DeleteReplyErrorException extends RuntimeException {

  }

  public static class UpdateReplyErrorException extends RuntimeException {

  }
}
