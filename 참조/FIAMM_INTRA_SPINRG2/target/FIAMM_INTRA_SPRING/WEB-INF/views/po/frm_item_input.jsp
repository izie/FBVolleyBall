<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{ 
	String[] seq_estItem = request.getParameterValues("seq_estItem");
	int rowIndex = KUtil.nchkToInt(request.getParameter("rowIndex"));
	
	int seq_estimate = KUtil.nchkToInt(request.getParameter("seq_estimate"));
	int seq_contract = KUtil.nchkToInt(request.getParameter("seq_contract"));

	EstItemDAO eiDAO = new EstItemDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);
	EstimateDAO emDAO = new EstimateDAO(db);
	ContractDAO cDAO = new ContractDAO(db);
	
	Contract ct = cDAO.selectOne(seq_contract);
	Estimate em = emDAO.selectOne(seq_estimate);
	Project pj = pDAO.selectOne(em.seq_project);
%>


<SCRIPT LANGUAGE="JavaScript">
function getStr(indx){
	var str;
	str  = "<table cellpadding='0' cellspacing='1' border='0' width='700' height='25'>									";
	str += "<tr height=25 align=center class='r_bg'>																	";
	str += "		<td width='200'>																					";
	str += "			<input type='hidden' name='seq_estItem"+indx+"' value=''>										";
	str += "			<input type='hidden' name='seq_item"+indx+"' value=''>											";
	str += "			<input type='text' class='inputbox' name='itemName"+indx+"' value='' style='width:150'>			";
	//str += "			<input type='button' value='삭제' onclick=\"delItem('"+indx+"')\">								";
	str += "			<input type='button' value='선택' onclick=\"showItem('"+indx+"')\"></td>							";
	str += "		<td width='200'><input type='text' class='inputbox' name='itemDim"+indx+"' value='' style='width:199'></td>";
	str += "		<td width='90'>																						";
	str += "		  <input type='text' class='inputbox' name='itemCnt"+indx+"' value='1' size=4 maxlength=10 onkeyup='calc()'></td>	";
	str += "		<td width='110'>																					";
	str += "		  <input type='text' class='inputbox' name='itemPrice"+indx+"' value='0' size=10 maxlength=10 onkeyup='calc()'></td>	";
	str += "		<td width='100'><input type='text' class='inputbox' name='totPrice"+indx+"' value='0' size=12 maxlength=14></td>		";
	str += "</tr>																										";
	str += "</table>																									";
	return str;
}

var idx=<%=rowIndex%>;
<%	for( int i=0 ; i<seq_estItem.length ; i++ ){	%>
	idx++;
	parent.opener.document.getElementById("insertTable").insertRow().insertCell().innerHTML = getStr(idx);
	parent.opener.rowIndexAdd(idx);
<%	}//for	%>


function addVal(i){
	eval("parent.opener.document.poForm.seq_estItem"+i).value = eval("document.itemForm.seq_estItem"+i).value;
	eval("parent.opener.document.poForm.seq_item"+i).value = eval("document.itemForm.seq_item"+i).value;
	eval("parent.opener.document.poForm.itemName"+i).value = eval("document.itemForm.itemName"+i).value;
	eval("parent.opener.document.poForm.itemDim"+i).value = eval("document.itemForm.itemDim"+i).value;
	eval("parent.opener.document.poForm.itemCnt"+i).value = eval("document.itemForm.itemCnt"+i).value;
	eval("parent.opener.document.poForm.itemPrice"+i).value = eval("document.itemForm.itemPrice"+i).value;
	eval("parent.opener.document.poForm.totPrice"+i).value = eval("document.itemForm.totPrice"+i).value;
	
}
</SCRIPT>

<form name="itemForm">
<%	long reTotPrice = 0;
	for( int i=0 ; i<seq_estItem.length ; i++ ){	
		EstItem ei = eiDAO.selectOne(Integer.parseInt(seq_estItem[i]));
		//Item im = iDAO.selectOne(ei.seq_item);
		reTotPrice = ei.cnt*(long)ei.unitPrice;	
%>
	<input type='hidden' name='seq_estItem<%=rowIndex+i+1%>' value="<%=ei.seq%>">
	<input type='hidden' name='seq_item<%=rowIndex+i+1%>' value="<%=ei.seq_item%>">
	<textarea name='itemName<%=rowIndex+i+1%>' style='display:none'><%=KUtil.nchk(ei.itemName)%></textarea>	
	<textarea name='itemDim<%=rowIndex+i+1%>' style='display:none'><%=KUtil.nchk(ei.itemDim)%></textarea>		
	<input type='hidden' name='itemCnt<%=rowIndex+i+1%>' value='<%=ei.cnt%>'>
	<input type='hidden' name='itemPrice<%=rowIndex+i+1%>' value='<%=ei.unitPrice%>'>
	<input type='hidden' name='totPrice<%=rowIndex+i+1%>' value='<%=ei.cnt*(long)ei.unitPrice%>'>
	<SCRIPT LANGUAGE="JavaScript">
	addVal(<%=(rowIndex+i+1)%>);
	</SCRIPT>
<%	}//for					%>
</form>


<SCRIPT LANGUAGE="JavaScript">
parent.opener.calc();
<%	if( pj.seq > 0 ){	%>
	var pInput = parent.opener.document.getElementById("inputTbPro");
	var rIdx = pInput.insertRow().rowIndex;
	rIdx++;
var str = " <input type='checkbox' name='seq_pnc' value='<%=em.seq_project+"@"+seq_contract%>' checked>";
	str +=" <%=KUtil.nchk(pj.name).replaceAll("\"","\'")%> / ";
	str +=" <%=KUtil.nchk(ct.title).replaceAll("\"","\'")%>";
	pInput.insertRow().insertCell().innerHTML = str;
<%	}	%>
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>