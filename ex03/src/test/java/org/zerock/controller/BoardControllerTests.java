package org.zerock.controller;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.WebApplicationContext;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
//Test for Controller
@WebAppConfiguration
public class BoardControllerTests {

	@Autowired
	private WebApplicationContext ctx;
	
	//URL과 파라미터등을 브라우저에서 사용하는 것처럼 만들어서 Controller 실행 테스트
	private MockMvc mockMvc;  // 가상 MVC
	
	@Before  // 모든 테스트 전 매번 실행되는 메서드
	public void setup() {
		// 가상 구조를 세팅, 화면(View)이 없어도 Controller도 테스트 진행 가능
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void testList( ) throws Exception {
		log.info(
				mockMvc.perform(MockMvcRequestBuilders.get("/board/list"))
				.andReturn()  // 반환할 MvcResult를 설정
				.getModelAndView()  // 응답에 대한 모델과 뷰를 담고 있는 ModelAndView 객체를 반환
				.getModelMap());  // 가상환경에서 get 요청을 보내고 요청 받아 model을 map형식으로 확인
	}
	
	@Test
	public void testRegister() throws Exception {
		
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/register")
				.param("title", "테스트 새글 제목")
				.param("content", "테스트 새글 내용")
				.param("writer", "test01")
			).andReturn().getModelAndView().getViewName();
		
		log.info(resultPage);
	}
	
	@Test
	public void testGet() throws Exception {
		
		ModelMap modelMap = mockMvc.perform(MockMvcRequestBuilders.get("/board/get")
				.param("bno", "10"))
			.andReturn().getModelAndView().getModelMap();
		
		log.info("modelMap : " + modelMap);
	}
	
	
	@Test
	public void testRemove() throws Exception {
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
				.param("bno", "5")
			).andReturn().getModelAndView().getViewName();
		
		log.info(resultPage);
	}

}