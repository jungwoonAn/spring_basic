package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
//@AllArgsConstructor(방법2)  // 단일 파라미터를 받는 생성자 생성하여 파라미터를 자동으로 주입
@RequiredArgsConstructor  //(방법3)
public class BoardServiceImpl implements BoardService {
	
	// spring 4.3이상에서 생성자 어노테이션으로 자동 처리 
//	@Autowired(방법1)
	private final BoardMapper mapper;
	
//	public BoardServiceImpl(BoardMapper mapper) {
//		this.mapper = mapper
//	}

	@Override
	public void register(BoardVO board) {
		log.info("register.....");
		mapper.insertSelectKey(board);
	}
	
//	@Override
//	public List<BoardVO> getList() {
//		log.info("getList.....");
////		List<BoardVO> list = mapper.getList();
////		return list;
//		
//		return mapper.getList();
//	}
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList with criteria : " + cri);

		return mapper.getListWithPaging(cri);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get.....");
		
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify.....");
		
		return mapper.update(board) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove.....");
		
		return mapper.delete(bno) == 1;
	}
}
