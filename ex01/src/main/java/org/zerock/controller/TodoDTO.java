package org.zerock.controller;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class TodoDTO {
	private String title;
	
	@DateTimeFormat(pattern = "yyy/MM/dd")
	private Date dueDate;
}
