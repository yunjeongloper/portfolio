package com.devunlimit.project.board.service.serviceImpl;

import com.devunlimit.project.board.domain.dao.BoardCreateDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import com.devunlimit.project.board.service.BoardCreateService;
import com.devunlimit.project.util.UploadUtil;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.IOException;
import java.util.List;

@Service
@Transactional
public class BoardCreateServiceImpl implements BoardCreateService {

  @Override
  public int updateFileNo(String boardNo, String fileNo) {
    return boardCreateDAO.updateFileNo(boardNo,fileNo);
  }

  @Autowired
  private BoardCreateDAO boardCreateDAO;

  private UploadUtil uploadUtil = new UploadUtil();

  @Override
  public BoardFileDTO insertImage( MultipartHttpServletRequest multipartHttpServletRequest) throws IOException {

    List<BoardFileDTO>  imageList = null;
    try {
      imageList = uploadUtil.upload(multipartHttpServletRequest,"0");
      BoardFileDTO boardFileDTO = imageList.get(0);
      boardCreateDAO.insertImage(boardFileDTO);
    } catch (IOException e) {
      throw e;
    }

    return imageList.get(0);
  }

  @Override
  public String insertBoard(BoardDTO boardDTO, String parentsNo,
      MultipartHttpServletRequest request) throws IOException {

    int insertStatus = boardCreateDAO.insertBoard(boardDTO);

    if (insertStatus != 1) {

      return "400";

    } else {

      if (parentsNo != null && parentsNo.length() != 0 && !parentsNo.equals("")) {

        boardDTO.setParents_no(parentsNo);

      } else {

        boardDTO.setParents_no(boardDTO.getNo());

      }

      int updateStatus = boardCreateDAO
          .updateBoardParents(boardDTO.getNo(), boardDTO.getParents_no());

      if (updateStatus != 1) {

        return "400";

      } else {

        if (request.getFileMap().size() > 5) {

          throw new IOException("파일 갯수 초과");

        } else {
          List<BoardFileDTO> list = uploadUtil.upload(request, boardDTO.getNo());

          for (int i = 0; i < list.size(); i++) {

            boardCreateDAO.insertFile(list.get(i));

          }
          return "200";
        }
      }
    }
  }
}
