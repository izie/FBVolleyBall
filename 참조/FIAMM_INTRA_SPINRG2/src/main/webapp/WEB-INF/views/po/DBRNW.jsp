<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
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
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));
	int rowCount		= KUtil.nchkToInt(request.getParameter("rowCount"));
	int seq_po			= KUtil.nchkToInt(request.getParameter("seq_po"));
	String[] seq_pnc	= request.getParameterValues("seq_pnc");
	String[] seq_pnc_	= request.getParameterValues("seq_pnc_");
	Vector vecP = new Vector();
	if( seq_pnc != null ){
		for( int i=0 ; i<seq_pnc.length ; i++ ){
			vecP.add(seq_pnc[i]);
		}
	}
	if( seq_pnc_ != null ){
		for( int i=0 ; i<seq_pnc_.length ; i++ ){
			vecP.add(seq_pnc_[i]);
		}
	}
	
	
	Po _po = poDAO.selectOne(seq_po);

	po.seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	po.seq_clientUser	= KUtil.nchk(request.getParameter("seq_clientUser"));
	po.userId			= ui.userId;
	po.poUserId			= KUtil.nchk(request.getParameter("poUserId"));
	po.title			= KUtil.nchk(request.getParameter("title"));
	po.priceKinds		= KUtil.nchk(request.getParameter("priceKinds"));
	po.priceVal			= (double)1;
	po.taxPrice			= KUtil.comToDouble(request.getParameter("taxPrice"),0);
	po.poTotPrice		= KUtil.comToDouble(request.getParameter("viTotPrice"),0);
	po.poDate			= KUtil.getIntDate("yyyyMMdd");
	po.wDate			= KUtil.dateToInt(request.getParameter("wDate"),0);
	po.endUser			= KUtil.nchk(request.getParameter("endUser"));
	po.timeDeli			= KUtil.nchk(request.getParameter("timeDeli"));
	po.termDeli			= KUtil.nchk(request.getParameter("termDeli"));
	po.termDeliMemo		= KUtil.nchk(request.getParameter("termDeliMemo"));
	po.termPay			= KUtil.nchk(request.getParameter("termPay"));
	po.termPayMemo		= KUtil.nchk(request.getParameter("termPayMemo"));
	po.packing			= KUtil.nchk(request.getParameter("packing"));
	po.remarks			= KUtil.nchk(request.getParameter("remarks"));
	po.fileName			= "";
	po.language			= KUtil.nchk(request.getParameter("language"));
	po._poNum			= 2;
	po.poYear			= _po.poYear;
	po.poNum			= _po.poNum;
	po.poCnt			= _po.poCnt;
	po.poNumIncre		= 0;
	po.flag				= 3;	//리비젼 입력
	po.poKind			= KUtil.nchk(request.getParameter("poKind"));


	int inst[] = poDAO.insert(po,saveDir);
	if( inst[0] == -3 ){
		KUtil.scriptAlertBack(out,"PO MNGNO update 에러");
		return;
	}else if( inst[0] != 1 ){ 
		KUtil.scriptAlertBack(out,"입력 에러"); 
		return; 
	}
	
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
	if( vecP.size() > 0 ){
		Vector vecLink = new Vector();
		for( int i=0 ; i<vecP.size() ; i++ ){
			Link lk = new Link();
			String[] arr = ((String)vecP.get(i)).split("@");
			lk.seq_project	= Integer.parseInt(arr[0]);
			lk.seq_contract = Integer.parseInt(arr[1]);
			lk.seq_po		= po.seq;
			vecLink.add(lk);
		}
		
		int inst_lk = lkDAO.insert(vecLink);
		
		if( inst_lk != vecP.size() ){
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

