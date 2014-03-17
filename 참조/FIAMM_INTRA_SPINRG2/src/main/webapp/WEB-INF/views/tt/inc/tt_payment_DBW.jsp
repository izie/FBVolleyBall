<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<%@ include file="/inc/inc_per_w.jsp"%>

<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{
	TT_paymentDAO tpDAO = new TT_paymentDAO(db);
	TT_payment tp = new TT_payment();
	
	tp.seq_tt		= KUtil.nchkToInt(request.getParameter("seq_tt"));
	tp.pDate		= KUtil.dateToInt(request.getParameter("pDate"),0);
	tp.price		= KUtil.comToDouble(request.getParameter("price"),0);
	tp.memo			= KUtil.nchk(request.getParameter("memo"));


	int inst = tpDAO.insert(tp);
	if( inst != 1 ){
		KUtil.scriptAlert(out,"입력 에러");
		return;
	}
	
%>
<SCRIPT LANGUAGE="JavaScript">
try{
	try{top.opener.top.opener.repage();}catch(e){}
	try{top.opener.document.location.reload();}catch(e){}
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