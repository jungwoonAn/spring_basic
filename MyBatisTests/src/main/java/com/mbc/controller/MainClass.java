package com.mbc.controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MainClass {
	
	public static void main(String[] args) {
		String resource = "com/mbc/controller/mybatis-config.xml";  // DB접속 설정
		InputStream inputStream;
		try {
			inputStream = Resources.getResourceAsStream(resource);
			SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
			System.out.println("sqlSessionFactory : " + sqlSessionFactory);
			
			SqlSession session = sqlSessionFactory.openSession(true);  // true넣으면 자동 commit
			System.out.println("session : " + session);
			
			BoardVO vo = new BoardVO();
			
			BoardMapper mapper = session.getMapper(BoardMapper.class);

			// 단건 조회
//			vo = mapper.selectOne(21);
//			System.out.println("vo : " + vo);
			
			// 전체 조회
//			List<BoardVO> lists = mapper.selectAllList();
//			for(BoardVO list : lists)
//				System.out.println(list);

			// 삭제
//			int result = mapper.deleteBoard(24);
//			System.out.println("result : " + result);
			
			
			// 업데이트
//			vo.setTitle("마이바티스");
//			vo.setContent("마이바티스로 데이터 추가..");
//			vo.setNum(21);
//			
//			int result = mapper.updateBoard(vo);
//			System.out.println("result : " + result);
			
			// 삽입
			vo.setTitle("마이바티스");
			vo.setContent("마이바티스로 데이터 추가..");
			vo.setId("test01");
			
			int result = mapper.insertWrite(vo);
			System.out.println("result : " + result);
			
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
