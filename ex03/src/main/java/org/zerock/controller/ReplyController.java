package org.zerock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/replies")
@Log4j
@RequiredArgsConstructor
public class ReplyController {

	private final ReplyService service;
	
	// localhost:8080/replies/new
	@PostMapping(value = "/new",
			consumes = {MediaType.APPLICATION_JSON_VALUE},  // 요청-json
			produces = {MediaType.TEXT_PLAIN_VALUE})  // 응답-String
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("create : " + vo);
		
		int insertCount = service.register(vo);
		
		return insertCount == 1 ? 
				new ResponseEntity<String>("success", HttpStatus.OK) :
				new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// localhost:8080/replies/pages/130/1
	@GetMapping(value = "/pages/{bno}/{page}", 
			produces = {MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<ReplyVO>> getList(
			@PathVariable("page") int page,
			@PathVariable("bno") Long bno){
		
		log.info("getList - bno : " + bno + ", page : " + page);
		
		Criteria cri = new Criteria(page, 5);
		
		log.info("cri" + cri);
		
		return new ResponseEntity<>(service.getList(cri, bno), HttpStatus.OK);
	}
	
	// http://localhost:8080/replies/26
	@DeleteMapping(value = "/{rno}", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		log.info("remove : " + rno);
		
		return service.remove(rno) == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) :
				new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// http://localhost:8080/replies/24
	@GetMapping(value = "/{rno}", produces = {MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("get : " + rno);
		
		ReplyVO vo = service.get(rno);
		
		return new ResponseEntity<ReplyVO>(vo, HttpStatus.OK);
	}
	
	// http://localhost:8080/replies/24
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{rno}",
			consumes = {MediaType.APPLICATION_JSON_VALUE},
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo,
			@PathVariable("rno") Long ron){
		
		log.info("ron" + ron);
		vo.setRno(ron);
		
		log.info("modify : " + vo);
		
		return service.modify(vo) == 1 ?
				new ResponseEntity<String>("success", HttpStatus.OK) :
				new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
