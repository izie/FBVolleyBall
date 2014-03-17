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
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/joomBox.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function chViewMode(){
	var frm = document.estimateForm0;
	document.frames['iframe0'].location = "list_"+frm.viewMode.value+".jsp";
}
function goWrite(){
	var frm = document.estimateForm0;
	frm.action = "write.jsp";
	frm.submit();
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" onload="chViewMode()">
<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="estimateForm0" method="post">
<tr height=35>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">견적서</FONT></B></td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr align=center height=27>
	<td width="200" class="ti1">
		<select name="viewMode" onchange="chViewMode()">
			<option value="client" <%=viewMode.equals("client")?"selected":""%>>▒▒업체별▒▒</option>
			<option value="project" <%=viewMode.equals("project")?"selected":""%>>▒▒프로젝트별▒▒</option>
		</select></td>
	<td width="500" class="ti1">견적서 리스트</td>
</tr>
<tr height=500>
	<td class="tdAllLine"><iframe id="iframe0" width="200" height="500" frameborder="0"></iframe></td>
	<td class="tdAllLine"><iframe id="iframe1" width="500" height="500" frameborder="0"></iframe></td>
</tr>
<tr align=center height=2 class="bgc2">
	<td colspan=2></td>
</tr>
<tr align=center height=30 class="bgc1">
	<td colspan=2>
		<input type="button" value="리스트 보기" onclick="document.location='list.jsp'">
		<input type="button" value="견적서 입력" onclick="goWrite()"></td>
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