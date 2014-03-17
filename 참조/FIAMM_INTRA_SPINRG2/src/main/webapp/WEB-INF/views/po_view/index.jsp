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
<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height=35>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">젠체 목록</FONT></B></td>
</tr>
</table>
<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr align=center height=28>
	<td class="ti1">PO리스트</td>
	<td class="ti1">구분항목리스트</td>
	<td class="ti1">리스트</td>
</tr>
<tr>
	<td width="200" class="tdAllLine"><iframe name="fme0" src="fme0_po_list.jsp" id="fme0" width="200" height="472" frameborder="0"></iframe></td>

	<td width="200" class="tdAllLine"><iframe name="fme1" id="fme1" width="200" height="472" frameborder="0"></iframe></td>

	<td width="300" class="tdAllLine"><iframe name="fme2" id="fme2" width="300" height="472" frameborder="0"></iframe></td>
</tr>
<tr align=center height=30 class="bgc1">
	<td colspan=3><input type="button" value="견적서 입력" onclick="goWrite()"></td>
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