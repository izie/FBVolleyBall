<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	String obj = KUtil.nchk(request.getParameter("obj"));
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function chkFrm(){
	var frm = document.poptxt;
	if( !nchk(frm.poptextarea,"내용") ){
		return false;
	}
	opener.document.poForm.<%=obj%>.value=frm.poptextarea.value;
	self.close();
}
function loadInit(){
	var frm = document.poptxt;
	frm.poptextarea.value = opener.document.poForm.<%=obj%>.value;
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" onload="loadInit()">
<table cellpadding="0" cellspacing="1" border="0" width="100%">
<form name="poptxt" method="post" onsubmit="return chkFrm();">
<tr>
	<td><textarea name="poptextarea" style="width:100%;height:170"></textarea></td>
</tr>
<tr align=center>
	<td><input type="submit" value="데이타 입력" style="width:100%"></td>
</tr>
</form>
</table>
</BODY>
</HTML>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>