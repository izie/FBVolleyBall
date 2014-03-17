<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function inputData(){
	var frm = document.estimateItem;
	if( !nchk(frm.client_name,"거래처") ) return false;
	
	var ofrm = opener.document.projectForm;
	ofrm.seq_client.value = document.estimateItem.seq_client.value;
	ofrm.client_name.value = document.estimateItem.client_name.value;
	ofrm.seq_clientUser.value = document.estimateItem.seq_clientUser.value;
	ofrm.clientUser_name.value = document.estimateItem.clientUser_name.value;
	self.close();
}
function popAddClient(){
	document.frames['iframe0'].popAddClient();
}
function popAddClientUser(){
	var frm = document.estimateItem;

	var lft = (screen.availWidth-700)/2;
	var tp	= (screen.availHeight-500)/2;

	if( !nchk1(frm.seq_client) ){
		alert("거래처를 먼저 선택하여 주십시요");
		return;
	}
	document.frames['iframe1'].popAddClientUser();

}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="100%" height="100%">
<form name="estimateItem" method="post">
<input type="hidden" name="seq_client" value="">
<input type="hidden" name="seq_clientUser" value="">
<tr align=center height=28>
	<td class="ti1">
		<A HREF="javascript:" onclick="popAddClient();">
			<IMG SRC="/images/icon_plus.gif" BORDER="0" ALT="">
			업체명
			<IMG SRC="/images/icon_plus.gif" BORDER="0" ALT=""></A>
		</td>
	<td class="ti1">
		<A HREF="javascript:" onclick="popAddClientUser();">
			<IMG SRC="/images/icon_plus.gif" BORDER="0" ALT="">
			업체담당자
			<IMG SRC="/images/icon_plus.gif" BORDER="0" ALT=""></A>
		</td></td>
</tr>
<tr>
	<td class="tableoutLine" width="50%"><iframe id="iframe0" src="fm0_client_list.jsp?seq_client=<%=seq_client%>" width="100%" height="100%" frameborder="0"></iframe></td>
	<td class="tableoutLine" width="50%"><iframe id="iframe1" width="100%" height="100%" frameborder="0"></iframe></td>
</tr>
<tr height=20 align=center>
	<td colspan=2 class="menu1">
		거래처:<input type="text" name="client_name" value="" size="15" readonly class="inputbox1">
		업체담당자:<input type="text" name="clientUser_name" value="" size="15" readonly class="inputbox">
		<input type="button" value="입력" onclick="inputData()" class="inputbox2"></td>
</tr>
</form>
</table>
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
resize(500,500);
</SCRIPT>


<%
}catch(Exception e){
	out.print(e.toString());
}
%>