package work.controller;

import java.util.ArrayList;

import work.model.dto.Book;
import work.model.service.BookService;


/**
 * 
 * <pre>
 * 
 * 도서 관리 요청 제어 Controller 클래스
 * 
 * ## Controller 클래스 역할 (=servlet)
 * 1. 요청 파악
 * 2. 요청 데이터 추출 : 매개변수 전달
 * 3. 요청 데이터 검증
 * 4. Model 요청처리 의뢰
 * 5. Model 요청결과 받아서 응답 위한 설정
 * 6. 결과 응답 : 화면 이동(웹)
 * 
 * </pre>
 * 
 * @author 장윤정
 *
 */

public class BookController {
	/** 도서관리 시스템 서비스를 사용하기 위한 객체  */
	private BookService service = new BookService();

//	print("회원가입");
//	ArrayList<String> result = controller.addMember(null);
//	print(result);
//	데이터 검증
//	Member dto = new Member(null,null,null,null,null);
//	dto = new Member("user07","password07",
//			"jang","010-3332-3333","jyj2@syu.ac.kr");
//	result = controller.addMember(dto);
//	print(result);
//	print(controller.addMember(dto));
	
	public ArrayList<String> insertBook(Book dto) {
		
		ArrayList<String> message = new ArrayList<String>();
		
		if(dto != null) {
			
			int bookNum = dto.getBookNum();
			String bookName = dto.getBookName();
			String authorName = dto.getAuthorName();
			int publisherNum = dto.getPublisherNum();
			int bookPrice = dto.getBookPrice();
			int stock = dto.getStock();
			String publishDate = dto.getPublishDate();
			String category = dto.getCategory();
			
			if(bookNum == 0)
				message.add("책 번호는 필수로 입력하셔야 합니다.");
			if(bookName == null)
				message.add("책 이름은 필수로 입력하셔야 합니다.");
			if(authorName == null)
				message.add("저자 이름은 필수로 입력하셔야 합니다.");
			if(publisherNum == 0)
				message.add("출판사 번호는 필수로 입력하셔야 합니다.");
			if(bookPrice == 0)
				message.add("책 값은 필수로 입력하셔야 합니다.");
			if(stock == 0)
				message.add("책 재고는 필수로 입력하셔야 합니다.");
			if(publishDate == null)
				message.add("출판 날짜는 필수로 입력하셔야 합니다.");
			if(category == null)
				message.add("카테고리는 필수로 입력하셔야 합니다.");
			
			if(message.size()==0)
				System.out.println("");
			else
				return message;
		}
		
		return null;
	}
	
	/**
	 * 회원가입 요청 데이터 검증
	 * -- 필수항목 : 아이디,비밀번호,이름,연락처,이메일
	 * -- 아이디 : 6~20자리 길이제한
	 * -- 비밀번호 : 8~20자리 길이제한
	 * 
	 * @param dto 회원객체
	 * @return 결과 메세지 (성공:가입축하메세지, 실패: 오류항목메세지)
//	 */
//	public ArrayList<String> addMember(Book dto) {
//		ArrayList<String> message = new ArrayList<String>();
//		if (dto != null) {
//			 String memberId = dto.getMemberId();
//			 String memberPw = dto.getMemberPw();
//			 String memberName = dto.getMemberName();
//			 String mobile = dto.getMobile();
//			 String email = dto.getEmail();
//			 
//			 if (memberId!=null) {
//				 memberId = memberId.trim();
//				 if (memberId.length()>=6&&
//						 memberId.length()<=20) {
//					 if (isExist(memberId)) {
//						message.add("아이디가 중복입니다"); 
//					 }
//				 }else {
//					 message.add("아이디는 6자리부터 20자리 이내로 설정해주세요.");
//				 }
//			 }else {
//				 message.add("아이디는 필수입력항목입니다.");
//			 }
//			 
//			 //비번
//			 if (memberPw==null ||
//					 memberPw.trim().length()<8 ||
//					 memberPw.trim().length()>20) {
//				 message.add("비밀번호는 8자리부터 20자리 이내로 설정해주세요.");
//			 }
//			 
//			 //이름
//			 if (memberName==null||memberName.trim().length()==0)
//				 message.add("이름을 입력해주세요.");
//			 
//			 //연락처
//			 if (mobile==null||mobile.trim().length()==0)
//				 message.add("핸드폰 번호를 입력해주세요.");
//			 
//			 //이메일
//			 if (email==null||email.trim().length()==0)
//				 message.add("이메일 주소를 입력해주세요.");
//			 
//		} else {
//			message.add("회원 등록 정보가 존재하지 않습니다.");
//		}
//		
//		// 가입 정보 검증 실패시
//		if (!message.isEmpty()) {
//			return message;
//		}else {
//			message.add("회원 가입이 완료되었습니다.");
//		}
//		
//		// 가입 정보 검증 성공시 : Model에게 요청 처리 의뢰
//		return message;
//	}

