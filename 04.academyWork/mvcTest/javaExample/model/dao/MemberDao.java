package work.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import work.model.dto.Member;

/**
 * 
 * ## JDBC 프로그래밍 절차
 * 
 * 1. 드라이버 로딩 : 생성자
 * 				: class.forName(driver)
 * 2. DB 서버 연결 : getConnection()
 * 				: Connection conn = DriverManager.getConnection(url,user,password);
 * 
 * 3. sql 통로 개설 : Statement stmt = conn.createStatement();
 * 4. sql 수행 : stmt.excuteUpdate(sql);
 * 5. 결과 처리 : Resultset rs = stmt.executeQuery(sql);
 * 
 * 6. 자원 해제 : close(rs,stmt,conn), close(stmt,conn)
 * 			 : rs.close();
 *    		 : stmt.close();
 *    		 : conn.close();
 *    
 * ## JDBC Property : 환경 설정
 * 
 * 1. driver
 * 2. url
 * 3. user = "hr"
 * 4. password = "hr"
 * 
 * ## JDBC Exception Handling
 * 
 * 1. ClassNotFoundException
 * 2. SQLException
 * 
 * ## JDBC Driver 위치
 * 
 * -- Oracle : ojdbc6.jar => jdk6.0 jdbc 구현 driver
 * 1. 컴퓨터 시스템(공통) 사용 : jdk\jre\lip\ext > 폴더에 복사
 * 2. 프로젝트 단위 사용 : 별도의 classpath 추가 설정
 * 
 * ## javac / java 사용한 클래스를 찾아가는 검색 경로 : classpath
 * 
 * 1. rt.jar : JAVA SE (표준 api library)
 * 2. jdk\jre\lip\ext> 폴더에 있는 *.jar
 * 3. set classpath=환경설정폴더지정한 파일
 * 4. classpath 환경변수 미설정시에는 현재 폴더(working directory)
 * 
 * 
 * Singleton Pattern
	- 하나의 클래스에 대해서 하나의 인스턴스(객체) 설계
	- DAO 클래스에 적용 설계
	- 규칙 : 
		1. private 생성자
		2. public static 클래스이름 getInstance() { return Instance; }
		3. public static 클래스이름 instance = new 클래스이름();
	- 클래스사용
		클래스이름 참조변수명 = 클래스이름.getInstance();
 * Factory Pattern
	- FactoryDao 클래스 구현 설계 : Singleton Pattern
	- DAO 클래스들이 사용
	- Connection 반환
	- close( ) 자원해제
 * 
 * @author 장윤정
 *
 */
	

/**
 * 도서 테이블 dao 클래스 : db access
 */

public class MemberDao {

	// FactoryDao 공자에게 Connection, factory.close() 사용하기 위한 객체 
	private static FactoryDao factory = FactoryDao.getInstance();
	
	// Singleton Pattern
	private static MemberDao instance = new MemberDao();
	
	// Singleton Pattern
	private MemberDao() {}

	// Singleton Pattern
	public static MemberDao getInstance() { 
		return instance; 
	}
	
