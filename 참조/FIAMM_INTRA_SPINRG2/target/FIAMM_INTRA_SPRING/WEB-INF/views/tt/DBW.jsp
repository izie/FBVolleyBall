<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="lctt"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{
	TtDAO ttDAO = new TtDAO(db);
	Tt tt = new Tt();
	
	tt.seq_po		= KUtil.nchkToInt(request.getParameter("seq_po"));
	tt.seq_passItemLnk	= KUtil.nchkToInt(request.getParameter("seq_pil"));
	tt.invoNum		= KUtil.nchk(request.getParameter("invoNum"));
	tt.invoDate		= KUtil.dateToInt(request.getParameter("invoDate"),0);
	tt.price		= KUtil.comToDouble(request.getParameter("price"),0);
	tt.priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	tt.limitDate	= KUtil.dateToInt(request.getParameter("limitDate"),0);
	tt.payDate		= KUtil.dateToInt(request.getParameter("payDate"),0);
	tt.memo			= KUtil.nchk(request.getParameter("memo"));
	tt.userId		= ui.userId;
	tt.wDate		= KUtil.getIntDate("yyyyMMdd");
	tt.bankName		= KUtil.nchk(request.getParameter("bankName"));
	tt.bankCode		= KUtil.nchk(request.getParameter("bankCode"));
	tt.rate			= KUtil.comToDouble(request.getParameter("rate"),0);
	tt.rPrice		= KUtil.comToDouble(request.getParameter("rPrice"),0);
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));


	int inst = ttDAO.insert(tt);
	if( inst != 1 ){
		KUtil.scriptAlert(out,"입력 에러");
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