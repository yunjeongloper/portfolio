package work.view;

import java.util.ArrayList;

import work.controller.BookController;
import work.model.dao.BookDao;
import work.model.dto.Book;

public class BookTest {

	public static void main(String[] args) {
		BookController controller = new BookController();

		print("ȸ������");
//		ArrayList<String> result = controller.addMember(null);
//		print(result);
//		������ ����
//		Member dto = new Member(null,null,null,null,null);
//		dto = new Member("user07","password07",
//				"jang","010-3332-3333","jyj2@syu.ac.kr");
//		result = controller.addMember(dto);
//		print(result);
//		print(controller.addMember(dto));

		// ���� ���̺� ���ο� Book ��ü �߰�
		print("���� �߰� _ ������");
		Book dto = new Book(6, "���ǽ� �Ű���", "���� ����ġ��",
				555, 11700, 15, "2017.08", "��ȭ");
		ArrayList <String> result = controller.insertBook(dto);
		BookDao dao = BookDao.getInstance();
		int row = dao.insertBook(dto);
		if(row==0)
			System.out.println("���� ��� �����ϼ̽��ϴ�. �Ф�");
		else
			System.out.println("���� ��� �����ϼ̽��ϴ�. ^__^");
		
		print("���� ��ü ��ȸ _ ������, ȸ��");
		ArrayList<Book> list = dao.selectListBook();
		for (Book n : list) {
			System.out.println(n);
		}

		print("���� �̸�(��) ��ȸ _ ������, ȸ��");
		list = dao.selectOneBook(null);
		for (Book n : list) {
			System.out.println(n);
		}
		
		print("���� ���� _ ������");
		String result1 = dao.deleteOneBook(0);
		System.out.println(result1);
		
		print("���� ��� ���� _ ������");
		result1 = dao.setBookStock(3, 50);
		System.out.println(result1);
	}
	
	// �׽�Ʈ�� ���� ��ü�������� �ƱԸ�Ʈ�� ���޹��� ���ڿ��� ����ϴ� �޼��� ����
	// �޼����̸� : print
	public static void print(String message) {
		System.out.println("\n### "+message+" ###");
	}

	public static void print(ArrayList<String> message){
		System.out.println();
		for(String data : message) {
			System.out.println(data);
		}
	}
}
