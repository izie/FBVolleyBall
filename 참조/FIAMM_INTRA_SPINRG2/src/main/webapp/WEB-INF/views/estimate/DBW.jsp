<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="estimate"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	//KUtil.scriptAlertBack(out,"test");
	EstimateDAO emDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	ProjectDAO pjDAO = new ProjectDAO(db);

	
	Estimate em = new Estimate();
	
	
	//request
	int rowCount		= KUtil.nchkToInt(request.getParameter("rowCount"));
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));
	int reloadval		= KUtil.nchkToInt(request.getParameter("reloadval"));
	em.seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	em.seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	em.seq_clientUser	= KUtil.nchkToInt(request.getParameter("seq_clientUser"));
	em.userId			= ui.userId;
	em.wDate			= KUtil.dateToInt(request.getParameter("wDate"),0);
	em.priceKinds		= KUtil.nchk(request.getParameter("priceKinds"));
	em.priceVal			= (double)1;
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
	em._estNum			= KUtil.nchkToInt(request.getParameter("_estNum"));
	em.estYear			= KUtil.cutIntDateRI(KUtil.nchkToInt(request.getParameter("estNum")), 0, 4);
	em.estNum			= KUtil.cutIntDateRI( KUtil.nchkToInt(request.getParameter("estNum")), 4, KUtil.nchk(request.getParameter("estNum")).length());
	em.estNumIncre		= KUtil.nchkToInt(request.getParameter("estNumIncre"));
	em.language			= KUtil.nchk(request.getParameter("language"));
    em.estComt			= KUtil.nchk(request.getParameter("estComt"));
    em.estKind			= KUtil.nchk(request.getParameter("estKind"));
    System.out.println("adasd : "+em.inOut);
	int inst[] = emDAO.insert(em);
	
	if( inst[0] == -2 ){
		KUtil.scriptAlertBack(out,"동일한 견적서 일련번호가 존재합니다 다시 입력하여 주십시요!");
		return;
	}else if( inst[0] != 1 ){ 
		KUtil.scriptAlertBack(out,"입력 에러"); 
		return; 
	}

	em.seq = inst[1];

	
	
	
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