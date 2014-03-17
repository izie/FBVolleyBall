<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{ 
	int seq_project = KUtil.nchkToInt(request.getParameter("seq_project"));
	int seq_contract= KUtil.nchkToInt(request.getParameter("seq_contract"));
	int rowIndex	= KUtil.nchkToInt(request.getParameter("rowIndex"));

	ItemDAO iDAO		= new ItemDAO(db);
	ProjectDAO pjDAO	= new ProjectDAO(db);
	ContractDAO cDAO	= new ContractDAO(db);
	EstItemDAO eiDAO	= new EstItemDAO(db);


	Project pj		= pjDAO.selectOne(seq_project);			//프로젝트 정보
	Contract ct = null;
	if( seq_contract > 0 ){
		ct = cDAO.selectOne(seq_contract);
	}
%>
<SCRIPT LANGUAGE="JavaScript">
var pfrm = parent.document.poForm;
var str  = " <input type='checkbox' name='seq_pnc' value='<%=seq_project+"@"+seq_contract%>' checked>";
	str += " <A HREF='javascript:' onclick='viewProject(<%=pj.seq%>)'><%=KUtil.nchk(pj.name)%></A> ";
<%	if( seq_contract > 0 ){	%>
		str += " / <A HREF='javascript:;' onclick='viewContract(<%=seq_contract%>)'><%=cDAO.getContractNo(ct)%></A>";
<%	}	%>
	parent.document.getElementById("inputTbPro").insertRow().insertCell().innerHTML = str;
</SCRIPT>
<%







if( seq_contract > 0 ){
	Vector vecEstItem = eiDAO.getList(ct.seq_estimate);
%>

<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function addVal(i){
	eval("parent.document.poForm.seq_poitem"+i).value = eval("document.itemForm.seq_poitem"+i).value;
	eval("parent.document.poForm.seq_item"+i).value = eval("document.itemForm.seq_item"+i).value;
	eval("parent.document.poForm.itemName"+i).value = eval("document.itemForm.itemName"+i).value;
	eval("parent.document.poForm.itemDim"+i).value = eval("document.itemForm.itemDim"+i).value;
	eval("parent.document.poForm.itemNameMemo"+i).value = eval("document.itemForm.itemNameMemo"+i).value;
	//eval("parent.document.poForm.itemDimMemo"+i).value = eval("document.itemForm.itemDimMemo"+i).value;
	eval("parent.document.poForm.itemCnt"+i).value = eval("document.itemForm.itemCnt"+i).value;
	eval("parent.document.poForm.itemPrice"+i).value = 0;//eval("document.itemForm.itemPrice"+i).value;
	eval("parent.document.poForm.totPrice"+i).value = 0;//eval("document.itemForm.totPrice"+i).value;
	eval("parent.document.poForm.itemUnit"+i).value = eval("document.itemForm.itemUnit"+i).value;
	
	if( eval("document.itemForm.itemUnit"+i).value=='cells' )
		eval("parent.document.poForm._itemUnit"+i).options[0].selected=true;
	else if( eval("document.itemForm.itemUnit"+i).value=='blocks' )
		eval("parent.document.poForm._itemUnit"+i).options[1].selected=true;
	else if( eval("document.itemForm.itemUnit"+i).value=='EA' )
		eval("parent.document.poForm._itemUnit"+i).options[2].selected=true;
	else if( eval("document.itemForm.itemUnit"+i).value=='pc' )
		eval("parent.document.poForm._itemUnit"+i).options[3].selected=true;
	else{
		eval("parent.document.poForm._itemUnit"+i).options[4].selected=true;
		eval("parent.document.poForm.itemUnit"+i).style.display = "block";
	}
}

var idx=<%=rowIndex%>;
<%	for( int i=0 ; i<vecEstItem.size() ; i++ ){	%>
	idx++;
	parent.document.getElementById("insertTable").insertRow().insertCell().innerHTML = getPoStr(idx);
	parent.rowIndexAdd(idx);
<%	}//for	%>

</SCRIPT>

<form name="itemForm">
<%	double reTotPrice = 0;
	for( int i=0 ; i<vecEstItem.size() ; i++ ){	
		EstItem ei = (EstItem)vecEstItem.get(i);
		reTotPrice = ei.totPrice;	
%>
	<textarea name='seq_poitem<%=rowIndex+i+1%>' style='display:none'><%=ei.seq%></textarea>
	<textarea name='seq_item<%=rowIndex+i+1%>' style='display:none'><%=ei.seq_item%></textarea>
	<textarea name='itemName<%=rowIndex+i+1%>' style='display:none'><%=KUtil.nchk(ei.itemName)%></textarea>	
	<textarea name='itemDim<%=rowIndex+i+1%>' style='display:none'><%=KUtil.nchk(ei.itemDim)%></textarea>		
	<textarea name='itemNameMemo<%=rowIndex+i+1%>' style='display:none'><%=KUtil.nchk(ei.itemNameMemo)%></textarea>	
	<textarea name='itemDimMemo<%=rowIndex+i+1%>' style='display:none'><%=KUtil.nchk(ei.itemDimMemo)%></textarea>		
	<textarea name='itemCnt<%=rowIndex+i+1%>' style='display:none'><%=ei.cnt%></textarea>
	<textarea name='itemPrice<%=rowIndex+i+1%>' style='display:none'><%=NumUtil.numToFmt(ei.unitPrice,"##.##","0")%></textarea>
	<textarea name='totPrice<%=rowIndex+i+1%>' style='display:none'><%=NumUtil.numToFmt(ei.totPrice,"##.##","0")%></textarea>
	<input type='hidden' name='itemUnit<%=rowIndex+i+1%>' value='<%=ei.itemUnit%>'>
	<SCRIPT LANGUAGE="JavaScript">
	addVal(<%=(rowIndex+i+1)%>);
	</SCRIPT>
<%	}//for							%>
</form>


<%

}//if

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>