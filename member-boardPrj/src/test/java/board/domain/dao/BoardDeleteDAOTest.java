package board.domain.dao;

import java.util.HashMap;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.devunlimit.project.board.domain.dao.BoardDeleteDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/config/context-datasource.xml"})
@Transactional
@ActiveProfiles("dev")
public class BoardDeleteDAOTest {

	@Autowired
	private BoardDeleteDAO dao;
	
	@Test
	public void testDelete(){
		Assert.assertEquals(dao.delete("3"), 1);//update 잘 되는지 확인
	}
	
	@Test
	public void testImageUrlList(){
		List<HashMap<String, String>> url = dao.imageUrl("146");
		for (int i = 0; i < url.size(); i++) {
			System.out.println("\t"+url.get(i).get("url"));
			System.out.println("\t"+url.get(i).get("save_name"));
		}
	}
}
