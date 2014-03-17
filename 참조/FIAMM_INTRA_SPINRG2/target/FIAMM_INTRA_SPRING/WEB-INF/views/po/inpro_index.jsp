<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	int seq_project = KUtil.nchkToInt(request.getParameter("seq_project"));
try{ 
%>


<HTML>
<HEAD>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
</HEAD>

<BODY leftmargin="0" topmargin="0">
<form name="formTop" method="post">
<table cellpadding="0" cellspacing="1" border="0" width="700">

<tr align=center height=28>
	<td class="ti1" width="25%">업체 리스트</td>
	<td class="ti1" width="60%">프로젝트 리스트</td>
	<td class="ti1" width="15%">계약서리스트</td>
</tr>

<tr>
	<td class="tdAllLine">
		<iframe name="iframe" src="inpro_fme_client_list.jsp" id="iframe" width="100%" height="250" frameborder="0"></iframe></td>
	<td class="tdAllLine">
		<iframe name="iframe0" id="iframe0" width="100%" height="250" frameborder="0"></iframe></td>
	<td class="tdAllLine">
		<iframe name="iframe2" id="iframe2" width="100%" height="250" frameborder="0"></iframe></td>
</tr>
<tr align=center>
	<td class="ti1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td align=center>품목 리스트</td>
			<td width=50 align=right><input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=3 class="tdAllLine">
		<iframe name="iframe1" id="iframe1" width="100%" height="300" frameborder="0"></iframe></td>
</tr>
</form>
</table>
</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
resize(710,600);
</SCRIPT>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>