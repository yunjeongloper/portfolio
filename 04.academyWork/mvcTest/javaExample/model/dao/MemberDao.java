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
 * ## JDBC ���α׷��� ����
 * 
 * 1. ����̹� �ε� : ������
 * 				: class.forName(driver)
 * 2. DB ���� ���� : getConnection()
 * 				: Connection conn = DriverManager.getConnection(url,user,password);
 * 
 * 3. sql ��� ���� : Statement stmt = conn.createStatement();
 * 4. sql ���� : stmt.excuteUpdate(sql);
 * 5. ��� ó�� : Resultset rs = stmt.executeQuery(sql);
 * 
 * 6. �ڿ� ���� : close(rs,stmt,conn), close(stmt,conn)
 * 			 : rs.close();
 *    		 : stmt.close();
 *    		 : conn.close();
 *    
 * ## JDBC Property : ȯ�� ����
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
 * ## JDBC Driver ��ġ
 * 
 * -- Oracle : ojdbc6.jar => jdk6.0 jdbc ���� driver
 * 1. ��ǻ�� �ý���(����) ��� : jdk\jre\lip\ext > ������ ����
 * 2. ������Ʈ ���� ��� : ������ classpath �߰� ����
 * 
 * ## javac / java ����� Ŭ������ ã�ư��� �˻� ��� : classpath
 * 
 * 1. rt.jar : JAVA SE (ǥ�� api library)
 * 2. jdk\jre\lip\ext> ������ �ִ� *.jar
 * 3. set classpath=ȯ�漳������������ ����
 * 4. classpath ȯ�溯�� �̼����ÿ��� ���� ����(working directory)
 * 
 * 
 * Singleton Pattern
	- �ϳ��� Ŭ������ ���ؼ� �ϳ��� �ν��Ͻ�(��ü) ����
	- DAO Ŭ������ ���� ����
	- ��Ģ : 
		1. private ������
		2. public static Ŭ�����̸� getInstance() { return Instance; }
		3. public static Ŭ�����̸� instance = new Ŭ�����̸�();
	- Ŭ�������
		Ŭ�����̸� ���������� = Ŭ�����̸�.getInstance();
 * Factory Pattern
	- FactoryDao Ŭ���� ���� ���� : Singleton Pattern
	- DAO Ŭ�������� ���
	- Connection ��ȯ
	- close( ) �ڿ�����
 * 
 * @author ������
 *
 */
	

/**
 * ���� ���̺� dao Ŭ���� : db access
 */

public class MemberDao {

	// FactoryDao ���ڿ��� Connection, factory.close() ����ϱ� ���� ��ü 
	private static FactoryDao factory = FactoryDao.getInstance();
	
	// Singleton Pattern
	private static MemberDao instance = new MemberDao();
	
	// Singleton Pattern
	private MemberDao() {}

	// Singleton Pattern
	public static MemberDao getInstance() { 
		return instance; 
	}
	
	// �α���(���̵�, ��й�ȣ) : ���
	public String login(String memberId, String memberPw) {
		// sql state�� ���ǻ��� : �� �ڿ� ;�� ǥ���ؼ��� �ȵ�. sql '���ڿ�' ��ȯ �۾�.
		// sql injection �����̽� �߻� �߱� 
		String sql =
				"select member_grade from members where member_id = '"+ 
				memberId + "' and member_pw = '" + memberPw +"'" ;
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			// 2. db ���� ����
			conn = factory.getConnection();
			//conn = DriverManager.factory.getConnection(url, user, password);
			
			// 3. ��� ����
			stmt = conn.createStatement();
			
			// 4. sql ����
			rs = stmt.executeQuery(sql);
			
			// 5. ��� ó��
			if(rs.next()) {
				return rs.getString("member_grade");
			}
		} catch(SQLException e ) {
			System.out.println("Error : �α��� ����");
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
			System.out.println("Error : �ڿ����� ����");
			e.printStackTrace();
		}
	}
	
	public void close(Statement stmt, Connection conn) {
		close(null, stmt, conn);
	}
	
	// ȸ�����
	public int insertMember(Member dto) {
		// sql state�� ���ǻ��� : �� �ڿ� ;�� ǥ���ؼ��� �ȵ�. sql '���ڿ�' ��ȯ �۾�.
		// sql injection �����̽� �߻� �߱� 

		if(isExistId(dto) == false) {
			
			String sql = "insert into members values(?,?,?,?,?,?,?,?,?)" ;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				// 2. db ���� ����
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
					System.out.println("Error : ȸ������ ����");
					e.printStackTrace();
				} finally {
					close(rs, pstmt, conn);
				}
		}
		return 0;
	}

	// ���̵� �ߺ� Ȯ��
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
				System.out.println("���̵� ������");
				return true;
			}
		} catch(SQLException e ) {
			System.out.println("Error : ���̵� �ߺ� ����");
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return false;
	}
	
	// ���̵� ã��(�̸�, ��ȭ��ȣ) : ���̵�
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
				System.out.println("Dao Error : ���̵�� �޴��� ��ȣ�� Ȯ�����ּ���");
			}
			return results;
		} catch (SQLException e) {
			System.out.println("Error : ���̵� ã�� ����");
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return null;
	}
	
	//ȸ�� �� ��ȸ
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

	// ��üȸ��
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
			System.out.println("Error : ��ü��ȸ ����");
			e.printStackTrace(); 
		} finally {
			close(rs, pstmt, conn);
		}
		return list;
	}
 	
	// ��޺� ȸ�� ��ȸ
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
			System.out.println("Error : ȸ������ ����");
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return list;
	}
	
	
	// �� ���� ������ �˻�

	// ��й�ȣ ����
	
	// ȸ�� Ż��
	public String deleteMember(String memberId, String memberPw) {
		if(this.selectOneMember(memberId)==null) {
			return "�������� �ʴ� ȸ���Դϴ�.";
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
					System.out.println("�����Ǿ����ϴ�.");
				else
					System.out.println("Error : ȸ�� ���� ���� ����");
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				close(pstmt, conn);
			} return null;
		}
	}
	
}
