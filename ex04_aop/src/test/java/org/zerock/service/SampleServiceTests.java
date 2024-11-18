package org.zerock.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.service2.SampleService2;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class SampleServiceTests {
	
	@Test
	public void testClass() {
		log.info(service);
		log.info(service.getClass().getName());
	}
	
	@Autowired
	private SampleService service;
	
	@Test
	public void testAdd() throws Exception {
		log.info(service.doAdd("123", "456"));
	}
	
	@Autowired
	private SampleService2 service2;
	
	@Test
	public void testAdd2() throws Exception {
		log.info(service2.doAdd2("111", "222"));
	}
	
	@Test
	public void testAddError() throws Exception {
		log.info(service.doAdd("123", "ABC"));
	}
	
	@Test
	public void testReturning() throws Exception {
		log.info(service.doAdd("111", "222"));
	}
	
	@Test
	public void testTest() throws Exception {
		service.test();
	}
}
