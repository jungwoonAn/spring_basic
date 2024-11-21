package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import lombok.extern.log4j.Log4j;

@RestController  // @Controller + @ResponseBody
@RequestMapping("/sample")
@Log4j
public class SampleController {
	
	// localhost:8080/sample/getText --> 반환 : 안녕하세요 -> ContextType(text/plain)
	@GetMapping(value = "/getText", produces = "text/plain; charset=utf-8")
	
	public String getText() {
		log.info("MIME TYPE : " + MediaType.TEXT_PLAIN_VALUE);
		
		return "안녕하세요";
	}
	
	// localhost:8080/sample/getSample --> 반환 : json, xml
	@GetMapping(value = "/getSample", produces = {MediaType.APPLICATION_JSON_VALUE
												, MediaType.APPLICATION_XML_VALUE})
	public SampleVO getSample() {
		
		return new SampleVO(112, "스타", "로드");
	}
	
	@GetMapping(value = "/getSample2")  // produces속성 생략 가능
	public SampleVO getSample2() {
		
		return new SampleVO(113, "로켓", "라쿤");
	}
	
	// localhost:8080/sample/getList --> 반환 : List
	@GetMapping(value = "/getList")
	public List<SampleVO> getList(){
		
		return IntStream.range(1, 10)
				.mapToObj(i -> new SampleVO(i, i+" First", i+" Last"))
				.collect(Collectors.toList());
	}
	
	// localhost:8080/sample/getMap --> 반환 : Map
	@GetMapping(value = "/getMap")
	public Map<String, SampleVO> getMap(){
		Map<String, SampleVO> map = new HashMap<String, SampleVO>();
		map.put("First", new SampleVO(111, "그루트", "주니어"));
		
		return map;
	}
	
	// localhost:8080/sample/check?height=165&weight=50
	@GetMapping(value = "/check", params = {"height", "weight"})
	public ResponseEntity<SampleVO> check(Double height, Double weight) {
		SampleVO vo = new SampleVO(0, "" + height, "" + weight);
		ResponseEntity<SampleVO> result = null;
		
		if(height < 150) {
			result = ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo);
		}else {
			result = ResponseEntity.status(HttpStatus.OK).body(vo);
		}
		
		return result;
	}
	
	// localhost:8080/sample/product/네로/111
	@GetMapping("/product/{cat}/{pid}")
	public String[] getPath(@PathVariable("cat") String cat, 
							@PathVariable("pid") Integer pid) {
		
		return new String[] {"category : " + cat, "productid : " + pid};
	}
	
	// localhost:8080/sample/ticket --> JSON 
	@PostMapping("/ticket")
	public Ticket convert(@RequestBody Ticket ticket) {
		log.info("convert ticket : " + ticket);
		
		return ticket;
	}
}