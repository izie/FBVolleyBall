<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="project"/>
	<jsp:param name="col" value="M"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>



<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  


	
	Database db = new Database();

try{ 
	ClientDAO clDAO = new ClientDAO(db);

	Project pj = new Project();
	
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));
	
	String[] arrItemCom = request.getParameterValues("itemCom");

	pj.seq				= KUtil.nchkToInt(request.getParameter("seq"));
	//pj.seq_client		= KUtil.nchkToInt(request.getParameter("n_seq_client"));
	pj.seq_clientUser	= KUtil.nchkToInt(request.getParameter("seq_clientUser"));
	pj.name				= KUtil.nchk(request.getParameter("name"));
	pj.stDate			= KUtil.nchkToInt(request.getParameter("stDate").replaceAll("\\.",""));
	//pj.serial			= KUtil.nchk(request.getParameter("serial"));
	pj.content			= KUtil.nchk(request.getParameter("content"));
	pj.userId			= KUtil.nchk(ui.userId);
	pj.isCommission		= KUtil.nchkToInt(request.getParameter("isCommission"));
	pj.itemCom			= "";
	pj.com_seq_client	= "";
	
	
	if( arrItemCom != null ){
		for( int i=0 ; i<arrItemCom.length ; i++ ){
			Client cl = clDAO.selectOne(KUtil.nchkToInt(arrItemCom[i],0));
			if( cl.seq > 0 ){
				pj.itemCom		+= i > 0 ? "\n" : "";
				pj.itemCom		+= cl.bizName;
				pj.com_seq_client	+= i > 0 ? "," : "";
				pj.com_seq_client	+= cl.seq+"";
			}			
		}
	}

	ProjectDAO pDAO = new ProjectDAO(db);
	int inst = pDAO.update(pj);



	if( inst != 1 ){ 
		KUtil.scriptAlertBack(out,"데이타 수정 에러"); 
		return;
	}
	
	if( reload == 4 ){
		KUtil.scriptOut(out,"opener.reloadpage();self.close();"); 
	}else{
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
	}
	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>