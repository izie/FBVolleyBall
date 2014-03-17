<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="contract"/>
	<jsp:param name="col" value="D"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>



<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	

	ContractDAO ctDAO = new ContractDAO(db);
	String saveDir = request.getRealPath("/up_pds");
	//request
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));
		
	
	int inst = ctDAO.delete(seq,saveDir);
	if( inst == -101 ){
		KUtil.scriptAlertBack(out,"관련 문서가 존재합니다."); 
		return; 
	}else if( inst != 1 ){ 
		KUtil.scriptAlertBack(out,"삭제 에러"); 
		return; 
	}
	
	
	if( reload == 4 ){
		KUtil.scriptOut(out, "opener.reloadpage();self.close();");
		return;
	}else{
		%>
		<SCRIPT LANGUAGE="JavaScript">
		try{
			opener.repage();
		}catch(e){
			opener.document.location.reload();
		}
		self.close();
		</SCRIPT>
		<%		return;
	}
	

	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>