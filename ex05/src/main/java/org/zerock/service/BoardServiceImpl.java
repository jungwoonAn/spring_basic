package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
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
	
	@Autowired
	private BoardAttachMapper attachMapper;
	
//	public BoardServiceImpl(BoardMapper mapper) {
//		this.mapper = mapper
//	}

	@Override
	public void register(BoardVO board) {
		log.info("register.....");
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
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

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify.....");
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if(modifyResult && board.getAttachList() != null &&
				board.getAttachList().size() > 0) {
			
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove.....");
		
		attachMapper.deleteAll(bno);
		
		return mapper.delete(bno) == 1;
	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		
		return mapper.getTotalCount(cri);
	}
	
	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		
		return attachMapper.findByBno(bno);
	}
}
