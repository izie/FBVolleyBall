<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<%@ include file="/inc/inc_per_d.jsp"%>

<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{
	TT_paymentDAO tpDAO = new TT_paymentDAO(db);
	
	int seq	= KUtil.nchkToInt(request.getParameter("seq"));


	int inst = tpDAO.delete(seq);
	if( inst != 1 ){
		KUtil.scriptAlert(out,"삭제 에러");
		return;
	}
	
%>
<SCRIPT LANGUAGE="JavaScript">
try{
	try{top.opener.top.opener.repage();}catch(e){}
	try{top.opener.repage();}catch(e){}
	try{top.document.location.reload();}catch(e){}
}catch(e){}
</SCRIPT>			
<%	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>