package org.zerock.mapper;

import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {

	@Autowired	
	private ReplyMapper mapper;
	
	@Test
	public void testMapper() {
		log.info("ReplyMapper : " + mapper);
	}
	
	// 테스트 전에 해당 게시물이 존재하는지 반드시 확인
	private Long[] bnoArr = { 22481L, 22482L, 22483L, 22484L, 22485L };
	
	@Test
	public void testCreate() {
		IntStream.rangeClosed(1, 10).forEach(i -> {
//			ReplyVO vo = new ReplyVO();
//			
//			vo.setBno(bnoArr[i%5]);
//			vo.setReply("댓글 테스트 " + i);
//			vo.setReplyer("replyer" + i);
			
			ReplyVO vo = ReplyVO.builder()
					.bno(bnoArr[i%5])
					.reply("댓글 테스트 " + i)
					.replyer("replyer" + i)
					.build();
			
			mapper.insert(vo);
		});
	}
	
	@Test
	public void testRead() {
		ReplyVO vo = mapper.read(3L);
		
		log.info(vo);
	}
	
	@Test
	public void getList() {
		mapper.getList(22481L).forEach(vo -> log.info(vo));
	}
	
	@Test
	public void testDelete() {
		mapper.delete(3L);
	}
	
	@Test
	public void testUpdate() {
		ReplyVO vo = mapper.read(5L);		
		vo.setReply("수정된 댓글");
		
		mapper.update(vo);
	}
	
	@Test
	public void testGetListWithPaging() {
		Criteria cri = new Criteria();
		
		mapper.getListWithPaging(cri, bnoArr[0])
			.forEach(reply -> log.info(reply));
	}
}