<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{ 
	
	
	

	EstItemDAO eiDAO	= new EstItemDAO(db);
	ItemDAO iDAO		= new ItemDAO(db);
	ProjectDAO pDAO		= new ProjectDAO(db);
	EstimateDAO emDAO	= new EstimateDAO(db);
	ContractDAO cDAO	= new ContractDAO(db);
	

	String[] seq_estItem	= request.getParameterValues("seq_estItem");
	int rdx					= KUtil.nchkToInt(request.getParameter("rdx"));
	int seq_project			= KUtil.nchkToInt(request.getParameter("seq_project"));
	int seq_contract		= KUtil.nchkToInt(request.getParameter("seq_contract"));
	
	Project pj  = pDAO.selectOne(seq_project);
	Contract ct = cDAO.selectOne(seq_contract);
	

	Vector vecItem = new Vector();
	if( seq_estItem != null ){	
		for( int i=0 ; i<seq_estItem.length ; i++ ){
			vecItem.add( eiDAO.selectOne(Integer.parseInt(seq_estItem[i])) );
		}
	}

	//KUtil.scriptAlert(out,rdx+"");	
%>


<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>

<form name="itemForm">
<%	for( int i=0 ; i<vecItem.size() ; i++ ){	
	EstItem ei = (EstItem)vecItem.get(i);			%>
	<textarea name="seq_item" style='display:none'><%=ei.seq_item%></textarea>
	<textarea name="itemName" style='display:none'><%=KUtil.nchk(ei.itemName)%></textarea>	
	<textarea name="itemDim" style='display:none'><%=KUtil.nchk(ei.itemDim)%></textarea>		
	<textarea name="itemNameMemo" style='display:none'><%=KUtil.nchk(ei.itemNameMemo)%></textarea>	
	<textarea name="itemDimMemo" style='display:none'><%=KUtil.nchk(ei.itemDimMemo)%></textarea>		
	<textarea name="itemCnt" style='display:none'><%=ei.cnt%></textarea>
	<textarea name="itemPrice" style='display:none'><%=ei.unitPrice%></textarea>
	<textarea name="totPrice" style='display:none'><%=ei.totPrice%></textarea>
	<textarea name="itemUnit" style='display:none'><%=ei.itemUnit%></textarea>
<SCRIPT LANGUAGE="JavaScript">
var oRow = top.opener.in_table01.insertRow()
var oCell0 = oRow.insertCell();
var oCell1 = oRow.insertCell();
	oCell0.innerHTML = "<IMG SRC='/images/icon_close.gif' BORDER='0' style='cursor:hand' onclick='delRow1()'>";
	oCell1.innerHTML = estStr(); 
</SCRIPT>
<%	}//for					%>
</form>


<%	if( seq_estItem != null && seq_estItem.length > 0 ){			%>
<SCRIPT LANGUAGE="JavaScript">
	var pfrm = top.opener.document.poForm;
	var frm = document.itemForm;
	//alert(pfrm.seq_item.length);
<%	for( int i=0 ; i<vecItem.size() ; i++ ){	 
		String flg  = vecItem.size()+rdx > 1 ? "["+(i+rdx)+"]" : "" ;
		String flg1 = vecItem.size() > 1 ? "["+i+"]" : "" ;		%>

	pfrm.seq_item<%=flg%>.value		= frm.seq_item<%=flg1%>.value;
	pfrm.itemName<%=flg%>.value		= frm.itemName<%=flg1%>.value;
	pfrm.itemDim<%=flg%>.value		= frm.itemDim<%=flg1%>.value;
	pfrm.itemNameMemo<%=flg%>.value	= frm.itemNameMemo<%=flg1%>.value;
	pfrm.itemCnt<%=flg%>.value		= frm.itemCnt<%=flg1%>.value;
	pfrm.itemUnit<%=flg%>.value		= frm.itemUnit<%=flg1%>.value;
	var flag = 0;
	if( frm.itemUnit<%=flg1%>.value=='cell(s)' ){
		pfrm._itemUnit<%=flg%>.options[0].selected=true;
		flag = 1;
	}
	if( frm.itemUnit<%=flg1%>.value=='block(s)' ){
		pfrm._itemUnit<%=flg%>.options[1].selected=true;
		flag = 1;
	}
	
	if( frm.itemUnit<%=flg1%>.value=='EA' ) {
		pfrm._itemUnit<%=flg%>.options[2].selected=true;
		flag = 1;
	}

	if( frm.itemUnit<%=flg1%>.value=='pc(s)' ) {
		pfrm._itemUnit<%=flg%>.options[3].selected=true;
		flag = 1;
	}

	if( frm.itemUnit<%=flg1%>.value=='set(s)' ) {
		pfrm._itemUnit<%=flg%>.options[4].selected=true;
		flag = 1;
	}

	if( frm.itemUnit<%=flg1%>.value=='lot(s)' ) {
		pfrm._itemUnit<%=flg%>.options[5].selected=true;
		flag = 1;
	}
	
	if( flag==0 ){
		pfrm._itemUnit<%=flg%>.options[6].selected=true;
		pfrm.itemUnit<%=flg%>.style.display = "block";
	}
	
	//pfrm.itemPrice<%=flg%>.value	= frm.itemPrice<%=flg1%>.value;
	//pfrm.totPrice<%=flg%>.value		= frm.totPrice<%=flg1%>.value;
<%	}//for	%>	


top.opener.calc();
</SCRIPT>
<%	}//if	%>



<SCRIPT LANGUAGE="JavaScript">
	var str  = " <input type='checkbox' name='seq_pnc' value='<%=seq_project+"@"+seq_contract%>' checked>";
		str += " <A HREF='javascript:' onclick='viewProject(<%=pj.seq%>)'><%=KUtil.nchk(pj.name)%></A> ";
<%	if( seq_contract > 0 ){	%>
		str += " / <A HREF='javascript:;' onclick='viewContract(<%=ct.seq%>)'><%=cDAO.getContractNo(ct)%></A>";
<%	}	%>
	parent.opener.document.getElementById("inputTbPro").insertRow().insertCell().innerHTML=str;
	//window.top.self.close();
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>