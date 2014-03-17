<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="M"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	String saveDir = request.getRealPath("/up_pds");

	PoDAO poDAO = new PoDAO(db);
	
	
	int seq_po		= KUtil.nchkToInt(request.getParameter("seq_po"));
	int eff			= KUtil.nchkToInt(request.getParameter("eff"),-1);
	String eventMsg = KUtil.nchk(request.getParameter("eventMsg"));

	int inst_po = poDAO.update(seq_po, eff, eventMsg, saveDir);
	if( inst_po != 1 ){
		KUtil.scriptAlertBack(out,"업데이트에러");
		return;
	}
	
%>
<SCRIPT LANGUAGE="JavaScript">
	opener.opener.repage();
	opener.document.location.reload();
	top.window.close();
</SCRIPT>
<%	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>