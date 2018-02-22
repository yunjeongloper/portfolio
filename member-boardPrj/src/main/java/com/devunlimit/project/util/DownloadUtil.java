package com.devunlimit.project.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DownloadUtil {

  //파일다운로드
  public void download(HttpServletRequest request, HttpServletResponse response, String fileName, String filePath) throws Exception{

    response.setContentType("application/octet-stream");

    String userAgent = request.getHeader("User-Agent");

    // attachment; 가 붙으면 IE의 경우 무조건 다운로드창이 뜬다. 상황에 따라 써야한다.
    if (userAgent != null && userAgent.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 이하
      response.setHeader("Content-Disposition", "filename=" + URLEncoder.encode(fileName, "UTF-8") + ";");
    } else if (userAgent != null && userAgent.indexOf("MSIE") > -1) { // MS IE (보통은 6.x 이상 가정)
      response.setHeader("Content-Disposition", "attachment; filename="
          + java.net.URLEncoder.encode(fileName, "UTF-8") + ";");
    } else { // 모질라나 오페라
      response.setHeader("Content-Disposition", "attachment; filename="
          + new String(fileName.getBytes("euc-kr"), "latin1") + ";");
    }

    File file = new File(filePath); //파일 생성

    FileInputStream fis = new FileInputStream(file);

    OutputStream os = response.getOutputStream();

    int n = 0;
    byte[] b = new byte[1024];
    while((n = fis.read(b)) != -1 ) {
      os.write(b, 0, n);
    }

    fis.close();
    os.close();

  }
}
