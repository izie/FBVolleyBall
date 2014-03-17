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
	String fileName = KUtil.nchk(request.getParameter("fileName"));	
	String memo		= KUtil.nchk(request.getParameter("memo"));	
	String saveDir	= request.getRealPath("/main/commission/form");

	File file = new File(saveDir, fileName);
	if( fileName.length()<1 || file.exists() ){
		KUtil.scriptAlertBack(out,"이미 존재하는 파일명입니다.");
		return;
	}
	if( !KUtil.fileSave(saveDir, fileName, KUtil.toEng(memo)) ){
		KUtil.scriptAlertBack(out,"파일 저장 에러.");
		return;
	}
%>
<SCRIPT LANGUAGE="JavaScript">
document.location = "frm1_list.jsp";
</SCRIPT>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>