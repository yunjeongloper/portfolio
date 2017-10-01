package work.view;

import java.util.ArrayList;

import work.controller.MemberController;
import work.model.dao.MemberDao;
import work.model.dto.Member;
import work.util.Utility;

public class MemberTest {

	public static void main(String[] args) {
		
		// 회원관리 요청제어객체 생성 : controller 
		MemberController controller = new MemberController();
		
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

		// 회원 테이블에 새로운 Member 객체 추가
		print("회원가입");
		Member dto = new Member("user09","password08","jyj","010-1734-9954","jlj@syu.ac.kr",
				"2017.08.10","S",8000,"윤정");
		MemberDao dao = MemberDao.getInstance();
		int row = dao.insertMember(dto);
		if(row==0)
			System.out.println("회원 등록 실패하셨습니다. ㅠㅠ");
		else
			System.out.println("회원 등록 성공하셨습니다. ^__^");

		print("로그인");
		String results = controller.login("user01", "password01");
		System.out.println(results);
		
		print("로그아웃");
		
		print("아이디찾기");
		results = controller.findMemberId("홍길동","010-1234-1111");
		System.out.println(results);

		print("비밀번호 찾기");
		System.out.println(Utility.getRandomText(7,10)); 
		
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
