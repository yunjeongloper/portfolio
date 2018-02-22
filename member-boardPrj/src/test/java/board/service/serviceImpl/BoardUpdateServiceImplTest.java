package board.service.serviceImpl;

import com.devunlimit.project.board.domain.dao.BoardCreateDAO;
import com.devunlimit.project.board.domain.dao.BoardUpdateDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import com.devunlimit.project.board.service.BoardUpdateService;
import com.devunlimit.project.board.service.serviceImpl.BoardUpdateServiceImpl;
import java.io.IOException;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.mock.web.MockMultipartHttpServletRequest;

@RunWith(MockitoJUnitRunner.class)
public class BoardUpdateServiceImplTest {

  private BoardDTO boardDTO = new BoardDTO();

  private BoardFileDTO boardFileDTO = new BoardFileDTO();

  @Mock
  private BoardUpdateDAO boardUpdateDAO;

  @Mock
  private BoardCreateDAO boardCreateDAO;

  MockMultipartHttpServletRequest multipartHttpServletRequest = new MockMultipartHttpServletRequest();

  @InjectMocks
  private BoardUpdateService boardUpdateService = new BoardUpdateServiceImpl();

  @Before
  public void setup() {
    boardDTO.setNo("1");
    Mockito.when(boardUpdateDAO.updateBoard(boardDTO)).thenReturn(1);
//    Mockito.when(boardCreateDAO.insertFile(boardFileDTO)).thenReturn(1);
    multipartHttpServletRequest.addFile(new MockMultipartFile("qwe","","text/plain","qwer".getBytes()));
  }


  @Test
  public void update() throws IOException {

    int a = boardUpdateService.updateBoard(boardDTO,multipartHttpServletRequest);
    Assert.assertEquals(1,a);
  }
}
