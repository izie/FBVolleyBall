<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  
try{ 
	String saveDir	= request.getRealPath("/main/po/form");
	String fileName = KUtil.nchk(request.getParameter("fileName"));	
	
	String t1		= KUtil.nchk(request.getParameter("t1"));	
	String t2		= KUtil.nchk(request.getParameter("t2"));	
	String t3		= KUtil.nchk(request.getParameter("t3"));	
	String t4		= KUtil.nchk(request.getParameter("t4"));	
	String t5		= KUtil.nchk(request.getParameter("t5"));	
	String flag		= "_@@@@_";
	String tot		= t1+flag+t2+flag+t3+flag+t4+flag+t5;

	File file = new File(saveDir, fileName);
	if( fileName.length()<1 || file.exists() ){
		KUtil.scriptAlertBack(out,"이미 존재하는 파일명입니다.");
		return;
	}
	if( !KUtil.fileSave(saveDir, fileName, KUtil.toEng(tot)) ){
		KUtil.scriptAlertBack(out,"파일 저장 에러.");
		return;
	}
%>
<SCRIPT LANGUAGE="JavaScript">
document.location = "bf_fileList.jsp";
</SCRIPT>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>