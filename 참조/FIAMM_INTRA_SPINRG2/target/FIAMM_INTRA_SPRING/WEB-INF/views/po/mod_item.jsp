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
	
	//»ý¼ºÀÚ
	PoDAO poDAO = new PoDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	ProjectDAO pjDAO = new ProjectDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);
	PoItemDAO piDAO = new PoItemDAO(db);

	Po po = poDAO.selectOne(seq_po);
	Vector vecLink = lkDAO.selectOne(seq_po);


%>

<HTML>
<HEAD>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var rowIndex=0;

function showProject(){
	var lft = screen.availWidth-710;
	var tp = screen.availHeight-500;
	var pop = window.open("fme_index.jsp","project","width=700,height=500,top="+tp+",left="+lft);
	pop.focus();
}
function showClientUser(){
	var lft = screen.availWidth-410;
	var pop = window.open("fm_index.jsp","client","width=400,height=350,top=0,left="+lft);
	pop.focus();
}
function initRowCnt(){
	for( var i=rowIndex ; i>0 ; i-- ){
		delRow();
	}
}
function showItem(idx){
	var tp = (screen.availHeight-400)/2;
	var lft = (screen.availWidth-500)/2;
	var pop = window.open("item.jsp?idx="+idx,"item","width=500,height=400,top="+tp+",left="+lft);
	pop.focus();
}
function openWinPo(){
	var frm = document.poForm;
	var lft = screen.availWidth-710;
	var pop = window.open("mod_item.jsp?seq_po=<%=seq_po%>","opWin","width=700,height=500,top=0,left="+lft);
	pop.focus();
}
function initItem(){
	document.frames['itemList'].location="mod_item_init.jsp?seq_po=<%=seq_po%>";
}
function rowIndexAdd(idx){
	var frm = document.poForm;
	rowIndex=idx;
	frm.rowCount.value = idx;
}
function calc(){
	var frm = document.poForm;
	var totPrice = 0;
	for( var i=1 ; i<rowIndex+1 ; i++ ){
		if( eval("document.poForm.itemCnt"+i).value=="" ){
			eval("document.poForm.itemCnt"+i).value = 0;
		}
		if( eval("document.poForm.itemPrice"+i).value=="" ){
			eval("document.poForm.itemPrice"+i).value = 0;
		}
		var rowTotPrice = 
			Number(eval("document.poForm.itemCnt"+i).value.replaceAll(",","")) 
			* Number(eval("document.poForm.itemPrice"+i).value.replaceAll(",",""));
		eval("document.poForm.totPrice"+i).value = rowTotPrice;
		totPrice += rowTotPrice;
	}

	frm.totPrice.value = totPrice;

	if( frm.isTex.checked ){
		frm.taxPrice.value = 0;
	}else{
		frm.taxPrice.value = parseInt(totPrice*0.1);
	}
	frm.poTotPrice1.value = Number(frm.totPrice.value) + Number(frm.taxPrice.value);
	frm.poTotPrice.value = Number(frm.totPrice.value) + Number(frm.taxPrice.value);
	int2Com();
}
function calc1(){
	var frm = document.poForm;
	var totPrice = 0;
	for( var i=1 ; i<rowIndex+1 ; i++ ){
		if( eval("document.poForm.itemCnt"+i).value=="" ){
			eval("document.poForm.itemCnt"+i).value = 0;
		}
		if( eval("document.poForm.itemPrice"+i).value=="" ){
			eval("document.poForm.itemPrice"+i).value = 0;
		}
		var rowTotPrice = 
			Number(eval("document.poForm.itemCnt"+i).value.replaceAll(",","")) 
			* Number(eval("document.poForm.itemPrice"+i).value.replaceAll(",",""));
		eval("document.poForm.totPrice"+i).value = rowTotPrice;
		totPrice += rowTotPrice;
	}

	frm.totPrice.value = totPrice;

	if( frm.isTex.checked ){
		frm.taxPrice.value = 0;
	}
	frm.poTotPrice1.value = Number(frm.totPrice.value) + Number(frm.taxPrice.value);
	frm.poTotPrice.value = Number(frm.totPrice.value) + Number(frm.taxPrice.value);
	int2Com();
}
function int2Com(){
	var frm = document.poForm;
	for( var i=1 ; i<rowIndex+1 ; i++ ){
		intToCom(eval("document.poForm.itemCnt"+i));
		intToCom(eval("document.poForm.itemPrice"+i));
		intToCom(eval("document.poForm.totPrice"+i));
	}
	intToCom(frm.totPrice);
	intToCom(frm.taxPrice);
	intToCom(frm.poTotPrice1);
	intToCom(frm.poTotPrice);
}
//insert table
function addRow(){
	var str = '';
	var form = document.poForm;
	if(rowIndex > 14){ 
		alert("15°³±îÁö Ãß°¡°¡ °¡´ÉÇÕ´Ï´Ù.");
		return;
	}

	var oCurrentRow = insertTable.insertRow();
	rowIndex = oCurrentRow.rowIndex;
	var oCurrentCell = oCurrentRow.insertCell();
	rowIndex++;
	
	str  = "<table cellpadding='0' cellspacing='1' border='0' width='700' height='25'>								";
	str += "<tr height=25 align=center class='r_bg'>																	";
	str += "		<td width='200'>																					";
	str += "			<input type='hidden' name='seq_item"+rowIndex+"' value=''>										";
	str += "			<input type='text' name='itemName"+rowIndex+"' value='' style='width:150'>						";
	str += "			<input type='button' value='¼±ÅÃ' onclick=\"showItem('"+rowIndex+"')\"></td>						";
	str += "		<td width='200'><input type='text' name='itemDim"+rowIndex+"' value='' style='width:199'></td>		";
	str += "		<td width='90'>																						";
	str += "		  <input type='text' name='itemCnt"+rowIndex+"' value='1' size=4 maxlength=10 onkeyup='calc()'></td>";
	str += "		<td width='110'>																					";
	str += "		  <input type='text' name='itemPrice"+rowIndex+"' value='0' size=10 maxlength=10 onkeyup='calc()'></td>";
	str += "		<td width='100'><input type='text' name='totPrice"+rowIndex+"' value='0' size=12 maxlength=14></td>	";
	str += "</tr>																										";
	str += "</table>																									";

	oCurrentCell.innerHTML = str;
	form.rowCount.value = rowIndex;
}
function delRow(){
	var frm = document.poForm;
	if(rowIndex<1){
		return;
	}else{
		frm.rowCount.value = frm.rowCount.value - 1;
		rowIndex--;
		insertTable.deleteRow(rowIndex);
	}
	calc()
}
function poFormCheck(){
	var frm = document.poForm;
	if( !validate(frm) ){
		return false;
	}
	frm.action = "mod_item_all_DBM.jsp";
	return true;
}
function validate(frm){
	if( !chkBoxChk(frm.seq_pnc, 1, "ÇÁ·ÎÁ§Æ® / °è¾à¼­") ) return false;
	else if( rowIndex < 1 || frm.rowCount.value < 1 ){
		alert("¹ßÁÖ Ç°¸ñÀ» ÀÔ·ÂÇØ ÁÖ¼¼¿ä"); return false;
	}
	return true;
}
function delItem(idx){
	var seq_poitem = eval("document.poForm.seq_poitem"+idx).value;
	if( confirm("»èÁ¦ÇÏ½Ã°Ú½À´Ï±î?") ){
		document.location = "mod_item_DBD.jsp?seq_poitem="+seq_poitem+"&seq_po=<%=seq_po%>";	
	}
}
</SCRIPT>
<title>ÇÇ¾ÏÄÚ¸®¾Æ</title>
</HEAD>

