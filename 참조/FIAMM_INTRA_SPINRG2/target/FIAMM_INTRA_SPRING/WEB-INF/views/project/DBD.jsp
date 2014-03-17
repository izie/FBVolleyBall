<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>


<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="project"/>
	<jsp:param name="col" value="D"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>



<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  


	
	Database db = new Database();

try{ 
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));

	
	ProjectDAO pDAO = new ProjectDAO(db);
	int inst = pDAO.delete(seq);



	if( inst == -2 ){
		KUtil.scriptAlertBack(out,"이 프로젝트를 사용중인 자료가 존재합니다."); 
		return;
	}else if( inst != 1 ){ 
		KUtil.scriptAlertBack(out,"데이타 삭제 에러"); 
		return;
	}


%>
<SCRIPT LANGUAGE="JavaScript">
try{
	opener.parent.repage();
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