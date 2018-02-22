package board.service.serviceImpl;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.junit.MockitoJUnitRunner;
import org.mockito.stubbing.Answer;

import com.devunlimit.project.board.domain.dao.BoardDeleteDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.service.BoardDeleteService;
import com.devunlimit.project.board.service.serviceImpl.BoardDeleteServiceImpl;

@RunWith(MockitoJUnitRunner.class)
public class BoardDeleteServiceImplTest {

	@Mock
	private BoardDeleteDAO dao;
	
	@InjectMocks
	private BoardDeleteService service = new BoardDeleteServiceImpl();
	
	@Before
	public void setUp(){
		
		when(dao.boardExistCheck("100")).thenReturn(1); //게시글번호 100인 경우 게시글 유무 체크 O
		when(dao.delete("100")).thenReturn(1); //게시글번호 100인 경우 삭제 성공으로 가정
		
		when(dao.boardExistCheck("200")).thenReturn(1); //게시글번호 200인 경우 게시글 유무 체크 O
		when(dao.delete("200")).thenReturn(0); //게시글번호 200인 경우 삭제 실패로 가정
		
	}
	
	@Test
	public void testBoardDelete(){
		//view - 자기자신 글에만 삭제버튼 활성화
		//view - 삭제된 글은 블라인드처리하기
		//service 1. 삭제할 게시글 번호를 매개변수로 받기
		//service 2. 삭제할 글이 존재하는지 확인
		//service 3. sql에서 delete_ok 컬럼에 1로 update 해주기
		
		//삭제 성공 시 true
		boolean deleteOk = service.delete("100");
		assertEquals(deleteOk, true);
		
		//삭제 실패 시 false
		boolean deleteOk2 = service.delete("200");
		assertEquals(deleteOk2, false);
		
		//게시물이 없을 때 false
		boolean deleteOk3 = service.delete("300");
		assertEquals(deleteOk3, false);
	}
	
	@Test
	public void testImageDelete(){
		
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("url", "C:\\");
		map.put("save_name", "aaaa.jpg");
		list.add(map);
		
		map = new HashMap<String, String>();
		map.put("url", "D:\\");
		map.put("save_name", "bbbb.jpg");
		list.add(map);
		
//		for (int i = 0; i < list.size(); i++) {
//			System.out.println("\t"+list.get(i).get("url"));
//			System.out.println("\t"+list.get(i).get("save_name"));
//		}
		
		when(dao.imageUrl("100")).thenReturn(list);
		
		boolean result = service.imgDelete("100");
		assertEquals(result, false);
		

	}
}
