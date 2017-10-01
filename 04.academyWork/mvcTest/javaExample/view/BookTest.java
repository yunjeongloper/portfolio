package work.view;

import java.util.ArrayList;

import work.controller.BookController;
import work.model.dao.BookDao;
import work.model.dto.Book;

public class BookTest {

	public static void main(String[] args) {
		BookController controller = new BookController();

		print("회원가입");
//		ArrayList<String> result = controller.addMember(null);
//		print(result);
//		데이터 검증
//		Member dto = new Member(null,null,null,null,null);
//		dto = new Member("user07","password07",
//				"jang","010-3332-3333","jyj2@syu.ac.kr");
//		result = controller.addMember(dto);
//		print(result);
//		print(controller.addMember(dto));

		// 도서 테이블에 새로운 Book 객체 추가
		print("도서 추가 _ 관리자");
		Book dto = new Book(6, "원피스 매거진", "오다 에이치로",
				555, 11700, 15, "2017.08", "만화");
		ArrayList <String> result = controller.insertBook(dto);
		BookDao dao = BookDao.getInstance();
		int row = dao.insertBook(dto);
		if(row==0)
			System.out.println("도서 등록 실패하셨습니다. ㅠㅠ");
		else
			System.out.println("도서 등록 성공하셨습니다. ^__^");
		
		print("도서 전체 조회 _ 관리자, 회원");
		ArrayList<Book> list = dao.selectListBook();
		for (Book n : list) {
			System.out.println(n);
		}

		print("도서 이름(상세) 조회 _ 관리자, 회원");
		list = dao.selectOneBook(null);
		for (Book n : list) {
			System.out.println(n);
		}
		
		print("도서 삭제 _ 관리자");
		String result1 = dao.deleteOneBook(0);
		System.out.println(result1);
		
		print("도서 재고 변경 _ 관리자");
		result1 = dao.setBookStock(3, 50);
		System.out.println(result1);
	}
	
	// 테스트를 위한 객체생성없이 아규먼트로 전달받은 문자열을 출력하는 메서드 구현
	// 메서드이름 : print
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
