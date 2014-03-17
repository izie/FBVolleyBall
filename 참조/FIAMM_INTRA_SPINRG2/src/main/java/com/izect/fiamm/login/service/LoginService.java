package com.izect.fiamm.login.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.User;
import org.springframework.stereotype.Service;

@Service
public interface LoginService {
	public User getUserInfo(Entity param);
	
	// IP 체크
	public int ipCheck(HttpServletRequest request);
	
	//사용자 로그인 처리
	public int doLogin(HttpSession session, HttpServletRequest request, Entity param);
	
	//ID,PW 체크
	public int idPassChk(Entity param);
}
