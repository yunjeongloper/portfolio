package work.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import work.model.dto.Book;
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
public class BookDao {

	// FactoryDao ���ڿ��� Connection, factory.close() ����ϱ� ���� ��ü 
	private static FactoryDao factory = FactoryDao.getInstance();
	
	// Singleton Pattern
	private static BookDao instance = new BookDao();
	
	// Singleton Pattern
	private BookDao() {}

	// Singleton Pattern
	public static BookDao getInstance() { 
		return instance; 
	}
	
	// 1. ��ü ���� ��ȸ
	public ArrayList<Book> selectListBook(){
		String sql = "select * from books";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Book> list = new ArrayList<Book>();
		
		try {
			conn=factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			Book dto = null;
			int bookNum = 0;
			String bookName = null;
			String authorName = null;
			int publisherNum = 0;
			int bookPrice = 0;
			int stock = 0;
			String publishDate = null;
			String category = null;
			
			while(rs.next()) {
				bookNum = rs.getInt("book_num");
				bookName = rs.getString("book_name");
				authorName = rs.getString("author_name");
				publisherNum = rs.getInt("publisher_num");
				bookPrice = rs.getInt("book_price");
				stock = rs.getInt("stock");
				publishDate = rs.getString("publish_date");
				category = rs.getString("category");
				dto = new Book(bookNum, bookName, authorName, publisherNum, 
						bookPrice, stock, publishDate, category);
				list.add(dto);
			}
		} catch (SQLException e) {
			System.out.println("Error : ��ü ���� ��ȸ ����");
			e.printStackTrace();
		} finally {
			factory.close(rs,pstmt,conn);
		}
		return list;
	}

	// 2. ���� �̸�(��) ��ȸ
	public ArrayList<Book> selectOneBook(String bookName){
		String sql = "select * from books where book_name=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;			
		ArrayList<Book> list = new ArrayList<Book>();
		
		try {
			conn=factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, bookName);
			
			rs = pstmt.executeQuery();

			Book dto = null;
			int bookNum = 0;
			String authorName = null;
			int publisherNum = 0;
			int bookPrice = 0;
			int stock = 0;
			String publishDate = null;
			String category = null;
			
			while(rs.next()) {
				bookNum = rs.getInt("book_num");
				bookName = rs.getString("book_name");
				authorName = rs.getString("author_name");
				publisherNum = rs.getInt("publisher_num");
				bookPrice = rs.getInt("book_price");
				stock = rs.getInt("stock");
				publishDate = rs.getString("publish_date");
				category = rs.getString("category");
				dto = new Book(bookNum, bookName, authorName, publisherNum, 
						bookPrice, stock, publishDate, category);
				list.add(dto);
				}
		} catch (SQLException e) {
			System.out.println("Error : ��ü ���� ��ȸ ����");
			e.printStackTrace();
		} finally {
			factory.close(rs,pstmt,conn);
		}
		return list;
	}
	

	// 3-1. ���� ���
	public int insertBook(Book dto) {
		if(isExistNum(dto) == false) {
			String sql = "insert into books values(?,?,?,?,?,?,?,?)" ;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = factory.getConnection();
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, dto.getBookNum());
				pstmt.setString(2, dto.getBookName());
				pstmt.setString(3, dto.getAuthorName());
				pstmt.setInt(4, dto.getPublisherNum());
				pstmt.setInt(5, dto.getBookPrice());
				pstmt.setInt(6, dto.getStock());
				pstmt.setString(7, dto.getPublishDate());
				pstmt.setString(8, dto.getCategory());
				
				int rows = pstmt.executeUpdate();
				return rows;
				} catch(SQLException e ) {
					System.out.println("Error : ȸ������ ����");
					e.printStackTrace();
				} finally {
					factory.close(rs, pstmt, conn);
				}
		}
		return 0;
	}
	
	// 3-2. ���� ��ȣ �ߺ� Ȯ��
	public boolean isExistNum(Book dto) {
		String sql =
				"select * from books where book_num=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = factory.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getBookNum());

			rs = pstmt.executeQuery();
			int rows = 0;
			if(rs.next()) {
				rows = rs.getInt("book_num");
			}
			if(rows!=0) {
				System.out.println("���� ������");
				return true;
			}
		} catch(SQLException e ) {
			System.out.println("Error : ���� �ߺ� ����");
			e.printStackTrace();
		} finally {
			factory.close(rs, pstmt, conn);
		}
		return false;
	}
	
	// 4. ���� ����
	public String deleteOneBook(int bookNum) {
		if(bookNum!=0) {
			String sql = "delete books where book_num=?";Connection conn = null;
			PreparedStatement pstmt = null;
			int rows = 0;
			String result = null;
			
			try {
				conn = factory.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, bookNum);
				rows = pstmt.executeUpdate();
				if (rows>0)
					return "������ �Ϸ�Ǿ����ϴ�.";
				else
					return "Error : ���� ���� ����";
			} catch (SQLException e) {
				e.printStackTrace();
			} finally	{
				factory.close(pstmt, conn);
			}
		}else {
			return "������ ������ ��ȣ�� �Է����ּ���.";
		}
		return null;
	}
	
	// 5. ���� ���� (���)
	public String setBookStock (int bookNum, int setNum) {
		String sql = "update books set stock=? where book_num=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rows = 0;
		
		try {
			conn=factory.getConnection();
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, setNum);
			pstmt.setInt(2, bookNum);
			
			rows = pstmt.executeUpdate();
			if(rows==0)
				return "���� ��� ���� ����";
			else
				return "���� ��� ���� ����";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			factory.close(pstmt, conn);
		}
		return null;
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
