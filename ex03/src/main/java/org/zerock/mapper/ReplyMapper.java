package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {
	
	// Create
	public int insert(ReplyVO vo);
	
	// Read
	public ReplyVO read(Long rno);	
	
	// 게시물 하나에 대한 List Read
	public List<ReplyVO> getList(Long bno);
	
	// Delete
	public int delete(Long rno);
	
	// Update
	public int update(ReplyVO vo);
	
	// 댓글 List Paging
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri, 
			@Param("bno") Long bno);
}
