<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{ 
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));
	PoDAO poDAO = new PoDAO(db);
	PoItemDAO piDAO = new PoItemDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	ProjectDAO pjDAO = new ProjectDAO(db);

	Po po = poDAO.selectOne(seq_po);
	Vector vecPoItem = piDAO.getList(seq_po);
	Vector vecLink = lkDAO.getList(seq_po);

%>

<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>

<form name="itemForm">
<%	for( int i=0 ; i<vecPoItem.size() ; i++ ){	
	PoItem pi = (PoItem)vecPoItem.get(i);			%>
	<textarea name="seq_item" style='display:none'><%=pi.seq_item%></textarea>
	<textarea name="itemName" style='display:none'><%=KUtil.nchk(pi.itemName)%></textarea>	
	<textarea name="itemDim" style='display:none'><%=KUtil.nchk(pi.itemDim)%></textarea>		
	<textarea name="itemNameMemo" style='display:none'><%=KUtil.nchk(pi.itemNameMemo)%></textarea>	
	<textarea name="itemDimMemo" style='display:none'><%=KUtil.nchk(pi.itemDimMemo)%></textarea>		
	<textarea name="itemCnt" style='display:none'><%=pi.cnt%></textarea>
	<textarea name="itemPrice" style='display:none'><%=pi.unitPrice%></textarea>
	<textarea name="totPrice" style='display:none'><%=pi.totPrice%></textarea>
	<textarea name="itemUnit" style='display:none'><%=pi.itemUnit%></textarea>
<SCRIPT LANGUAGE="JavaScript">
var oRow = top.in_table01.insertRow()
var oCell0 = oRow.insertCell();
var oCell1 = oRow.insertCell();
	oCell0.innerHTML = "<IMG SRC='/images/icon_close.gif' BORDER='0' style='cursor:hand' onclick='delRow1()'>";
	oCell1.innerHTML = estStr(); 
</SCRIPT>
<%	}//for					%>
</form>





<SCRIPT LANGUAGE="JavaScript">
	var pfrm = top.document.poForm;
	var frm = document.itemForm;
<%	for( int i=0 ; i<vecPoItem.size() ; i++ ){	 
		String flg = vecPoItem.size() > 1 ? "["+i+"]" : "" ;							%>

	pfrm.seq_item<%=flg%>.value		= frm.seq_item<%=flg%>.value;
	pfrm.itemName<%=flg%>.value		= frm.itemName<%=flg%>.value;
	pfrm.itemDim<%=flg%>.value		= frm.itemDim<%=flg%>.value;
	pfrm.itemNameMemo<%=flg%>.value	= frm.itemNameMemo<%=flg%>.value;
	pfrm.itemCnt<%=flg%>.value		= frm.itemCnt<%=flg%>.value;
	pfrm.itemUnit<%=flg%>.value		= frm.itemUnit<%=flg%>.value;
	var flag = 0;
	//pfrm._itemUnit<%=flg%>.options[0] = new Option("cells","cells");
	//pfrm._itemUnit<%=flg%>.options[1] = new Option("block","block");
	//pfrm._itemUnit<%=flg%>.options[2] = new Option("EA","EA");
	//pfrm._itemUnit<%=flg%>.options[3] = new Option("pc","pc");
	//pfrm._itemUnit<%=flg%>.options[4] = new Option("직접입력","0");
	if( frm.itemUnit<%=flg%>.value=='cell(s)' ){
		pfrm._itemUnit<%=flg%>.options[0].selected=true;
		flag = 1;
	}
	if( frm.itemUnit<%=flg%>.value=='block(s)' ){
		pfrm._itemUnit<%=flg%>.options[1].selected=true;
		flag = 1;
	}
	
	if( frm.itemUnit<%=flg%>.value=='EA' ) {
		pfrm._itemUnit<%=flg%>.options[2].selected=true;
		flag = 1;
	}

	if( frm.itemUnit<%=flg%>.value=='pc(s)' ) {
		pfrm._itemUnit<%=flg%>.options[3].selected=true;
		flag = 1;
	}

	if( frm.itemUnit<%=flg%>.value=='set(s)' ) {
		pfrm._itemUnit<%=flg%>.options[4].selected=true;
		flag = 1;
	}

	if( frm.itemUnit<%=flg%>.value=='lot(s)' ) {
		pfrm._itemUnit<%=flg%>.options[5].selected=true;
		flag = 1;
	}
	
	if( flag==0 ){
		pfrm._itemUnit<%=flg%>.options[6].selected=true;
		pfrm.itemUnit<%=flg%>.style.display = "block";
	}
	
	pfrm.itemPrice<%=flg%>.value	= frm.itemPrice<%=flg%>.value;
	pfrm.totPrice<%=flg%>.value		= frm.totPrice<%=flg%>.value;
<%	}//for	%>	



top.calc1();
pfrm.viTotPrice.value = "<%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","0")%>";
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>