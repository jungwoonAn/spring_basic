package org.zerock.sample;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

// 단위 Test
@RunWith(SpringJUnit4ClassRunner.class)  // 단위테스트 설정
@Log4j  // 로그 출력
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class SampleTests {

	@Autowired
	private Restaurant restaurant;  // = new Restaurant();
	
	@Autowired
	private Chef chef;
	
	@Autowired
	private SampleHotel sampleHotel;
	
	@Test
	public void testExist() {
		System.out.println("restaurant : " + restaurant);
		System.out.println("restaurant getChef : " + restaurant.getChef());
		log.info("restaurant : " + restaurant);
		System.out.println("chef : " + chef);
	}
	
	@Test
	public void testHotel() {
		System.out.println("sampleHotel : " + sampleHotel);
		System.out.println("sampleHotel getChef : " + sampleHotel.getChef());
	}

}
