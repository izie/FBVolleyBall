<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	String viewMode = KUtil.nchk(request.getParameter("viewMode"),"client");
	String language = KUtil.nchk(request.getParameter("language"),"ENG");
	
	String[] t1 = {"TIME<br>OF DELIVERY","id='d1' style='cursor:hand' class='menu' onclick='menuDown1(this);show4(di1)'"};
	String[] t2 = {"PLACE<br>OF DELIVERY","id='d2' style='cursor:hand' class='menu' onclick='menuDown1(this);show4(di2)'"};
	String[] t3 = {"TERM<br>OF PAYMENT","id='d3' style='cursor:hand' class='menu' onclick='menuDown1(this);show4(di3)'"};
	String[] t4 = {"PACKING","id='d4' style='cursor:hand' class='menu' onclick='menuDown1(this);show4(di4)'"};
	String[] t5 = {"REMARKS","id='d5' style='cursor:hand' class='menu' onclick='menuDown1(this);show4(di5)'"};
	if( language.equals("KOR") ){	
		t1[0] = "납 기";	
		t2[0] = "납품조건";
		t3[0] = "결재조건";
		t4[0] = "&nbsp;"; t4[1] = "class='menu'";
		t5[0] = "&nbsp;"; t5[1] = "class='menu'";
	}
	
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/editorSimple.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
function chkFile(){
	var frm = document.bForm;
	if( !nchk(frm.fileName,"파일선택") ){
		return false;
	}
	frm.target = "fme1";
	frm.action = "frm_file_DBW.jsp";
	return true;
}
function saveFile(){
	var frm = document.bForm;
	if( !nchk(frm.fileName,"저장될 파일명") ) return false;
	if( confirm("저장하시겠습니까?") ){
		frm.target = "fme1";
		frm.action = "bf_fileSave.jsp";
		frm.submit();
	}
}
function inputData(){
	var frm  = document.bForm;
	var ofrm = opener.document.poForm;
	ofrm.timeDeli.value		= frm.t1.value;
	ofrm.termDeliMemo.value = frm.t2.value;
	ofrm.termPayMemo.value	= frm.t3.value;
	ofrm.packing.value		= frm.t4.value;
	ofrm.remarks.value		= frm.t5.value;
	self.close();
}
function dshow(){
	menuDown1(d1);
}
var eld = null;
function menuDown1(obj) {
	var eSrc = obj;
	if( eld != null ){
		eld.className   = "menu";
	}
	eSrc.className   = "menu_selected";
	eld = eSrc;
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" onload="dshow()">
<table cellpadding="0" cellspacing="1" border="0" width="550">
<form name="bForm" method="post" onsubmit="return chkFile();">
<tr height=28>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">기본폼선택</FONT></B></td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="550">
<tr>
	<td class="tdAllLine">
		<iframe src="bf_fileList.jsp" name="fme1" id="fme1" width="100%" height="120" frameborder="0"></iframe></td>
</tr>
<tr height="45">
	<td class="tdAllLine">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr align=center>
			<td width="20%" <%=t1[1]%>><%=t1[0]%></td>
			<td width="20%" <%=t2[1]%>><%=t2[0]%></td>
			<td width="20%" <%=t3[1]%>><%=t3[0]%></td>
			<td width="20%" <%=t4[1]%>><%=t4[0]%></td>
			<td width="20%" <%=t5[1]%>><%=t5[0]%></td>
		</tr>
		</table></td>
</tr>
<tr height="200">
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr align=center valign=middle>
			<td width="100%" id="di1" style="display:none"><textarea name="t1" style="width:100%;height:98%"></textarea></td>
			<td width="100%" id="di2" style="display:none"><textarea name="t2" style="width:100%;height:98%"></textarea></td>
			<td width="100%" id="di3" style="display:none"><textarea name="t3" style="width:100%;height:98%"></textarea></td>
			<td width="100%" id="di4" style="display:none"><textarea name="t4" style="width:100%;height:98%"></textarea></td>
			<td width="100%" id="di5" style="display:none"><textarea name="t5" style="width:100%;height:98%"></textarea></td>
		</tr>
		</table></td>
</tr>
<tr align=center height=2 class="bgc2">
	<td></td>
</tr>
<tr align=center height=28 class="bgc1">
	<td>
		<input type="button" value="내용 입력" onclick="inputData();" class="inputbox2">
		<input type="text" name="fileName" value="" size="10" maxlength="12" class="inputbox1">
		<input type="button" value="내용파일로저장" onclick="saveFile();" class="inputbox2"></td>
</tr>
</form>
</table>
</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
resize(570,510);
show4(di1);
</SCRIPT>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>