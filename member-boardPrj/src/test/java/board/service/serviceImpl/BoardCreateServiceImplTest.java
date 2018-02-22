package board.service.serviceImpl;

import com.devunlimit.project.board.domain.dao.BoardCreateDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import com.devunlimit.project.board.service.BoardCreateService;
import com.devunlimit.project.board.service.serviceImpl.BoardCreateServiceImpl;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.mock.web.MockMultipartHttpServletRequest;

import java.io.IOException;

import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;

@RunWith(MockitoJUnitRunner.class)
public class BoardCreateServiceImplTest {

  private BoardDTO boardDTO;
  private BoardDTO boardDTO2;
  private BoardFileDTO boardFileDTO;

  MockMultipartHttpServletRequest multipartHttpServletRequest = new MockMultipartHttpServletRequest();

  @Mock
  private BoardCreateDAO boardCreateDAO;

  @InjectMocks
  private BoardCreateService boardCreateService = new BoardCreateServiceImpl();

  @Before
  public void setup() {
    boardDTO = new BoardDTO("subject","qwe","20",false);
    boardDTO.setNo("25");
    Mockito.when(boardCreateDAO.insertBoard(boardDTO)).thenReturn(1);
    Mockito.when(boardCreateDAO.updateBoardParents("25","25")).thenReturn(1);

  }


  //모든 값이 제대로 들어와 insert 성공시
  @Test
  public void insertBoard_ok() throws IOException {
    makeFileList(new String[]{"1.text"},"text/plain");
    String result = boardCreateService.insertBoard(boardDTO,"25",multipartHttpServletRequest);
    assertEquals(result,"200");
  }

  //sql 상 처리 오류가 있을 때
  @Test
  public void insertBoard_fail() throws IOException {
    makeFileList(new String[]{"1.text"},"text/plain");
    assertEquals(boardCreateService.insertBoard(boardDTO2,"25",multipartHttpServletRequest),"400"); //입력값이 잘못된 경우
    assertEquals(boardCreateService.insertBoard(boardDTO,"1231",multipartHttpServletRequest),"400"); //

  }

  //파일 관련 에러 발생시
  @Test(expected = IOException.class)
  public void uploadFail() throws IOException {
    makeFileList(new String[]{"1.text","2.text","3.text","4.text","5.text","6.text"},"text/plain");
    String result = boardCreateService.insertBoard(boardDTO,"25",multipartHttpServletRequest);
    assertEquals(result,"400");
  }

  //이미지 업로드 테스트 진행
  @Test
  public void imageUpload() throws IOException {
    makeFileList(new String[]{"1.jpg"},"image/jpeg");
    boardCreateService.insertImage(multipartHttpServletRequest);
  }

  private void makeFileList(String[] FileNames,String contentType){

    for (int i = 0 ; i<FileNames.length ; i++) {

      multipartHttpServletRequest.addFile(new MockMultipartFile(FileNames[i],"",contentType,"qwer".getBytes()));
    }
  }
}
