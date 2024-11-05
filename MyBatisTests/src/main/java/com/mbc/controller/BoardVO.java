package com.mbc.controller;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardVO {
	
	private int num;
	private String title;
    private String content;
    private String id;
    private Date postdate;
    private int visitcount;
    
}
