package org.zerock.service;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {

	@Autowired
	private BoardService service;
	
	@Test
	public void testRegister() {
		
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글3");
		board.setContent("새로 작성하는 글3");
		board.setWriter("user03");
		
		service.register(board);
		
		log.info("생성된 게시물 번호 : " + board.getBno());
	}
	
//	@Test
//	public void testGetList() {
////		List<BoardVO> list = service.getList();		
////		list.forEach(board -> log.info(board));
//		
//		service.getList().forEach(board -> log.info(board));
//	}
	
	@Test
	public void testGetList() {
		
		service.getList(new Criteria(2, 10)).forEach(board -> log.info(board));
	}
	
	@Test
	public void testGet() {
		log.info(service.get(9L));
	}
	
	@Test
	public void testDelete() {
		// 게시물 번호의 존재 여부 확인후 테스트할 것
		log.info("Remove result : " + service.remove(6L));
	}
	
	@Test
	public void testUpdate() {
		
		BoardVO board = service.get(4L);
		
		if(board == null) return;
		
		board.setTitle("제목 수정");
		log.info("Modify result : " + service.modify(board));
	}
}
