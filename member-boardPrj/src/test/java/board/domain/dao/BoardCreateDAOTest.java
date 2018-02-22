package board.domain.dao;

import com.devunlimit.project.board.domain.dao.BoardCreateDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.domain.dto.BoardFileDTO;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@Transactional
@ActiveProfiles("dev")
public class BoardCreateDAOTest {

  @Autowired
  private BoardCreateDAO boardCreateDAO;

  private BoardDTO boardDTO = new BoardDTO("집test", "테스트1", "20", false);

  private BoardFileDTO boardFileDTO;

  @Test
  public void insert() {

    int a = boardCreateDAO.insertBoard(boardDTO);
    Assert.assertEquals(a, 1);
  }

  @Test
  public void updateParents() {

    int a = boardCreateDAO.updateBoardParents("25", "25");
    Assert.assertEquals(a, 1);

  }

  @Test
  public void insertFile() {
    boardFileDTO = new BoardFileDTO("3","text.text","Asdasdadadsadasdasdasdadsad","c:qweqweqweqwe");
    int a = boardCreateDAO.insertFile(boardFileDTO);
    Assert.assertEquals(a, 1);

  }

  @Test
  public void insertImage() {

    boardFileDTO = new BoardFileDTO("3","text.jpg","Asdasdadadsadasdasdasdadsad.jpg","c:qweqweqweqwe");
    int a = boardCreateDAO.insertImage(boardFileDTO);
    Assert.assertEquals(a, 1);
  }

}
