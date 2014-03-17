package com.izect.fiamm.login.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.izect.fiamm.common.util.PropertyUtil;
import com.izect.fiamm.common.util.PropsUtil;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.User;
import com.izect.fiamm.domain.UserInfo;
import com.izect.fiamm.main.controller.MainController;
import com.izect.fiamm.mapper.UserInfoMapper;

@Service
public class LoginServiceImpl implements LoginService {
	private static final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);
	
	@Autowired
	private UserInfoMapper userInfoMapper;
	
	@Override
	public User getUserInfo(Entity param) {
		// TODO Auto-generated method stub
		logger.info("LoginService - getUserInfo()");
		User temp = userInfoMapper.selectUserOne(param);
		return userInfoMapper.selectUserOne(param);
	}

	@Override
	public int ipCheck(HttpServletRequest request){
		logger.info("LoginService - ipCheck()");
		try{
			//서버 아이피
			String serverIp = PropertyUtil.get("serverIp");
			logger.info("server ip : "+serverIp);
			
			String clientIp = request.getRemoteAddr();
			logger.info("client ip : "+clientIp);
			
			String clientIpCut = clientIp.substring(0,clientIp.lastIndexOf("."));
			
			if( serverIp.indexOf(clientIpCut)<0 ){
				return 103;//"외부접속불가";
				//return 1;	//나중에 지울것
			}
			return 1;
		}catch(Exception e){
			System.out.print(e.toString());
			return 103;
		}
	}

	@Override
	public int doLogin(HttpSession session, HttpServletRequest request, Entity param) {
		User ur = userInfoMapper.selectUserOne(param);

		if( ur.getErrCnt() >= Integer.parseInt(PropertyUtil.get("errCnt")) ){
			return 101;//"비밀번호 오류 "+errMaxCnt+" 회 이상 되어 계정이 잠기었습니다.\\n\\n관리자에게 문의하여 주십시요";
		}

		int chkIdPwd = idPassChk(param);
		if( chkIdPwd != 1){
			return chkIdPwd;		
		}

		if( ur.getGrade() < 1 ){
			return 108;//등급오류
		}

		
		if("Y".equals(param.getString("outLogin_yn"))) {
			if(!"59081004".equals(param.getString("smsKey")))	return 104;
		}

		UserInfo ui	= new UserInfo();
		ui.setUserId(ur.getUserId());
		ui.setAuthIp(request.getRemoteAddr());
		ui.setGrade(ur.getGrade());
		ui.setUserName(ur.getUserName());
		ui.setSmsKey(param.getString("smsKey"));
		ui.setPermission(ur.getPermission());
		ui.setIsadmin(ur.getIsadmin());
		
		
		//최근 접속일 및 에러 횟수 초기화
		userInfoMapper.initFail(param);
		

		session.setAttribute("FIAMM_SESSION_USER",ui);
		
		return 1; //성공
	}

	@Override
	public int idPassChk(Entity param){
		int cnt = userInfoMapper.idPassChk(param);
		
		if(cnt == 0) {
			userInfoMapper.passwdFail(param);
			return 102;//"아이디 및 패스워드를 다시 확인하여 주십시요";
		}else{
			return 1;
		}
		
	}

}
