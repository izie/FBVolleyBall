<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
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
	//multipart
	String saveDir = request.getRealPath("/up_pds");

	//생성자
	PoDAO poDAO = new PoDAO(db);
	PoItemDAO piDAO = new PoItemDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);

	Po po = new Po();

	
	//request
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));
	int rowCount		= KUtil.nchkToInt(request.getParameter("rowCount"));
	String[] seq_pnc	= request.getParameterValues("seq_pnc");
	

	int seq				= KUtil.nchkToInt(request.getParameter("seq_po"));
	

	//발주 관련 프로젝트 및 계약서 수정
	if( seq_pnc != null ){
		Vector vecLink = new Vector();
		for( int i=0 ; i<seq_pnc.length ; i++ ){
			Link lk = new Link();
			String[] arr = seq_pnc[i].split("@");
			lk.seq_project	= Integer.parseInt(arr[0]);
			lk.seq_contract = Integer.parseInt(arr[1]);
			lk.seq_po		= seq;
			vecLink.add(lk);
		}//for

		int inst_lk = lkDAO.update(vecLink);
		if( inst_lk != seq_pnc.length ){
			KUtil.scriptAlertBack(out,"수정에러1");
			return;
		}//if
	}//if
	
	
%>
<SCRIPT LANGUAGE="JavaScript">
try{
	parent.opener.repage();
}catch(e){
	parent.opener.document.location.reload();
}
top.document.location.href="printPo.jsp?seq_po=<%=seq%>";
</SCRIPT>
<%		
	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>