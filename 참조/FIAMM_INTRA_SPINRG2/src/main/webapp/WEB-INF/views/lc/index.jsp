<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
%>


<HTML>
<HEAD>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
</HEAD>

<BODY leftmargin="0" topmargin="0">
<form name="formTop" method="post">
<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=35>
	<td colspan=2><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">L/C ����</FONT></B></td>
</tr>
<tr align=center  height=28>
	<td class="ti1">��ü����Ʈ</td>
	<td class="ti1">��༭ ����Ʈ</td>
</tr>
<tr>
	<td class="tdAllLine"><iframe name="iframe0" src="fme0_client_list.jsp" id="iframe0" width="250" height="200" frameborder="0"></iframe></td>

	<td class="tdAllLine"><iframe name="iframe1" id="iframe1" width="450" height="200" frameborder="0"></iframe></td>
</tr>
<tr align=center  height=28>
	<td class="ti1" colspan=2>PO ����Ʈ</td>
</tr>
<tr>
	<td class="tdAllLine" colspan=2><iframe name="iframe2" id="iframe2" width="700" height="280" frameborder="0"></iframe></td>
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