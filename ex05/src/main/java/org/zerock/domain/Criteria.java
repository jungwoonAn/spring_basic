package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

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
	
	// 게시물 삭제 후 페이지 번호나 검색 조건 유지하면서 이동하기 위한 파라미터 처리
	public String getListLink() {
		
		// 파라미터 전송에 사용되는 문자열(쿼리스트링)을 손쉽게 처리할 수 있는 클래스
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
				
		return builder.toUriString();
	}	
}
