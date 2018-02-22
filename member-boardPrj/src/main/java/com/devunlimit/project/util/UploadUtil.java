package com.devunlimit.project.util;

import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

public class UploadUtil {

  private String baseDir = "c:" + File.separator + "temp" + File.separator;

  public List upload(MultipartHttpServletRequest request, String boardNo) throws IOException {

    List<BoardFileDTO> fileList = new ArrayList<>();

    Iterator<String> itr = request.getFileNames();
    BoardFileDTO boardFileDTO;

    while (itr.hasNext()) {

      MultipartFile file = request.getFile(itr.next());

      StringBuffer sb = new StringBuffer();
      String originName = file.getName();
      String ext = getExtension(originName).toLowerCase();
      String saveName = sb.append(UUID.randomUUID()).append("-").append(boardNo).append(".")
          .append(ext).toString();

      try {
        String savePath;
        if (ext.equals("jpg") || ext.equals("jpeg") || ext.equals("gif") || ext.equals("bmp")) {

          savePath = request.getSession().getServletContext().getRealPath("/")+"resources/uploadImage/";

        } else {

          savePath = baseDir + boardNo +File.separator;

        }

        File saveDir = new File(savePath);

        if (!saveDir.exists()) {
          saveDir.mkdirs();
        } else {
        }

        file.transferTo(new File(savePath  + saveName));

        boardFileDTO = new BoardFileDTO(boardNo, originName, saveName, savePath);

      } catch (IOException e) {
        throw new IOException("업로드중 에러발생");
      }

      fileList.add(boardFileDTO);
    }

    return fileList;
  }

  public String getExtension(String fileName) {
    int dotPosition = fileName.lastIndexOf('.');

    if (-1 != dotPosition && fileName.length() - 1 > dotPosition) {
      return fileName.substring(dotPosition + 1);
    } else {
      return "";
    }
  }
}
