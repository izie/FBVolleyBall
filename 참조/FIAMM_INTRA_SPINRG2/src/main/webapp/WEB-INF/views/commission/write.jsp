<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="commission"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	ClientDAO cDAO		= new ClientDAO(db);

	Vector vecPriceKinds = pkDAO.getList();
	Vector vecClient = cDAO.getClient("매출");
	int seq_project	= KUtil.nchkToInt(request.getParameter("seq_project"));
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function chPriceKinds( nm, id ){
	var frm = document.commissionForm;
	if( eval("document.commissionForm._"+nm).value == 0 ){
		eval("document.commissionForm."+nm).value = "";
		show1(id,"block");
		eval("document.commissionForm."+nm).focus();
	}else{
		eval("document.commissionForm."+nm).value = eval("document.commissionForm._"+nm).value;
		show1(id,"none");
	}
}
function addLink(){
	var pop = window.open("fm_index.jsp","linkadd","resizable=0,scrollbars=0");
	pop.focus();
}
function delRow1(){
	var obj = event.srcElement;
	id_inserttb01.deleteRow(obj.parentNode.parentNode.rowIndex);
}
function formCheck(){
	var frm = document.commissionForm;
	if( !valid(frm) ) return;
	frm.target = "id_dbc01";
	frm.action = "DBW.jsp";
	fileAllSelect();
	frm.submit();
	frm.target = "_self";
}
function valid(frm){
	if( !dateCheck(frm.conDate,"Contract Date") ) return false;
	if( frm._totPriceKinds.value=="0" ){
		if( !nchk(frm.totPriceKinds,"Total Amount 단위") ) return false;
	}
	if( frm._comPriceKinds.value=="0" ){
		if( !nchk(frm.comPriceKinds,"Commission Amount 단위") ) return false;
	}
	if( id_inserttb01.rows.length < 1 ){
		alert("하나이상의 관련 프로젝트를 선택하여 주십시요");
		return false;
	}
	return true;
}
function cvtComma(){
	var frm = document.commissionForm;
	intToCom(frm.totPrice);
	intToCom(frm.comPrice);
}
function basicForm(){
	var lft = (screen.availWidth-500)/2;
	var tp	= (screen.availHeight-490)/2;
	var pop = window.open("frm_index.jsp","formView","width=10,height=10,scrollbars=0,statusbars=0");
	pop.focus();
}
</SCRIPT>
</HEAD>

<BODY class="xnoscroll">
<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="commissionForm" method="post" onsubmit="return false;">
<tr height=28 >
	<td class="ti1">
		&nbsp;▶ Commission Insert</td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700" class="line-table2">
<col width="20%"></col>
<col width="30%"></col>
<col width="15%"></col>
<col width="35%"></col>
<tr height=25 >
	<th>Contract Date</th>
	<td>
		<input type="text" name="conDate" value="<%=KUtil.getDate("yyyyMMdd")%>" size="8" class="inputbox1">
		<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.commissionForm.conDate,'',calStr);showbox3(calStr,'block',50,0,150);" align=absmiddle style="cursor:hand"></td>
	<th>거래처(매출)</th>
	<td>
		<select name="seq_client" class="selbox">
			<option value="">▒매출처선택▒</option>
		<%	for( int i=0 ; i<vecClient.size() ; i++ ){	
				Client cl = (Client)vecClient.get(i);				%>
			<option value="<%=cl.seq%>"><%=KUtil.nchk(cl.bizName)%></option>
		<%	}//for	%>		
		</select></td>
