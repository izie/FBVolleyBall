<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  

	Database db = new Database();
try{ 
	//생성자
	PoDAO poDAO = new PoDAO(db);
	PoItemDAO piDAO = new PoItemDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	Po po = new Po();

	//request
	int rowCount	= KUtil.nchkToInt(request.getParameter("rowCount"));
	int seq_po		= KUtil.nchkToInt(request.getParameter("seq_po"));
	po.seq			= seq_po;
	po.taxPrice		= KUtil.comToInt(request.getParameter("taxPrice"),0);
	po.poTotPrice	= KUtil.comToLong(request.getParameter("poTotPrice"),0);

	int instPo = poDAO.updatePo(po);
	if( instPo != 1 ){
		KUtil.scriptAlertBack(out,"수정에러1");
		return;
	}
	
	//발주품목 수정
	Vector vecPoItem = new Vector();
	for( int i=1 ; i<=rowCount ; i++ ){
		PoItem pi = new PoItem();
		pi.seq_po		= seq_po;
		pi.seq_item		= KUtil.nchkToInt(request.getParameter("seq_item"+i));
		pi.cnt			= KUtil.nchkToInt(request.getParameter("itemCnt"+i));
		pi.unitPrice	= KUtil.comToInt(request.getParameter("itemPrice"+i),0);
		pi.itemDim		= KUtil.nchk(request.getParameter("itemDim"+i));
		vecPoItem.add(pi);
	}

	int inst1 = piDAO.update(vecPoItem,seq_po);

	if( inst1 != vecPoItem.size() ){
		KUtil.scriptAlertBack(out,"수정 에러2"); 
		return; 
	}


	//발주 관련 프로젝트 및 계약서 수정
	String[] arrSeq_pnc = request.getParameterValues("seq_pnc");
	System.out.println(arrSeq_pnc.length);
	Vector vecLink = new Vector();
	for( int i=0 ; i<arrSeq_pnc.length ; i++ ){
		Link lk = new Link();
		String []arrPnc = arrSeq_pnc[i].split("@");
		lk.seq_project	= Integer.parseInt(arrPnc[0]);
		lk.seq_contract	= Integer.parseInt(arrPnc[1]);
		lk.seq_po		= seq_po;
		vecLink.add(lk);
	}
	int inst_lk = lkDAO.update(vecLink,seq_po);
	if( inst_lk < 0 ){
		KUtil.scriptAlertBack(out,"에러1");
		return;
	}
		
	
	
	
%>
<SCRIPT LANGUAGE="JavaScript">
alert("수정되었습니다");
opener.document.location.reload();
self.close();
</SCRIPT>
<%
	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>