<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="D"/>
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
	
	
	int seq_po			= KUtil.nchkToInt(request.getParameter("seq_po"));
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));

	int inst_po = poDAO.delete(seq_po,saveDir);
	if( inst_po == -101 ){
		KUtil.scriptAlertBack(out,"다음을 참조하는 정보가 존재합니다.");
		return;
	}else if( inst_po != 1 ){
		KUtil.scriptAlertBack(out,"삭제에러");
		return;
	}
	
%>
<SCRIPT LANGUAGE="JavaScript">
try{
	opener.repage();
}catch(e){
	opener.document.location.reload();
}
self.close();
</SCRIPT>
<%	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>