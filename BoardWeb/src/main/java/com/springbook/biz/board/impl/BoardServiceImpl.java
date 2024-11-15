package com.springbook.biz.board.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springbook.biz.board.BoardService;
import com.springbook.biz.board.BoardVO;
import com.springbook.biz.common.Log4jAdvice;
import com.springbook.biz.common.LogAdvice;

@Service("boardService")
public class BoardServiceImpl implements BoardService {
	@Autowired
	private BoardDAO boardDAO;
	
//	private LogAdvice advice;
//	private Log4jAdvice advice;
	
	public BoardServiceImpl() {
//		advice = new LogAdvice();
//		advice = new Log4jAdvice();
	}

	public void insertBoard(BoardVO vo) {
//		advice.printLogging();
		boardDAO.insertBoard(vo);
	}

	public void updateBoard(BoardVO vo) {
//		advice.printLogging();
		boardDAO.updateBoard(vo);
	}

	public void deleteBoard(BoardVO vo) {
//		advice.printLogging();
		boardDAO.deleteBoard(vo);
	}

	public BoardVO getBoard(BoardVO vo) {
//		advice.printLogging();
		return boardDAO.getBoard(vo);
	}

	public List<BoardVO> getBoardList(BoardVO vo) {
//		advice.printLogging();
		return boardDAO.getBoardList(vo);
	}
}
