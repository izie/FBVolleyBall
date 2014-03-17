<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="lctt"/>
	<jsp:param name="col" value="M"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{
	LcDAO lDAO = new LcDAO(db);
	Lc lc = new Lc();

	lc.seq				= KUtil.nchkToInt(request.getParameter("seq"));
	lc.seq_po			= KUtil.nchkToInt(request.getParameter("seq_po"));
	lc.seq_passItemLnk	= KUtil.nchkToInt(request.getParameter("seq_pil"));
	lc.lcOpenDate		= KUtil.dateToInt(request.getParameter("lcOpenDate"),0);
	lc.lcNum			= KUtil.nchk(request.getParameter("lcNum"));
	lc.bankCode			= KUtil.nchk(request.getParameter("bankCode")); 
	lc.bankName			= KUtil.nchk(request.getParameter("bankName")); 
	lc.lcPrice			= KUtil.comToDouble(request.getParameter("lcPrice"),0);
	lc.lcPriceKinds		= KUtil.nchk(request.getParameter("lcPriceKinds"));
	lc.lcLimitDate		= KUtil.dateToInt(request.getParameter("lcLimitDate"),0);
	lc.lcPayDate		= KUtil.dateToInt(request.getParameter("lcPayDate"),0);
	lc.blDate			= KUtil.dateToInt(request.getParameter("lcLimitDate"),0);
	lc.guarPrice		= KUtil.comToDouble(request.getParameter("guarPrice"),0);
	lc.guarPriceKinds	= KUtil.nchk(request.getParameter("guarPriceKinds"));
	lc.memo				= KUtil.nchk(request.getParameter("memo"));
	lc.atsight			= KUtil.nchk(request.getParameter("atsight"));
	lc.userId			= ui.userId;
	lc.wDate			= KUtil.getIntDate("yyyyMMdd");
	lc.blRecDate		= KUtil.dateToInt(request.getParameter("blRecDate"),0);
	lc.rate				= KUtil.comToDouble(request.getParameter("rate"),0);
	lc.rPrice			= KUtil.comToDouble(request.getParameter("rPrice"),0);
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));



	int inst = lDAO.selectWork(lc);
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