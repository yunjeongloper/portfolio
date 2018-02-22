package board.service.serviceImpl;

import com.devunlimit.project.board.domain.dao.BoardListDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.service.BoardListService;
import com.devunlimit.project.board.service.serviceImpl.BoardListServiceImpl;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import java.util.List;

@RunWith(MockitoJUnitRunner.class)
public class BoardListServiceImplTest {

    @Mock
    private BoardListDAO boardListDAO;

    @InjectMocks
    private BoardListService boardListService = new BoardListServiceImpl();

    // 게심물 목록 출력
    @Test
    public void selectList() {

        List<BoardDTO> list = boardListService.selectList(1, 10,"searchType","searchData");
    }

    // 총 게시물
    @Test
    public void totalCount() {
        int totalCount = boardListService.totalCount("searchType","searchData");
    }

    //공지 게시물 출력
    @Test
    public void notice() {

        List<BoardDTO> noticeList = boardListService.noticeList();
    }

}
