package com.mbc.controller;

import java.util.List;

public interface BoardMapper {

	public BoardVO selectOne(int num);
	
	public List<BoardVO> selectAllList();
	
	public int deleteBoard(int num);
	
	public int updateBoard(BoardVO vo);

	public int insertWrite(BoardVO vo);
	
}