<BODY leftmargin="0" topmargin="0" onload="initItem()">
<table cellpadding="0" cellspacing="0" border="0" width="700" >
<form name="poForm" method="post" onsubmit="return poFormCheck()">
<input type="hidden" name="rowCount" value="0">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<tr height=35>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">PO ¼öÁ¤</FONT></B></td>
</tr>
</table>

<!------------------PO------------------------>
<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr  height=25>
	<td colspan=4 class="ti1">&nbsp;¢º PO</td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=25>
	<td width="120" class="title_bg" align=center><A HREF="javascript:showProject()">ÇÁ·ÎÁ§Æ® / °è¾à¼­</A></td>
	<td class="r_bg" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="580" id="inputTbPro">
		</table></td>
</tr>
</table>


<!------------------Ç°¸ñ------------------------>
<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr class="title_bg1" height=25>
	<td>&nbsp;¢º POÇ°¸ñ&nbsp;</td>
	<td align=right>
		<a href="javascript:addRow()">(+)</a> 
		<a href="javascript:delRow()">(-)</a></td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr class="title_bg" height=25>
	<td colspan=5>&nbsp;
		<B>PO ÐÝäþ :</B> <input type="text" name="poTotPrice" value="<%=KUtil.longToCom(po.poTotPrice)%>" size="12" maxlength=14></td>
</tr>
<tr align=center class="title_bg" height=25>
	<td width="200">ù¡ Ù£</td>
	<td width="200">Ð® Ì«</td>
	<td width="90">â¦ Õá</td>
	<td width="100">Ó¤ Ê¤</td>
	<td width="110">ÐÝ äþ</td>
</tr>
</table>
<!-- insert Å×ÀÌºí -->
<table cellpadding="0" cellspacing="0" border="0" width="700" name="insertTable" id="insertTable">
</table>
<!-- total -->
<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr align=center height=25>
	<td width="200" class="title_bg">ÍêÐåÊ¤äþ</td>
	<td width="390" class="r_bg">&nbsp;</td>
	<td width="110" class="title_bg"><input type="text" name="totPrice" value="<%=po.poTotPrice%>" size="12" maxlength=14></td>
</tr>
<tr align=center height=25>
	<td class="title_bg">Ý¾Ê¥Ê¤ö·áª</td>
	<td class="r_bg" align=left>&nbsp;
		<input type="checkbox" name="isTex" value="1" onclick="calc()" <%=po.taxPrice>0?"checked":""%>> ºÎ°¡¼¼ º°µµ</td>
	<td class="title_bg"><input type="text" name="taxPrice" value="<%=po.taxPrice%>" size="12" maxlength=14 onkeyup="calc1()"></td>
</tr>
<tr align=center height=25>
	<td class="title_bg">ùê Íª</td>
	<td class="r_bg">&nbsp;</td>
	<td class="title_bg"><input type="text" name="poTotPrice1" value="<%=po.poTotPrice+po.taxPrice%>" size="12" maxlength=14></td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr align=center height=25 class="title_bg">
	<td colspan=4><input type="submit" value="Ç°¸ñ ¼öÁ¤"></td>
</form>
</tr>
</table>

<iframe id="itemList" width="0" height="0"></iframe>

</BODY>
</HTML>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>