</tr>
<tr>
	<th>Total Amount</th>
	<td><table cellpadding="0" cellspacing="1" border="0"height="100%" class="nontable">
		<tr>
			<td><select name="_totPriceKinds" class="selbox1" onchange="chPriceKinds('totPriceKinds',id_p01)">
			<%	for( int i=0 ; i<vecPriceKinds.size() ; i++ ){	
					String priceKinds  = (String)vecPriceKinds.get(i);	%>
					<option value="<%=priceKinds%>"><%=priceKinds%></option>
			<%	}//for	%>
					<option value="0">직접입력</option>
				</select></td>
			<td id="id_p01" style="display:none">
				<input type="text" name="totPriceKinds" value="\" class="inputbox1" size=5 maxlength="50"></td>
			<td><input type="text" class="inputbox" name="totPrice" value="0" size="12" maxlength=20 onblur="cvtComma()"></td>
		</tr>
		</table></td>
	<th>Commission</th>
	<td>
		<table cellpadding="0" cellspacing="1" border="0"height="100%" class="nontable">
		<tr>
			<td><select name="_comPriceKinds" class="selbox1" onchange="chPriceKinds('comPriceKinds',id_p02)">
			<%	for( int i=0 ; i<vecPriceKinds.size() ; i++ ){	
					String priceKinds  = (String)vecPriceKinds.get(i);	%>
					<option value="<%=priceKinds%>"><%=priceKinds%></option>
			<%	}//for	%>
					<option value="0">직접입력</option>

				</select></td>
			<td id="id_p02" style="display:none">
				<input type="text" name="comPriceKinds" value="\" class="inputbox1" size=5 maxlength="50"></td>
			<td><input type="text" class="inputbox" name="comPrice" value="0" size="12" maxlength=20 onblur="cvtComma()"></td>
		</tr>
		</table></td>
</tr>
<tr>
	<th>Rate(%)</th>
	<td>
		<INPUT TYPE="text" NAME="rate" maxlength=8 size=5 class="inputbox" value="0"> %</td>
	<th>Invoice Date</th>
	<td>
		<input type="text" name="invoDate" value="" size="8" class="inputbox">
		<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.commissionForm.invoDate,'',calStr);showbox3(calStr,'block',0,0,150);" align=absmiddle style="cursor:hand"></td>
</tr>
<tr>
	<th>수금일</th>
	<td colspan=3>
		<input type="text" name="payDate" value="" size="8" class="inputbox">
		<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.commissionForm.payDate,'',calStr);showbox3(calStr,'block',50,0,150);" align=absmiddle style="cursor:hand"></td>
</tr>
<tr>
	<th>파일첨부</th>
	<td colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" class="nontable">
		<tr>
			<td>
				<select class="selbox" name="attFiles" MULTIPLE style="width:100px" size="2">
				</select></td>
			<td	style="padding-left:5">
				<input type="button" onclick="fileAttach()" value="파일추가" class="inputbox2"><br>
				<input type="button" onclick="fileDelete()" value="선택삭제" class="inputbox2"></td>
		</tr>
		</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700" class="line-table2">
<col width="20%"></col>
<col width="30%"></col>
<col width="15%"></col>
<col width="35%"></col>
<tr>
	<th align=center colspan=4>Memo <input type="button" value="기본폼선택" class="inputbox2" onclick="basicForm()"></th>
</tr>
<tr>
	<td align=center colspan=4><textarea name="memo" style="width:100%;height:80"></textarea></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700" class="line-table2">
<col width="20%"></col>
<col width="30%"></col>
<col width="15%"></col>
<col width="35%"></col>
<tr height="20">
	<th align=center colspan=4>
		<A HREF="javascript:addLink()">
		<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT="">
		관련 Project 및 PO 정보 추가
		<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A></th>
</tr>
<tr>
	<td colspan=4>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="line-table3">
		<tr align=center>
			<th width="2%"><IMG SRC="/images/1x1.gif" WIDTH="1" HEIGHT="1" BORDER="0" ALT=""></th>
			<th width="15%">제조사</th>
			<th width="10%">PO</th>
			<th width="73%">Project</th>
		</tr>
		</table></td>
</tr>
<tr>
	<td align=center colspan=4>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" id="id_inserttb01">
		</table></td>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr align=center height=30>
	<td colspan=4>
		<input type="button" value="입력" onclick="formCheck()" class="inputbox2">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</form>
</table>



<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>

<iframe name="id_dbc01" id="id_dbc01" width="0" height="0"></iframe>


</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
resize(726, 470);
editor_generate("memo");
</SCRIPT>


<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
