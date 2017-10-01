package work.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

/**
 * ## JDBC ���α׷��� ���� : 
 * 
 * 1. ����̹� �ε� : ������ 
 * 2. db ���� ���� : getConnection() : Connection
 * 
 * 3. sql ��� ����
 * 4. sql ����
 * 5. ���ó��
 * 
 * 6. �ڿ����� : close(rs, stmt, conn), close(stmt, conn)
 *
 * ## JDBC Property : ȯ�漳��
 * 1. driver = ""
 * 2. url = ""
 * 3. user = "hr"
 * 4. password = "tiger"
 * 
 * ## JDBC Exception Handling
 * 1. ClassNotFoundException
 * 2. SQLException
 * 
 * ## JDBC Driver ��ġ 
 * -- Oracle : ojdbc6.jar => jdk6.0 jdbc ���� driver
 * 1. ��ǻ�ͽý���(����) ��� : jdk\jre\lib\ext> ������ ����
 * 2. ������Ʈ ���� ��� : ������ classpath �߰� ����
 * 
 * ## javac / java ����� Ŭ������ ã�ư��� �˻� ��� : classpath
 * 1. rt.jar : Java SE (ǥ�� api)
 * 2. jdk\jre\lib\ext> ������ �ִ� *.jar
 * 3. set classpath=ȯ�漳������������ ����
 * 4. classpath ȯ�溯�� �̼����ÿ��� ���� ����(working directory)
 * 
 * 	## Singleton Pattern
 * 	-- �ϳ��� Ŭ������ ���ؼ� �ϳ��� �ν��Ͻ�(��ü) ����
 * 	-- DAO Ŭ������ ���� ����
 * 	-- ��Ģ:
 * 		1. private ������
 * 		2. public static Ŭ�����̸� getInstance() { return instance; }
 * 		3. private static Ŭ�����̸� instance = new Ŭ�����̸�();
 * 	
 * 	-- Ŭ���� ���
 * 		Ŭ�����̸� ���������� = Ŭ�����̸�.getInstance();
 *  
 * 	## Factory Pattern
 * 	-- FactoryDao Ŭ���� ���� ���� : Singleton Pattern
 * 	-- DAO Ŭ�������� ���
 * 	-- Connection ��ȯ
 * 	-- close() �ڿ�����
 */
 
/**
 * dao Ŭ�������� ����ϱ� ���� Ŭ���� : 
 * -- db connection ����
 * -- db close �ڿ�����
 */
public class FactoryDao {
	private static FactoryDao instance = new FactoryDao();
	
	// �ܺ� �ڿ����� : ResourceBundle ��ü����
	private ResourceBundle resource;
	
	private String driver;
	private String url;
	private String user;
	private String password;
	
	private FactoryDao() {
		// �ܺ� �ڿ����� �����ͼ� �ʱ�ȭ
		resource = ResourceBundle.getBundle("conf/dbserver");
		driver = resource.getString("oracle.driver");
		url = resource.getString("oracle.url");
		user = resource.getString("oracle.user");
		password = resource.getString("oracle.password");
		
		try {
			Class.forName(driver);
		} catch(ClassNotFoundException e) {
			System.out.println("Error : ����̹� �ε� ����");
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
			System.out.println("Error : DB���� ���� ����");
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
			System.out.println("Error : �ڿ����� ����");
			e.printStackTrace(); 
		}
	}
	
	public void close(Statement stmt, Connection conn) {
		close(null, stmt, conn);
	}
	
}



