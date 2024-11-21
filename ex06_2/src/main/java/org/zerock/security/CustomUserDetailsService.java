package org.zerock.security;

import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.security.domain.CustomUser;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	
	@Autowired
	private MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws 
		UsernameNotFoundException {
		
		log.warn("Load User By Username : " + username);
		// username = userid
		
		MemberVO vo = memberMapper.read(username);		
		log.warn("quried by member mapper : " + vo);
		
		return vo == null ? null : new CustomUser(vo);
//		return new User(
//				vo.getUserid(), vo.getUserpw(),
//				vo.getAuthList().stream()
//				.map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
//				.collect(Collectors.toList())
//				);
	}
}
