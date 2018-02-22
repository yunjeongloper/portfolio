package board.domain.dao;

import com.devunlimit.project.board.domain.dao.BoardListDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.*;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@ActiveProfiles("dev")
public class BoardListDAOTest {

    @Autowired
    private BoardListDAO boardListDAO;
    @Test
    public void selectList() {

        List<BoardDTO> list = boardListDAO.selectLIst(1,10,"1","1번");
        assertEquals(list.size(),0);
    }
    @Test
    public void totalCount(){

        int total = boardListDAO.totalCount("1","1번");
        assertEquals(total,0);
    }

}
