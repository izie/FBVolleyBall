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
	EstItemOut eo = new EstItemOut();
	
	int seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	eo.seq_estimate		= KUtil.nchkToInt(request.getParameter("seq_estimate"));
	eo.seq_estItem		= KUtil.nchkToInt(request.getParameter("seq_estItem"));
	eo.deliDate			= KUtil.dateToInt(request.getParameter("deliDate"),0);
	eo.realDeliDate		= KUtil.dateToInt(request.getParameter("realDeliDate"),0);
	eo.setupDate		= KUtil.dateToInt(request.getParameter("setupDate"),0);
	eo.place			= KUtil.nchk(request.getParameter("place"));
	eo.cnt				= KUtil.nchkToInt(request.getParameter("cnt"));
	
	int inst = eoDAO.insert(eo);



	if( inst != 1 ){ 
		KUtil.scriptAlertBack(out,"데이타 입력 에러"); 
		return;
	}


	KUtil.scriptOut(out,"document.location = 'ifme_itemout_list.jsp?seq_project="+seq_project+"';");
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>