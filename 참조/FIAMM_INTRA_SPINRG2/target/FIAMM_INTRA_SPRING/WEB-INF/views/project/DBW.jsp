<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>


<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="project"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>


<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  


	
	Database db = new Database();

try{ 
	ClientDAO clDAO = new ClientDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);


	Project pj = new Project();
	String[] arrItemCom = request.getParameterValues("itemCom");

	String reload		= KUtil.nchk(request.getParameter("reload"));
	pj.seq				= DAO.getIncreNum("project");
	pj.seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	pj.seq_clientUser	= KUtil.nchkToInt(request.getParameter("seq_clientUser"));
	pj.name				= KUtil.nchk(request.getParameter("name"));
	pj.stDate			= KUtil.dateToInt(request.getParameter("stDate"),0);
	pj.serial			= KUtil.nchk(request.getParameter("serial"));
	pj.content			= KUtil.nchk(request.getParameter("content"));
	pj.userId			= KUtil.nchk(ui.userId);
	pj.wDate			= KUtil.getIntDate("yyyyMMdd");
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
	
	
	int inst = pDAO.insert(pj);

	


	if( inst != 1 ){ 
		KUtil.scriptAlertBack(out,"데이타 입력 에러"); 
		return;
	}
	
	if( reload.equals("close") ){	
		Client cl = clDAO.selectOne(pj.seq_client);		%>
		<FORM name="tForm">
		<textarea name="proj_name" style="display:none"><%=KUtil.nchk(pj.name)%></textarea>
		<textarea name="client_name_k" style="display:none"><%=KUtil.nchk(cl.bizName)%></textarea>
		<textarea name="client_name_e" style="display:none"><%=KUtil.nchk(cl.engBizName)%></textarea>
		</FORM>
		<SCRIPT LANGUAGE="JavaScript">
		var ofrm = parent.parent.opener.document.estimateForm;
		var frm = document.tForm;
		ofrm.seq_project.value = "<%=pj.seq%>";
		ofrm.projName.value = frm.proj_name.value;
		ofrm.title.value	= frm.proj_name.value;
		ofrm.seq_client.value = "<%=cl.seq%>";
		if( ofrm.language.value == 'ENG' )
			ofrm.client_name.value = frm.client_name_e.value;
		else
			ofrm.client_name.value = frm.client_name_k.value;
		ofrm.seq_clientUser.value="";
		ofrm.clientUser_name.value="";
		top.window.close();
		</SCRIPT>		
<%		return;
	}

	if( reload.length() > 0 ){		%>
		<SCRIPT LANGUAGE="JavaScript">
		try{ <%=reload%>.document.location.reload(); }catch(e){}
		</SCRIPT>		
<%		return;
	}		%>
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