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


	
	Database db = new Database();

try{ 
	EstItemOutDAO eoDAO = new EstItemOutDAO(db);

	
	int seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	int seq				= KUtil.nchkToInt(request.getParameter("seq"));
		
	int inst = eoDAO.delete(seq);



	if( inst != 1 ){ 
		KUtil.scriptAlertBack(out,"데이타 삭제 에러"); 
		return;
	}


	KUtil.scriptOut(out,"document.location = 'ifme_itemout_list.jsp?seq_project="+seq_project+"';");
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>