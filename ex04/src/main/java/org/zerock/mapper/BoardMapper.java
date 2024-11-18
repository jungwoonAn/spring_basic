package org.zerock.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
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
	
	// 댓글 개수 변경, amount : 한번 수정하는 개수(+1 : 댓글등록, -1 : 댓글삭제)
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
	
}
