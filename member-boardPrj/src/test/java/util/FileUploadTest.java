package util;

import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import com.devunlimit.project.util.UploadUtil;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.mock.web.MockMultipartHttpServletRequest;

import java.io.IOException;
import java.util.List;

@RunWith(MockitoJUnitRunner.class)
public class FileUploadTest {

  private UploadUtil fileUploadUtil = new UploadUtil();

  MockMultipartHttpServletRequest multipartHttpServletRequest = new MockMultipartHttpServletRequest();

  // 이미지 파일 제외 한 업로드 경로 테스트 성공 시
  @Test
  public void upload_ok() throws IOException {

    makeFileList(new String[]{"1.text","2.text"},"text/plain");
    List<BoardFileDTO>  list =fileUploadUtil.upload(multipartHttpServletRequest, "1");
     Assert.assertEquals(list.size(),2);
  }

  // 이미지 파일 경로 테스트
  @Test
  public void imageUpload_ok() throws IOException {
    makeFileList(new String[]{"1.jpg","2.jpeg","3.jpg","4.jpeg","5.jpg"},"image/jpeg");
    fileUploadUtil.upload(multipartHttpServletRequest, "3");

  }

  private void makeFileList(String[] FileNames,String contentType){

    for (int i = 0 ; i<FileNames.length ; i++) {

        multipartHttpServletRequest.addFile(new MockMultipartFile(FileNames[i],"",contentType,"qwer".getBytes()));
    }
  }

}
