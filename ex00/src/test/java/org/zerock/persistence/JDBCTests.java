package org.zerock.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.junit.Test;

import lombok.extern.log4j.Log4j;

@Log4j
public class JDBCTests {
	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testConnection() throws SQLException {
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String id = "book_ex";
		String pwd = "1234";
		Connection  con = null;
		
		try {
			con = DriverManager.getConnection(url, id, pwd);
			System.out.println("con : " + con);
		}catch(Exception e) {
			fail(e.getMessage());
		}finally {
			con.close();
		}
	}
}
