package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

	// @RequiredArgsConstructor로 객체생성시 final키워드 필수!
	private final BoardService service;
	
//	@GetMapping("/list")
//	public void list(Model model) {
//		log.info("list.....");
////		List<BoardVO> list = service.getList();
////		model.addAttribute("list", list);
//		
//		model.addAttribute("list", service.getList()); // /WEB-INF/views/board/list.jsp
//	}
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list cri : " + cri);

		model.addAttribute("list", service.getList(cri)); // /WEB-INF/views/board/list.jsp
//		model.addAttribute("pageMaker", new PageDTO(cri, 123));
		
		int total = service.getTotal(cri);
		log.info("total : " + total);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	@GetMapping("/register")
	public void register() {}  // /WEB-INF/views/board/register.jsp
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("===================");
		log.info("register : " + board);
		
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		log.info("===================");
		
		service.register(board);
		// ** View 페이지에 속성값 전달 방법
		// addAttribute(): 값을 지속적으로 사용해야할때,
		// addFlashAttribute(): 일회성으로 사용해야할때 사용
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, 
			@ModelAttribute("cri") Criteria cri , Model model) {
		log.info("get or modify.....");
		
		model.addAttribute("board", service.get(bno));
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO board, 
			@ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify : " + board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		// redirect시 속성값으로 hidden 속성값 전달
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());	
		rttr.addAttribute("type", cri.getType());	
		rttr.addAttribute("keyword", cri.getKeyword());	
		
		return "redirect:/board/list";
	}	
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, 
			@ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("remove..." + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {  // DB조회가 되면 1(=true)이 반환
			
			// delete Attach Files
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		
		// redirect시 속성값으로 hidden 속성값 전달
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
//		rttr.addAttribute("type", cri.getType());	
//		rttr.addAttribute("keyword", cri.getKeyword());	
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@GetMapping(value = "/getAttachList",
			produces = {MediaType.APPLICATION_JSON_VALUE})
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList" + bno);
		
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files.....");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + 
									attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbnail = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\s_" + 
									attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(thumbnail);
				}
				
			}catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
}