<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="estimate"/>
	<jsp:param name="col" value="M"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>


<%  

	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	Estimate em = new Estimate();
	EstimateDAO emDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	//request
	
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));
	int rowCount		= KUtil.nchkToInt(request.getParameter("rowCount"));
	int	isModItem		= KUtil.nchkToInt(request.getParameter("isModItem"));
	em.seq				= KUtil.nchkToInt(request.getParameter("seq"));
	em.seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	em.seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	em.seq_clientUser	= KUtil.nchkToInt(request.getParameter("seq_clientUser"));
	em.userId			= ui.userId;
	em.wDate			= KUtil.dateToInt(request.getParameter("wDate"),0);	
	em.priceKinds		= KUtil.nchk(request.getParameter("priceKinds"));
	em.priceVal			= 1;
	em.taxPrice			= KUtil.comToDouble(request.getParameter("taxPrice"),0);
	em.totPrice			= KUtil.comToDouble(request.getParameter("viTotPrice"),0);
	em.inOut			= KUtil.nchk(request.getParameter("inOut"));
	em.edDate			= KUtil.nchkToInt(request.getParameter("edDate"));
	
    em.limitDate		= KUtil.comToDouble(request.getParameter("limitDate"),0);	//납기일 발주후 몇달
	em.limitDateOpt		= KUtil.nchk(request.getParameter("limitDateOpt"),"");
    String limitDateOpt01 = KUtil.nchk(request.getParameter("limitDateOpt01"),"");
    em.limitDateOptFlag = KUtil.nchkToInt(request.getParameter("limitDateOptFlag"),0);
    if (em.limitDateOptFlag > 0) {
        em.limitDate = 0;
        em.limitDateOpt = limitDateOpt01;
    }

	em.payKinds			= KUtil.nchk(request.getParameter("payKinds"));
	em.place			= KUtil.nchk(request.getParameter("place"));
	em.title			= KUtil.nchk(request.getParameter("title"));
	em.memo				= KUtil.nchk(request.getParameter("memo"));
	em.fileName			= "";
	em.isUnit			= KUtil.nchk(request.getParameter("isUnit"));
	em.isTax			= KUtil.nchkToInt(request.getParameter("isTax"));
    em.estComt			= KUtil.nchk(request.getParameter("estComt"));

	int inst = emDAO.update(em);
	if( inst == -101 ){
		KUtil.scriptAlertBack(out,"이 견적서를 참조하는 문서가 존재합니다."); 
		return; 
	}else if( inst != 1 ){ 
		KUtil.scriptAlertBack(out,"내용 수정 에러"); 
		return; 
	}

			
		
	//품목 입력
	Vector vecEstItem = new Vector();
	String[] seq_item		= request.getParameterValues("seq_item");
	String[] itemCnt		= request.getParameterValues("itemCnt");
	String[] itemName		= request.getParameterValues("itemName");
	String[] itemDim		= request.getParameterValues("itemDim");
	String[] itemPrice		= request.getParameterValues("itemPrice");
	String[] totPrice		= request.getParameterValues("totPrice");
	String[] itemNameMemo	= request.getParameterValues("itemNameMemo");
	String[] itemDimMemo	= request.getParameterValues("itemDimMemo");
	String[] itemUnit		= request.getParameterValues("itemUnit");
	
	if( itemUnit != null ){
		for( int i=0 ; i<itemUnit.length ; i++ ){
			EstItem ei = new EstItem();
			ei.seq_estimate = em.seq;
			ei.seq_item		= seq_item		!= null ? KUtil.nchkToInt(seq_item[i]) : 0 ;
			ei.cnt			= itemCnt		!= null ? KUtil.comToInt(itemCnt[i],0) : 0 ;
			ei.itemName		= itemName		!= null ? KUtil.nchk(itemName[i]) : "" ;
			ei.itemDim		= itemDim		!= null ? KUtil.nchk(itemDim[i]) : "";
			ei.unitPrice	= itemPrice		!= null ? KUtil.comToDouble(itemPrice[i],0) : 0 ;
			ei.totPrice		= totPrice		!= null ? KUtil.comToDouble(totPrice[i],0) : 0 ;
			ei.itemNameMemo = itemNameMemo	!= null ? KUtil.nchk(itemNameMemo[i]) : "";
			ei.itemDimMemo	= itemDimMemo	!= null ? KUtil.nchk(itemDimMemo[i]) : "";
			ei.itemUnit		= itemUnit		!= null ? KUtil.nchk(itemUnit[i]) : "";
			vecEstItem.add(ei);
		}
		int inst1 = eiDAO.insert(vecEstItem);
		if( inst1 != vecEstItem.size() ){
			KUtil.scriptAlertBack(out,"입력 에러"); 
			return; 
		}
	}
	//품목 입력
	int inst1 = eiDAO.update(em.seq,vecEstItem);
	if( inst1 != 1 ){
		KUtil.scriptAlertBack(out,"품목 입력 에러"); 
		return; 
	}

	
%>
<SCRIPT LANGUAGE="JavaScript">
try{
	opener.repage();
}catch(e){
	opener.document.location.reload();
}
document.location.href="view.jsp?seq=<%=em.seq%>";
</SCRIPT>
<%
	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>