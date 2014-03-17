package com.izect.fiamm.main.controller;

import java.text.DateFormat;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.izect.fiamm.common.util.KUtil;
import com.izect.fiamm.login.service.LoginService;

import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.User;

@Controller
public class MainController{
	private LoginService loginService;
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	public MainController(LoginService loginService){
		this.loginService = loginService;
	}
	

	
	// 메인 로그인 화면
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public RedirectView indexView(HttpSession sess, Model model) throws Exception {
		logger.info("HomeController - Index");
		
		return new RedirectView("/Main/login", true);
	}
	
	// 메인 로그인 화면
	@RequestMapping(value = "/Main/login", method = RequestMethod.GET)
	public String loginView(HttpServletRequest request,HttpSession sess, Model model) throws Exception {
		logger.info("HomeController - login");
		// 외부 접속여부 체크
		String useSms = "N";
		
		int ipc = loginService.ipCheck(request);
		logger.info("IP : "+request.getRemoteAddr());
	    
	    if(ipc != 1)  useSms = "Y";
	    
		model.addAttribute("useSms", useSms);
		
		return "/main/login";
	}
	
	// 로그인 처리
	@RequestMapping(value = "/Main/login/{Action}.json", method = RequestMethod.POST)
	@ResponseBody
	public ModelMap  doLogin(@PathVariable String Action,
							@RequestParam("userId") String userId,
							@RequestParam("passwd") String passwd,
							@RequestParam("smsKey")	String smsKey,
							@RequestParam("outLogin_yn") String outLogin_yn,
							HttpServletRequest request,HttpSession sess) throws Exception {
		logger.info("HomeController - doLogin");
		ModelAndView mv = new ModelAndView();
		ModelMap result = new ModelMap();
		Entity param = new Entity();
		
		if("doLogin".equals(Action)){
			param.setValue("userId", userId);
			param.setValue("passwd", passwd);
			param.setValue("smsKey", smsKey);
			param.setValue("outLogin_yn", outLogin_yn);
			
			int errMsg = loginService.doLogin(sess, request, param);
			
			logger.info("errMsg : "+errMsg);
			
			result.addAttribute("errMsg", errMsg);
		}

		return result;
	}
	
	// 메인 로그인 화면
	@RequestMapping(value = "/Main/", method = RequestMethod.GET)
	public RedirectView introView(HttpServletRequest request,HttpSession sess, Model model) throws Exception {
		logger.info("HomeController - Intro");

		return new RedirectView("/resources/frame/fm_mng.html", true);
	}
	
	// 메인 프레임 화면
	@RequestMapping(value = "/Main/main", method = RequestMethod.GET)
	public String mainFrameView(	HttpServletRequest request,
									HttpSession sess, Model model) throws Exception {
		logger.info("HomeController - mainFrameView");
		// 외부 접속여부 체크
		String rtn_url = "/main/main";
		String lFrame = request.getParameter("leftFrame");
		String rFrame = request.getParameter("rightFrame");
		
		if(lFrame == null)	lFrame = "/Main/menu";
		if(rFrame == null)	rFrame = "/Main/intro";
		
		model.addAttribute("leftFrame", lFrame);
		model.addAttribute("rightFrame", rFrame);
		
		return rtn_url;
	}
	
	// 메뉴 화면
	@RequestMapping(value = "/Main/menu", method = RequestMethod.GET)
	public String menuView(HttpServletRequest request,HttpSession sess, Model model) throws Exception {
		logger.info("HomeController - menuView");
		
		return "/main/menu";
	}
	
	// 메뉴 이미지
	@RequestMapping(value = "/Main/menuImg", method = RequestMethod.GET)
	public String menuImgView(HttpServletRequest request,HttpSession sess, Model model) throws Exception {
		logger.info("HomeController - menuImgView");
		
		return "/main/menu_img";
	}
	
	// 메인 화면
	@RequestMapping(value = "/Main/intro", method = RequestMethod.GET)
	public String mainView(HttpServletRequest request,HttpSession sess, Model model) throws Exception {
		logger.info("HomeController - mainView");
		// 외부 접속여부 체크
		String useSms = "N";
		
		int ipc = loginService.ipCheck(request);
		logger.info("IP : "+request.getRemoteAddr());
	    
	    if(ipc != 1)  useSms = "Y";
	    
		model.addAttribute("useSms", useSms);
		
		return "/main/intro";
	}
	
}