	// 로그인(아이디, 비밀번호) : 등급
	public String login(String memberId, String memberPw) {
		// sql state문 주의사항 : 맨 뒤에 ;을 표기해서는 안됨. sql '문자열' 변환 작업.
		// sql injection 보안이슈 발생 야기 
		String sql =
				"select member_grade from members where member_id = '"+ 
				memberId + "' and member_pw = '" + memberPw +"'" ;
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			// 2. db 서버 연결
			conn = factory.getConnection();
			//conn = DriverManager.factory.getConnection(url, user, password);
			
			// 3. 통로 개설
			stmt = conn.createStatement();
			
			// 4. sql 수행
			rs = stmt.executeQuery(sql);
			
			// 5. 결과 처리
			if(rs.next()) {
				return rs.getString("member_grade");
			}
		} catch(SQLException e ) {
			System.out.println("Error : 로그인 오류");
			e.printStackTrace();
		} finally {
			factory.close(rs, stmt, conn);
		}
		return null;
	}
	
	private void close(ResultSet rs, Statement stmt, Connection conn) {
		try {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			System.out.println("Error : 자원해제 오류");
			e.printStackTrace();
		}
	}
	
	public void close(Statement stmt, Connection conn) {
		close(null, stmt, conn);
	}
	
	// 회원등록
	public int insertMember(Member dto) {
		// sql state문 주의사항 : 맨 뒤에 ;을 표기해서는 안됨. sql '문자열' 변환 작업.
		// sql injection 보안이슈 발생 야기 

		if(isExistId(dto) == false) {
			
			String sql = "insert into members values(?,?,?,?,?,?,?,?,?)" ;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				// 2. db 서버 연결
				conn = factory.getConnection();
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, dto.getMemberId());
				pstmt.setString(2, dto.getMemberPw());
				pstmt.setString(3, dto.getMemberName());
				pstmt.setString(4, dto.getMobile());
				pstmt.setString(5, dto.getEmail());
				pstmt.setString(6, dto.getEntryDate());
				pstmt.setString(7, dto.getGrade());
				pstmt.setInt(8, dto.getMileage());
				pstmt.setString(9, dto.getManager());
				
	//			int rows = pstmt.executeUpdate();
	//			return rows;
				return pstmt.executeUpdate();
				} catch(SQLException e ) {
					System.out.println("Error : 회원가입 오류");
					e.printStackTrace();
				} finally {
					close(rs, pstmt, conn);
				}
		}
		return 0;
	}

	// 아이디 중복 확인
	public boolean isExistId(Member dto) {
		String memberId = dto.getMemberId();
		String sql =
				"select * from members where member_id = '"+ memberId +"'";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(sql);
			String rows = null;
			
			if(rs.next()) {
				rows = rs.getString("member_id");
			}
			
			//System.out.println(rows);
			if(rows!=null) {
				System.out.println("아이디 존재함");
				return true;
			}
		} catch(SQLException e ) {
			System.out.println("Error : 아이디 중복 오류");
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return false;
	}
	
	// 아이디 찾기(이름, 전화번호) : 아이디
	public String findMemberId (String memberId,String mobile) {
		String sql = "select * from members where member_name=? and member_mobile=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String results = null;
		
		try {
			conn = factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, memberId);
			pstmt.setString(2, mobile);
			
			rs = pstmt.executeQuery();
		
			if(rs.next()) {
				results = rs.getString("member_id");
			} else {
				System.out.println("Dao Error : 아이디와 휴대폰 번호를 확인해주세요");
			}
			return results;
		} catch (SQLException e) {
			System.out.println("Error : 아이디 찾기 오류");
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return null;
	}
	
	//회원 상세 조회
	public Member selectOneMember(String memberId) {
		String sql = "select * from members where member_id='"+memberId+"'";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String memberPw = null;
		String memberName = null;
		String mobile = null;
		String email = null;
		String entryDate = null;
		String grade = null;
		int mileage = 0;
		String manager = null;
		
		try {
			conn = factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(sql);
			
			if(rs.next()) {
				memberPw = rs.getString(2);
				memberName = rs.getString(3);
				mobile = rs.getString(4);
				email = rs.getString(5);
				entryDate = rs.getString(6);
				grade = rs.getString(7);
				mileage = rs.getInt(8);
				manager = rs.getString(9);
				
				Member dto = new Member(memberId, memberPw, memberName,
						mobile, email, entryDate, grade, mileage, manager);
				
				return dto;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return null;
	}

	// 전체회원
 	public ArrayList<Member> selectListMember() {
		String sql = "select * from members";  
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Member> list = new ArrayList<Member>();
		
		try {
			conn = factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			Member dto = null;
			String memberId = null;
			String memberPw = null;
			String memberName = null;
			String mobile = null;
			String email = null;
			String entryDate = null;
			String grade = null;
			int mileage = 0;
			String manager = null;
			
			while(rs.next()) {
				memberId = rs.getString("member_id");
				memberPw = rs.getString("member_pw");
				memberName = rs.getString("member_name");
				mobile = rs.getString("member_mobile");
				email = rs.getString("member_email");
				entryDate = rs.getString("member_date");
				grade = rs.getString("member_grade");
				mileage = rs.getInt("member_mileage");
				manager = rs.getString("member_manager");
				dto = new Member(memberId, memberPw, memberName,
						mobile, email, entryDate, grade, mileage, manager);
				list.add(dto);
			}
		} catch(SQLException e) {
			System.out.println("Error : 전체조회 오류");
			e.printStackTrace(); 
		} finally {
			close(rs, pstmt, conn);
		}
		return list;
	}
 	
	// 등급별 회원 조회
	public ArrayList<Member> selectGradeMember(String grade) {
		String sql = "select * from members where member_grade='"+grade+"'" ;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Member> list = new ArrayList<Member>();
		
		try {
			conn = factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			Member dto = null;
			String memberId = null;
			String memberPw = null;
			String memberName = null;
			String mobile = null;
			String email = null;
			String entryDate = null;
			int mileage = 0;
			String manager = null;
			
			while(rs.next()) {
				memberId = rs.getString("member_id");
				memberPw = rs.getString("member_pw");
				memberName = rs.getString("member_name");
				mobile = rs.getString("member_mobile");
				email = rs.getString("member_email");
				entryDate = rs.getString("member_date");
				mileage = rs.getInt("member_mileage");
				manager = rs.getString("member_manager");
				dto = new Member(memberId,memberPw,memberName,mobile,email,
						entryDate,grade,mileage,manager);
				list.add(dto);
			}
		} catch(SQLException e ) {
			System.out.println("Error : 회원가입 오류");
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return list;
	}
	
	
	// 두 개의 조건을 검색

	// 비밀번호 변경
	
	// 회원 탈퇴
	public String deleteMember(String memberId, String memberPw) {
		if(this.selectOneMember(memberId)==null) {
			return "존재하지 않는 회원입니다.";
		}else {
			String sql = "delete from members where member_id='"+memberId+
					"' and member_pw='"+memberPw+"'";
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = factory.getConnection();
				pstmt = conn.prepareStatement(sql);
				int resultInt = pstmt.executeUpdate();
				if(resultInt>0)
					System.out.println("삭제되었습니다.");
				else
					System.out.println("Error : 회원 정보 삭제 오류");
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				close(pstmt, conn);
			} return null;
		}
	}
	
}
