<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="W"/>
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
	PoItemDAO eiDAO = new PoItemDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	
	Po po = new Po();
	//request
	int rowCount		= KUtil.nchkToInt(request.getParameter("rowCount"));
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));
	String[] seq_pnc		 = request.getParameterValues("seq_pnc");

	po.seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	po.seq_clientUser	= KUtil.nchk(request.getParameter("seq_clientUser"));
	po.userId			= ui.userId;
	po.poUserId			= ui.userId;
	po.title			= KUtil.nchk(request.getParameter("title"));
	po.poDate			= KUtil.getIntDate("yyyyMMdd");
	po.priceKinds		= KUtil.nchk(request.getParameter("priceKinds"));
	po.priceVal			= (double)1;
	po.isTax			= KUtil.nchkToInt(request.getParameter("isTax"));
	po.taxPrice			= KUtil.comToDouble(request.getParameter("taxPrice"),0);
	po.poTotPrice		= KUtil.comToDouble(request.getParameter("viTotPrice"),0);
	po.wDate			= KUtil.dateToInt(request.getParameter("wDate"),0);
	po.endUser			= KUtil.nchk(request.getParameter("endUser"));
	po.timeDeli			= KUtil.nchk(request.getParameter("timeDeli"));
	po.termDeli			= KUtil.nchk(request.getParameter("termDeli"));
	po.termDeliMemo		= KUtil.nchk(request.getParameter("termDeliMemo"));
	po.termPay			= KUtil.nchk(request.getParameter("termPay"));
	po.termPayMemo		= KUtil.nchk(request.getParameter("termPayMemo"));
	po.packing			= KUtil.nchk(request.getParameter("packing"));
	po.remarks			= KUtil.nchk(request.getParameter("remarks"));
	po.fileName			= FileCtl.getString( request.getParameterValues("attFiles"), "");
	po._poNum			= KUtil.nchkToInt(request.getParameter("_poNum"));
	po.poYear			= KUtil.cutIntDateRI(KUtil.nchkToInt(request.getParameter("poNum")), 0, 4);
	po.poNum			= KUtil.cutIntDateRI( KUtil.nchkToInt(request.getParameter("poNum")), 4, 														KUtil.nchk(request.getParameter("poNum")).length());
	po.poCnt			= KUtil.nchkToInt(request.getParameter("poCnt"));
	po.language			= KUtil.nchk(request.getParameter("language"));
	po.poKind			= KUtil.nchk(request.getParameter("poKind"));
	po.flag				= 1;
	

	int inst[] = poDAO.insert(po,saveDir);
	
	if( inst[0] == -4 ){
		KUtil.scriptAlertBack(out,"번호 부여 에러 (error01)"); 
	}else if( inst[0] == -3 ){ 
		KUtil.scriptAlertBack(out,"이미 사용 중인 번호 입니다 (error02)"); 
		return; 
	}else if( inst[0] != 1 ){ 
		KUtil.scriptAlertBack(out,"입력 에러"); 
		return; 
	}
	
	po.seq = inst[1];
	
	
	//품목 입력
	Vector vecPoItem = new Vector();
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
			PoItem pi = new PoItem();
			pi.seq_po		= po.seq;
			pi.seq_item		= seq_item		!= null ? KUtil.nchkToInt(seq_item[i]) : 0 ;
			pi.cnt			= itemCnt		!= null ? KUtil.comToInt(itemCnt[i],0) : 0 ;
			pi.itemName		= itemName		!= null ? KUtil.nchk(itemName[i]) : "" ;
			pi.itemDim		= itemDim		!= null ? KUtil.nchk(itemDim[i]) : "";
			pi.unitPrice	= itemPrice		!= null ? KUtil.comToDouble(itemPrice[i],0) : 0 ;
			pi.totPrice		= totPrice		!= null ? KUtil.comToDouble(totPrice[i],0) : 0 ;
			pi.itemNameMemo = itemNameMemo	!= null ? KUtil.nchk(itemNameMemo[i]) : "";
			pi.itemDimMemo	= itemDimMemo	!= null ? KUtil.nchk(itemDimMemo[i]) : "";
			pi.itemUnit		= itemUnit		!= null ? KUtil.nchk(itemUnit[i]) : "";
			vecPoItem.add(pi);
		}
		int inst1 = eiDAO.insert(vecPoItem);
		if( inst1 != vecPoItem.size() ){
			poDAO.delete(po.seq,saveDir);
			KUtil.scriptAlertBack(out,"입력 에러2"); 
			return; 
		}
	}


	//발주 관련 프로젝트 및 계약서 입력
	if( seq_pnc != null ){
	
		Vector vecLink = new Vector();
		for( int i=0 ; i<seq_pnc.length ; i++ ){
			Link lk = new Link();
			String[] arr = seq_pnc[i].split("@");
			lk.seq_project	= Integer.parseInt(arr[0]);
			lk.seq_contract = Integer.parseInt(arr[1]);
			lk.seq_po		= po.seq;
			vecLink.add(lk);
		}
		
		int inst_lk = lkDAO.insert(vecLink);
		
		if( inst_lk != seq_pnc.length ){
			poDAO.delete(po.seq, saveDir);
			eiDAO.deletePo(po.seq);
			KUtil.scriptAlertBack(out,"입력에러1");
			return;
		}
	}//if

%>
<SCRIPT LANGUAGE="JavaScript">
try{ 
	parent.opener.repage(); 
}catch(e){
	parent.opener.document.location.reload();
}
top.document.location.href="printPo.jsp?seq_po=<%=po.seq%>";
</SCRIPT>
<%		
	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>