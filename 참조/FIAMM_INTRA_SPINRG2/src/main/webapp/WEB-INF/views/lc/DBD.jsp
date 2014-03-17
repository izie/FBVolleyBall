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
	LcDAO lDAO = new LcDAO(db);


	int seq				= KUtil.nchkToInt(request.getParameter("seq"));


	int inst = lDAO.deleteOne(seq);
	if( inst != 1 ){
		KUtil.scriptAlert(out,"삭제에러");
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