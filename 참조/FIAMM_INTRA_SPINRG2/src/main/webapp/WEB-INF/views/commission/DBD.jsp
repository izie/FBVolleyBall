<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="commission"/>
	<jsp:param name="col" value="D"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	CommissionDAO cmDAO = new CommissionDAO(db);

	String saveDir = request.getRealPath("/up_pds");
	int seq = KUtil.nchkToInt(request.getParameter("seq"));
	
	int rst = cmDAO.delete(seq, saveDir);
	
	if( rst < 0 ){
		KUtil.scriptAlertBack(out,"삭제에러");
		return;
	}
	

%>
<SCRIPT LANGUAGE="JavaScript">
try{
	top.opener.repage();
	top.window.close();
}catch(e){
	top.opener.document.location.reload();
	top.window.close();
}

</SCRIPT>
<%


}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>