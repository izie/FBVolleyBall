<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%@ include file="/inc/inc_per_w.jsp"%>



<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	
	int seq_po		= KUtil.nchkToInt(request.getParameter("seq_po"));
	String eventMsg	= KUtil.nchk(request.getParameter("eventMsg"));
	
	PoDAO poDAO = new PoDAO(db);
	int inst = poDAO.update(seq_po, eventMsg);

	if( inst != 1 ){
		KUtil.scriptAlertBack(out,"입력에러");
		return;
	}

	
	KUtil.scriptOut(out,"opener.repage();top.window.close();");
	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>