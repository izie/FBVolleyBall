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
	String fileName = request.getParameter("fileName");	
	String saveDir = request.getRealPath("/main/estimate/form");

	File file = new File(saveDir, fileName);
	if( KUtil.nchk(fileName).length()<1 || !file.exists() ){
		KUtil.scriptAlertBack(out,"파일이 존재하지 않습니다.");
		return;
	}
	if( !file.delete() ){
		KUtil.scriptAlertBack(out,"파일이 삭제되지 않습니다.");
		return;
	}
%>
<SCRIPT LANGUAGE="JavaScript">
parent.document.location.reload();
</SCRIPT>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>