	/**
	 * 아이디 중복 검색
	 * @param memberId 아이디
	 * @return 존재하면 true, 존재하지 않으면 false
	 */
	public boolean isExist(String memberId) {
		
		return false;
	}
	
	/**
	 * 로그인
	 * @param memberId 아이디
	 * @param memberPw 비밀번호
	 * @return 존재하면 회원등급반환, 미가입 혹은 비밀번호 오류시 null 반환
	 */
	public String login(String memberId, String memberPw) {
		// 데이터 검증 : 로그인 아이디, 비밀번호 필수 입력
		if ( memberId != null && memberPw != null ) {
			String grade = service.login(memberId,memberPw);
			if (grade != null) {
				System.out.println("로그인 성공! 등급은 "+grade+"입니다.");
			} else {
				//로그인 실패 : 아이디 미존재 또는 비밀번호 틀림
				return "로그인 실패입니다. 아이디와 비밀번호를 확인해주세요.";
			}
		} else {
			//필수항목 미입력 오류 처리
			return "아이디와 비밀번호는 모두 입력되어야 합니다.";
		}
		return null;
	}
	
	public String findMemberId (String memberName, String mobile) {
		if ( memberName != null && mobile != null ) {
			String memberId = service.findMemberId(memberName,mobile);
			if (memberId != null) {
				return "아이디 찾기 성공! 아이디는 "+memberId+"입니다";
			} else {
				//찾기 실패 : 이름 미존재 또는 핸드폰 번호 틀림
				return "아이디 찾기 실패입니다. 아이디와 비밀번호를 확인해주세요.";
			}
		} else {
			//필수항목 미입력 오류 처리
			return "아이디와 핸드폰 번호는 모두 입력되어야 합니다.";
		}
	}

	/**
	 * 로그아웃
	 */
	public void logout() {
		
	}

	/**
	 * 비밀번호 변경
	 * @param memberId 아이디
	 * @param memberPw 기존 비밀번호
	 * @param modifiedPw 변경된 비밀번호
	 * @return 결과 메세지 (성공:변경되었습니다. 실패:아이디 혹은 비밀번호 입력오류)
	 */
	public String UpdateMemberPw(String memberId, String memberPw, String modifiedPw) {
		return null;
	}

	/**
	 * 회원 탈퇴
	 * @param memberId 아이디
	 * @param memberPw 비밀번호
	 * @return 결과 메세지 (성공:변경되었습니다. 실패:아이디 혹은 비밀번호 입력오류(
	 */
	public String removeMember(String memberId, String memberPw) {
		return null;
	}
	
	//아이디찾기
	//비밀번호찾고변경
	//마일리지적립
	//담당자배정
	//회원속성조회
	//회원속성변경
	//회원등
	//회원강퇴
	//금일가입인원수
	//전체회원등급별조회
	//본인확인
	//탈퇴회원아이디조회
	
	

}
