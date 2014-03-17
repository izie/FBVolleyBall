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
<table cellpadding="0" cellspacing="1" border="0" width="100%">
<tr align=center height=28>
	<td class="ti1">업체리스트</td>
	<td class="ti1">계약서 리스트</td>
	<td class="ti1">품목 리스트</td>
</tr>
<tr>
	<td width="120"><iframe name="iframe0" src="fme0_client_list.jsp" id="iframe0" width="120" height="472" frameborder="1px"></iframe></td>

	<td width="130"><iframe name="iframe1" id="iframe1" width="130" height="472" frameborder="1px"></iframe></td>

	<td width="450"><iframe name="iframe2" id="iframe2" width="450" height="472" frameborder="1px"></iframe></td>
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