package work.model.service;

import java.util.ArrayList;

import work.model.dao.BookDao;
import work.model.dto.Book;


/**
 * 
 * <pre>
 * ȸ������ service Ŭ���� (���� ���μ���, ����Ͻ� ����)
 * </pre>
 * 
 * @author ������
 *
 */

public class BookService {
	
	/** ȸ�� ���̺� ���ؼ� CURD���� Member dao ��ü���� */
	//private MemberDao dao = new MemberDao();
	private BookDao dao = BookDao.getInstance();
	
	public ArrayList<String> insertBook(Book dto) {
		return null;
	}
		
	
	/**
	 * ȸ�� ��� ����
	 * -- ������ 	: ���糯¥
	 * -- ��� 	: G
	 * -- ���ϸ��� : 1000
	 * --  
	 * @param dto ȸ����ü(���̵�, ���, �̸�, ����ó, �̸���)
	 * @return ��� �޼���
	 */
	public String addMember(Book dto) {
		// ������, ���, ���ϸ��� ���� �ֱ� ����
//		dto.setEntryDate("2017.08.08");
//		dto.setGrade("G");
//		dto.setMileage(1000);
		
		// DAO Ŭ�������� ���ڵ� �߰� ��û
		return null;
	}
	
	public String login(String memberId, String memberPw) {
		return dao.login(memberId, memberPw);
	}
	
	public String findMemberId(String memberName, String mobile) {
		return dao.findMemberId(memberName, mobile);
	}

}
