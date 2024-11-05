package org.zerock.controller;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.sample.Restaurant;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class SampleTests {
	
	// DI, 제어의 역전
	@Autowired
	private Restaurant restaurant; // = new Restaurant();
	
	@Test
	public void testExist() {
		System.out.println("restaurant: " + restaurant);
		log.info("restaurant getChef : " + restaurant.getChef());
		log.info("restaurant: " + restaurant);
	}
}
