<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="commission"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	String saveDir = request.getRealPath("/up_pds");
	CommissionDAO cmDAO = new CommissionDAO(db);
	Commission_linkDAO cmlDAO = new Commission_linkDAO(db);
	ClientDAO cDAO	= new ClientDAO(db);

	Commission_link cml = null;
	Client cl = null;

	Commission cm = new Commission();
	cm.conDate			= KUtil.dateToInt(request.getParameter("conDate"),0);
	cm.totPriceKinds	= KUtil.nchk(request.getParameter("totPriceKinds"));
	cm.totPrice			= KUtil.comToDouble(request.getParameter("totPrice"),0);
	cm.comPriceKinds	= KUtil.nchk(request.getParameter("comPriceKinds"));
	cm.comPrice			= KUtil.comToDouble(request.getParameter("comPrice"),0);
	cm.rate				= KUtil.comToDouble(request.getParameter("rate"),0);
	cm.invoDate			= KUtil.dateToInt(request.getParameter("invoDate"),0);
	cm.payDate			= KUtil.dateToInt(request.getParameter("payDate"),0);
	cm.afile			= FileCtl.getString( request.getParameterValues("attFiles"), "");
	cm.memo				= KUtil.nchk(request.getParameter("memo"));
	cm.seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	if( cm.seq_client > 0 ){
		cl = cDAO.selectOne(cm.seq_client);
	}
	cm.client_name		= cl != null ? KUtil.nchk(cl.bizName) : "" ;
	cm.seq = cmDAO.insert(cm, saveDir);

	if( cm.seq < 1 ){
		KUtil.scriptAlertBack(out,"입력에러");
		return;
	}
	
	//품목 입력
	Vector vecCommi = new Vector();
	String[] seq_client		= request.getParameterValues("seq_client");
	String[] client_name	= request.getParameterValues("client_name");
	String[] seq_po			= request.getParameterValues("seq_po");
	String[] pono			= request.getParameterValues("pono");
	String[] seq_project	= request.getParameterValues("seq_project");
	String[] project_name	= request.getParameterValues("project_name");
	
	if( seq_project != null ){
		for( int i=0 ; i<seq_project.length ; i++ ){
			cml = new Commission_link();
			cml.seq_commission	= cm.seq;
			cml.seq_project		= seq_project	!= null ? KUtil.nchkToInt(seq_project[i]) : 0 ;
			cml.project_name	= project_name	!= null ? KUtil.nchk(project_name[i]) : "" ;
			cml.seq_po			= seq_po		!= null ? KUtil.nchkToInt(seq_po[i]) : 0 ;
			cml.pono			= pono			!= null ? KUtil.nchk(pono[i]) : "" ;
			cml.seq_client		= seq_client	!= null ? KUtil.nchkToInt(seq_client[i]) : 0 ;
			cml.client_name		= client_name	!= null ? KUtil.nchk(client_name[i]) : "" ;
			vecCommi.add(cml);
		}
		int inst1 = cmlDAO.insert(vecCommi);
		if( inst1 != vecCommi.size() ){
			KUtil.scriptAlertBack(out,"입력 에러"); 
			return; 
		}
	}
	
	

%>
<SCRIPT LANGUAGE="JavaScript">
top.opener.repage();
top.document.location.href="view.jsp?seq=<%=cm.seq%>";
</SCRIPT>
<%


}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>