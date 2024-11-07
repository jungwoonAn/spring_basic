package org.zerock.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.SampleDTO;
import org.zerock.domain.SampleDTOList;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/sample")
public class SampleController {
	
	@RequestMapping(value="", method=RequestMethod.GET)
	public void basic() {
		log.info("basic....");
	}
	
	@RequestMapping(value="/basic", method= {RequestMethod.GET, RequestMethod.POST})
	public void basicGet() {
		log.info("basic get....");
	}
	
	@GetMapping("/basicOnlyGet")
	public void basicGet2() {
		log.info("basic get only get....");
	}
	
	@GetMapping("/ex01")
	// 매개변수 객체로 값 전달
	public String ex01(SampleDTO dto) {
		log.info("" + dto);
		log.info(dto.getName());
		log.info(dto.getAge());
		return "ex01";
	}
	
	@GetMapping("/ex02")
	// 매개변수 개본 자료형 값 전달
//	public String ex02(String name, int age) {
	public String ex02(@RequestParam("name") String name, 
			@RequestParam("age") int age) {
		log.info(name);
		log.info(age);
		return "ex02";
	}
	
	@GetMapping("/ex02List")
	public String ex02List(@RequestParam("ids") ArrayList<String> ids) {
		log.info("ids : " + ids);
		return "ex02List";
	}
	
	@GetMapping("/ex02Array")
	public String ex02Array(@RequestParam("ids") String[] ids) {
		log.info("Array ids : " + Arrays.toString(ids));
		return "ex02Array";
	}
	
	@GetMapping("/ex02Bean")
	public String ex02Bean(SampleDTOList list) {
		log.info("list : " + list);
		return "ex02Bean";
	}
	
//	@InitBinder
//	public void initBinder(WebDataBinder binder) {
//		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//		binder.registerCustomEditor(java.util.Date.class, 
//				new CustomDateEditor(dateFormat, false));
//	}
	
	@GetMapping("/ex03")
	public String ex03(TodoDTO todo) {
		log.info("todo : " + todo);
		return "ex03";
	}
	
	@GetMapping("/ex04")
	public String ex04(SampleDTO dto, int page) {
		log.info("dto : " + dto);
		log.info("page : " + page);
		return "/sample/ex04";  // /WEB-INF/views/sample/ex04
	}
	
	// Controller 반환타입
	@GetMapping("/ex05")
	public void ex05() {
		log.info("ex05.....");
	}
	
	// @ResponseBody --> 응답을 json타입으로 보냄
	// jackson-databind라이브러리 pom.xml에 추가
	@GetMapping("/ex06")
	public @ResponseBody SampleDTO ex06() {
		log.info("ex06.....");
		
		SampleDTO dto = new SampleDTO();
		dto.setAge(10);
		dto.setName("홍길동");
		
		return dto;
	}
	
	@PostMapping("/ex06_1")
	public String ex06_1(@RequestBody SampleDTO dto) {
		log.info("ex06_1.....");
		log.info("dto : " + dto);
				
		return "sample/ex06";
	}
	
	@GetMapping("/ex07")
	public ResponseEntity<String> ex07(){
		log.info("ex07.....");
		
		// {"name": "홍길동"}
		String msg = "{\"name\": \"홍길동\"}";
		
		HttpHeaders header = new HttpHeaders();
		header.add("Content-Type", "application/json;charset=utf-8");
		
		return new ResponseEntity<String>(msg, header, HttpStatus.OK);
	}
	
	@GetMapping("/exUpload")
	public void exUpload() {
		log.info("exUpload.....");
	}
	
	@PostMapping("/exUploadPost")
	public void exUploadPost(ArrayList<MultipartFile> files) {
		files.forEach(file -> {
			log.info("-----------");
			log.info("name : " + file.getOriginalFilename());
			log.info("size : " + file.getSize());
		});
	}
}
