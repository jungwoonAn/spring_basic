package org.zerock.mapper;

import java.util.List;
import java.util.Map;

//import org.apache.ibatis.annotations.Select;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardMapper {
	
//	@Select("select * from board where bno > 0")
	public List<BoardVO> getList();
	
	// 페이징처리된 목록
	public List<BoardVO> getListWithPaging(Criteria cri);
	 
	public void insert(BoardVO board);
	
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public int getTotalCount(Criteria cri);	
	
}
