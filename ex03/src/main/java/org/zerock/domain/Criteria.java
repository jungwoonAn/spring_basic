package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	
	private int pageNum;  // 페이지 번호
	private int amount;  // 화면당 게시물 개수
	
	// 검색 처리에 따른 멤버 변수 추가
	private String type;
	private String keyword;
	
	public Criteria() {
		this(1, 10);
	}

	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}	
	
	// 검색 조건이 각 T,C,W로 구성되어, 검색조건을 배열로 만들어 한꺼번에 처리하기 위한 메서드
	public String[] getTypeArr() {
		
		return type==null ? new String[] {} : type.split("");
	}
	
}
