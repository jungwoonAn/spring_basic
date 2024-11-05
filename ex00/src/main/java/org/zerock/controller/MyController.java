package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MyController {
	@RequestMapping(value = "/name", method = RequestMethod.GET)
	public String myName(Model model) {
		String name="jungwoon";
		model.addAttribute("myName", name);
		
		return "myName";
	}
}
