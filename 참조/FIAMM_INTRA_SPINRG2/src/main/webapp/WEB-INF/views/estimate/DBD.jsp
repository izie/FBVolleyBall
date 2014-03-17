<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="estimate"/>
	<jsp:param name="col" value="D"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	//request
	int seq = KUtil.nchkToInt(request.getParameter("seq"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));
	if( seq < 1 ){
		KUtil.scriptAlertBack(out,"���� ��ȣ�� �ùٸ��� �ʽ��ϴ�.");
		return;
	}
	
	EstimateDAO emDAO = new EstimateDAO(db);
	
	int inst = emDAO.delete(seq);
	if( inst == -101 ){
		KUtil.scriptAlertBack(out,"�� �������� ������� �ڷᰡ �����մϴ�.");
		return;
	}else if( inst != 1 ){
		KUtil.scriptAlertBack(out,"���� ����");
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