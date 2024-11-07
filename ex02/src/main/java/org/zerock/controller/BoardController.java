package org.zerock.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;
import oracle.jdbc.proxy.annotation.Post;

@Controller
@Log4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

	// @RequiredArgsConstructor로 객체생성시 final키워드 필수!
	private final BoardService service;
	
	@GetMapping("/list")
	public void list(Model model) {
		log.info("list.....");
//		List<BoardVO> list = service.getList();
//		model.addAttribute("list", list);
		
		model.addAttribute("list", service.getList()); // /WEB-INF/views/board/list.jsp
	}
	
	@GetMapping("/register")
	public void register() {}  // /WEB-INF/views/board/register.jsp
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : " + board);
		
		service.register(board);
		// ** View 페이지에 속성값 전달 방법
		// addAttribute(): 값을 지속적으로 사용해야할때,
		// addFlashAttribute(): 일회성으로 사용해야할때 사용
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";
	}
	
	@GetMapping("/get")
	public void get(@RequestParam("bno") Long bno, Model model) {
		log.info("get.....");
		
		model.addAttribute("board", service.get(bno));
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr) {
		log.info("modify.....");
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list";
	}	
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
		log.info("remove.....");
		
		if(service.remove(bno)) {  // DB조회가 되면 1(=true)이 반환
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list";
	}
}