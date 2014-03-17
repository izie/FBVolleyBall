<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="contract"/>
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
	//out.print(saveDir);

	Contract ct = new Contract();
	ContractDAO ctDAO = new ContractDAO(db);
	
	//request
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));
	int reloadval		= KUtil.nchkToInt(request.getParameter("reloadval"));

	ct.seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	ct.seq_clientUser	= KUtil.nchkToInt(request.getParameter("seq_clientUser"));
	ct.seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	ct.seq_estimate		= KUtil.nchkToInt(request.getParameter("seq_estimate"));
	ct.inUserId			= KUtil.nchk(request.getParameter("userId"));
	ct.userId			= ui.userId;
	ct.conDate			= KUtil.dateToInt(request.getParameter("conDate"),0);
	ct.wDate			= KUtil.getIntDate("yyyyMMdd");
	ct.conTotPrice		= KUtil.comToDouble(request.getParameter("conTotPrice"),0);
	ct.priceKinds		= KUtil.nchk(request.getParameter("priceKinds"));
	ct.place			= KUtil.nchk(request.getParameter("place"));
	ct.deliDate			= KUtil.nchk(request.getParameter("deliDate"));
	ct.demandDate		= KUtil.nchk(request.getParameter("demandDate"));
	ct.warrant			= KUtil.dateToInt(request.getParameter("warrant"),0);
	ct.title			= KUtil.nchk(request.getParameter("title"));
	ct.memo				= KUtil.nchk(request.getParameter("memo"));
	ct.contractNum		= KUtil.nchk(request.getParameter("contractNum"));
	ct.isTax			= KUtil.nchkToInt(request.getParameter("isTax"));
	ct.supPrice			= KUtil.comToDouble(request.getParameter("supPrice"),0);
	ct.taxPrice			= KUtil.comToDouble(request.getParameter("taxPrice"),0);
	ct.payMethod		= KUtil.nchk(request.getParameter("payMethod"));
	ct.payMethod1		= KUtil.comToDouble(request.getParameter("payMethod1"),0);	
	ct.payMethod2		= KUtil.comToDouble(request.getParameter("payMethod2"),0);
	ct.payMethod3		= KUtil.comToDouble(request.getParameter("payMethod3"),0);
	ct.fileName			= FileCtl.getString( request.getParameterValues("attFiles"), "");
	
	
	
	ct.prepayDeed		= KUtil.nchkToInt(request.getParameter("prepayDeed"));
	if( ct.prepayDeed > 0 ){
		ct.prepayPer		= KUtil.comToDouble(request.getParameter("prepayPer"),0);
		ct.prepayStDate		= KUtil.nchkToInt(request.getParameter("prepayStDate"));
		ct.prepayEdDate		= KUtil.nchkToInt(request.getParameter("prepayEdDate"));
		ct.prepayContent	= KUtil.nchk(request.getParameter("prepayContent"));
	}

	ct.conDeed			= KUtil.nchkToInt(request.getParameter("conDeed"));
	if( ct.conDeed > 0 ){
		ct.conPer			= KUtil.comToDouble(request.getParameter("conPer"),0);
		ct.conStDate		= KUtil.nchkToInt(request.getParameter("conStDate"));
		ct.conEdDate		= KUtil.nchkToInt(request.getParameter("conEdDate"));
		ct.conContent		= KUtil.nchk(request.getParameter("conContent"));
	}
	

	ct.defectDeed		= KUtil.nchkToInt(request.getParameter("defectDeed"));
	if( ct.defectDeed > 0 ){
		ct.defectPer		= KUtil.comToDouble(request.getParameter("defectPer"),0);
		ct.defectStDate		= KUtil.nchkToInt(request.getParameter("defectStDate"));
		ct.defectEdDate		= KUtil.nchkToInt(request.getParameter("defectEdDate"));
		ct.defectContent	= KUtil.nchk(request.getParameter("defectContent"));
	}

	ct.etcDeed			= KUtil.nchkToInt(request.getParameter("etcDeed"));
	if( ct.etcDeed > 0 ){
		ct.etcPer			= KUtil.comToDouble(request.getParameter("etcPer"),0);
		ct.etcStDate		= KUtil.nchkToInt(request.getParameter("etcStDate"));
		ct.etcEdDate		= KUtil.nchkToInt(request.getParameter("etcEdDate"));
		ct.etcContent		= KUtil.nchk(request.getParameter("etcContent"));
	}
		
	ct.delayDeed		= KUtil.nchkToInt(request.getParameter("delayDeed"));
	if( ct.delayDeed > 0 ){
		ct.delayPer			= KUtil.comToDouble(request.getParameter("delayPer"),0);
		ct.delayContent		= KUtil.nchk(request.getParameter("delayContent"));
	}
	ct._coNum			= KUtil.nchkToInt(request.getParameter("_coNum"));
	ct.coYear			= KUtil.cutIntDateRI(KUtil.dateToInt(request.getParameter("coNum"),0) , 0 , 4 );
	ct.coNum			= KUtil.cutIntDateRI(KUtil.dateToInt(request.getParameter("coNum"),0) , 4 , KUtil.nchk(request.getParameter("coNum")).length() );
	
	int inst[] = ctDAO.insert(ct,saveDir);
	
	if( inst[0] == -2 ){
		KUtil.scriptAlertBack(out,"계약번호 입력 에러");
		return;
	} else if ( inst[0] != 1 ){ 
		KUtil.scriptAlertBack(out,"입력 에러"); 
		return; 
	}
	ct.seq = inst[1];
	
%>

	
<SCRIPT LANGUAGE="JavaScript">
try{
	opener.repage();
}catch(e){
	opener.document.location.reload();
}
document.location.href='view.jsp?seq=<%=ct.seq%>';
</SCRIPT>

<%

	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>