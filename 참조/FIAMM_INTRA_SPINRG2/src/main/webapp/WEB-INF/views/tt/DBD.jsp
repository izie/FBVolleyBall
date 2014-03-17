<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="lctt"/>
	<jsp:param name="col" value="D"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{
	TtDAO ttDAO = new TtDAO(db);
	
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));


	int inst = ttDAO.deleteOne(seq);
	if( inst == -2 ){
		KUtil.scriptAlert(out,"하위 자료를 먼저 삭제하여 주십시요");
		return;
	}else if( inst != 1 ){
		KUtil.scriptAlert(out,"삭제 에러");
		return;
	}


%>
<SCRIPT LANGUAGE="JavaScript">
try{
	try{top.opener.top.opener.repage();}catch(e){}
	try{top.opener.repage();}catch(e){}
	top.self.close();
}catch(e){}
</SCRIPT>			
<%		
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>