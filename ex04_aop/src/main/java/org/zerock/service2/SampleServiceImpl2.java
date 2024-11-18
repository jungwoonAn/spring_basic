package org.zerock.service2;

import org.springframework.stereotype.Service;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class SampleServiceImpl2 implements SampleService2 {

	@Override
	public Integer doAdd2(String str1, String str2) {
		log.info("-----doAdd2()-----");

		return Integer.parseInt(str1) + Integer.parseInt(str2);
	}

}
