package work.model.service;

import work.model.dto.Member;
import work.model.dao.MemberDao;

/**
 * 
 * <pre>
 * 회원관리 service 클래스 (업무 프로세스, 비즈니스 로직)
 * </pre>
 * 
 * @author 장윤정
 *
 */

public class MemberService {
	
	/** 회원 테이블에 대해서 CURD위한 Member dao 객체선언 */
	//private MemberDao dao = new MemberDao();
	private MemberDao dao = MemberDao.getInstance();
	
	/**
	 * 회원 등록 서비스
	 * -- 가입일 	: 현재날짜
	 * -- 등급 	: G
	 * -- 마일리지 : 1000
	 * --  
	 * @param dto 회원객체(아이디, 비번, 이름, 연락처, 이메일)
	 * @return 결과 메세지
	 */
	public String addMember(Member dto) {
		// 가입일, 등급, 마일리지 정보 주기 설정
		dto.setEntryDate("2017.08.08");
		dto.setGrade("G");
		dto.setMileage(1000);
		
		// DAO 클래스에게 레코드 추가 요청
		return null;
	}
	
	public String login(String memberId, String memberPw) {
		return dao.login(memberId, memberPw);
	}
	
	public String findMemberId(String memberName, String mobile) {
		return dao.findMemberId(memberName, mobile);
	}

}
