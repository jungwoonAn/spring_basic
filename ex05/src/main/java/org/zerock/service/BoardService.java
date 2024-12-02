package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

@Service
public interface BoardService {
	
	public void register(BoardVO board);
	
//	public List<BoardVO> getList();  // 기존 메서드 삭제
	
	public List<BoardVO> getList(Criteria cri);  // 매개변수로 페이징 설정값 받기

	public BoardVO get(Long bno);
	
	public boolean modify(BoardVO board);
	
	public boolean remove(Long bno);
	
	public int getTotal(Criteria cri);
	
	public List<BoardAttachVO> getAttachList(Long bno);
}
