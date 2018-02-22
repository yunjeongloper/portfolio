package board.domain.dao;

import com.devunlimit.project.board.domain.dao.BoardUpdateDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@ActiveProfiles("dev")
@Transactional
public class BoardUpdateDAOTest {

  @Autowired
  private BoardUpdateDAO boardUpdateDAO;

  private BoardDTO boardDTO = new BoardDTO();

  @Test
  public void update() {

    boardDTO.setNo("4");
    boardDTO.setSubject("업데이트테스트");
    boardDTO.setContent("테스으!잉");
    boardDTO.setNotice(false);

    boardUpdateDAO.updateBoard(boardDTO);
  }

}
