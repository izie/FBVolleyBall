<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	String viewMode = KUtil.nchk(request.getParameter("viewMode"),"client");
%>


<HTML>
<HEAD>
<title>�Ǿ��ڸ���</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/editorSimple.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
function chkFile(){
	var frm = document.bForm;
	if( !nchk(frm.fileName,"���ϼ���") ){
		return false;
	}
	frm.target = "fme1";
	frm.action = "frm_file_DBW.jsp";
	return true;
}
function saveFile(){
	var frm = document.bForm;
	if( !nchk(frm.fileName,"����� ���ϸ�") ) return false;
	if( confirm("�����Ͻðڽ��ϱ�?") ){
		frm.target = "fme1";
		frm.action = "fme1_file_save.jsp";
		frm.submit();
	}
}
function inputData(){
	var frm = document.bForm;
	opener.editor_setHTML('memo',"");
	opener.editor_insertHTML('memo', frm.memo.value);
	self.close();
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="500">
<form name="bForm" method="post" onsubmit="return chkFile();">
<tr height=28>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">�⺻������</FONT></B></td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="500">
<tr>
	<td class="tdAllLine"><iframe src="frm1_list.jsp" name="fme1" id="fme1" width="500" height="120" frameborder="0"></iframe></td>
</tr>
<tr>
	<td class="tdAllLine"><textarea name="memo" style="width:500;height:280"></textarea></td>
</tr>
<tr align=center height=2 class="bgc2">
	<td></td>
</tr>
<tr align=center height=28 class="bgc1">
	<td>
		<input type="button" value="���� �Է�" onclick="inputData();" class="inputbox2">
		<input type="text" name="fileName" value="" size="10" maxlength="12" class="inputbox1">
		<input type="button" value="�������Ϸ�����" onclick="saveFile();" class="inputbox2"></td>
</tr>
</form>
</table>
</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
editor_generate("memo");
</SCRIPT>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>