package work.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

/**
 * ## JDBC 프로그래밍 절차 : 
 * 
 * 1. 드라이버 로딩 : 생성자 
 * 2. db 서버 연결 : getConnection() : Connection
 * 
 * 3. sql 통로 개설
 * 4. sql 수행
 * 5. 결과처리
 * 
 * 6. 자원해제 : close(rs, stmt, conn), close(stmt, conn)
 *
 * ## JDBC Property : 환경설정
 * 1. driver = ""
 * 2. url = ""
 * 3. user = "hr"
 * 4. password = "tiger"
 * 
 * ## JDBC Exception Handling
 * 1. ClassNotFoundException
 * 2. SQLException
 * 
 * ## JDBC Driver 위치 
 * -- Oracle : ojdbc6.jar => jdk6.0 jdbc 구현 driver
 * 1. 컴퓨터시스템(공통) 사용 : jdk\jre\lib\ext> 폴더에 복사
 * 2. 프로젝트 단위 사용 : 별도의 classpath 추가 설정
 * 
 * ## javac / java 사용한 클래스를 찾아가는 검색 경로 : classpath
 * 1. rt.jar : Java SE (표준 api)
 * 2. jdk\jre\lib\ext> 폴더에 있는 *.jar
 * 3. set classpath=환경설정폴더지정한 파일
 * 4. classpath 환경변수 미설정시에는 현재 폴더(working directory)
 * 
 * 	## Singleton Pattern
 * 	-- 하나의 클래스에 대해서 하나의 인스턴스(객체) 설계
 * 	-- DAO 클래스에 적용 설계
 * 	-- 규칙:
 * 		1. private 생성자
 * 		2. public static 클래스이름 getInstance() { return instance; }
 * 		3. private static 클래스이름 instance = new 클래스이름();
 * 	
 * 	-- 클래스 사용
 * 		클래스이름 참조변수명 = 클래스이름.getInstance();
 *  
 * 	## Factory Pattern
 * 	-- FactoryDao 클래스 구현 설계 : Singleton Pattern
 * 	-- DAO 클래스들이 사용
 * 	-- Connection 반환
 * 	-- close() 자원해제
 */
 
/**
 * dao 클래스들이 사용하기 위한 클래스 : 
 * -- db connection 연결
 * -- db close 자원해제
 */
public class FactoryDao {
	private static FactoryDao instance = new FactoryDao();
	
	// 외부 자원파일 : ResourceBundle 객체선언
	private ResourceBundle resource;
	
	private String driver;
	private String url;
	private String user;
	private String password;
	
	private FactoryDao() {
		// 외부 자원파일 가져와서 초기화
		resource = ResourceBundle.getBundle("conf/dbserver");
		driver = resource.getString("oracle.driver");
		url = resource.getString("oracle.url");
		user = resource.getString("oracle.user");
		password = resource.getString("oracle.password");
		
		try {
			Class.forName(driver);
		} catch(ClassNotFoundException e) {
			System.out.println("Error : 드라이버 로딩 오류");
			e.printStackTrace(); 
		}
	}

	public static FactoryDao getInstance() { 
		return instance; 
	}
	
	public Connection getConnection() {
		try {
			return DriverManager.getConnection(url, user, password);
		} catch(SQLException e) {
			System.out.println("Error : DB서버 연결 오류");
			e.printStackTrace(); 
		}
		
		return null;
	}
	
	public void close(ResultSet rs, Statement stmt, Connection conn) {
		try {
			if (rs != null) {
				rs.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (conn != null) {
				conn.close();
			}
		} catch(SQLException e) {
			System.out.println("Error : 자원해제 오류");
			e.printStackTrace(); 
		}
	}
	
	public void close(Statement stmt, Connection conn) {
		close(null, stmt, conn);
	}
	
}



