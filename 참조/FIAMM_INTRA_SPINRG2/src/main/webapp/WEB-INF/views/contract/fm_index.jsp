<%@page language="Java" contentType="text/html;charset=euc-kr"%>
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
<title>�Ǿ��ڸ���</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<form name="projectForm" method="post">
<tr align=center height=28>
	<td class="ti1">��ü ����Ʈ</td>
	<td class="ti1">������Ʈ ����Ʈ</td>
</tr>
<tr height="350">
	<td width="300" class="tdAllLine">
		<iframe id="iframe" src="fm_client_list.jsp" width="100%" height="100%" frameborder="0"></iframe></td>
	<td width="500" class="tdAllLine"><iframe id="iframe0" width="100%" height="100%" frameborder="0"></iframe></td>
</tr>
<tr height=28>
	<td class="ti1" colspan=2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr align=center>
			<td>������ ����Ʈ</td>
			<td align=right width=50><input type="button" value="�ݱ�" class="inputbox2" onclick="top.window.close();">&nbsp;</td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2 class="tdAllLine"><iframe id="iframe1" width="100%" height="100%" frameborder="0"></iframe></td>
</tr>
</form>
</table>
</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
resize(800,600);
</SCRIPT>


<%
}catch(Exception e){
	out.print(e.toString());
}
%>