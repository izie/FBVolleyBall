<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	if( seq_client > 0 ){
		KUtil.scriptMove(out,"fm1_project_list.jsp?seq_client="+seq_client+"&winp=1");
		return;
	}
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function addClient(){
	document.frames['fme0'].inClient();
}
function addProject(){
	document.frames['fme1'].id_pa.style.display = "block";
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="600">

<tr align=center height=28>
	<td class="ti1">
		<A HREF="javascript:" onclick="addClient()">
		<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT="">
		업체명
		<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A>
		</td>
	<td class="ti1">
		<A HREF="javascript:" onclick="addProject()">
		<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT="">
		프로젝트명
		<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A></td>
</tr>
<tr>
	<td class="tableoutLine"><iframe id="fme0" src="fm0_client_list.jsp?seq_client=<%=seq_client%>" width="200" height="500" frameborder="0"></iframe></td>
	<td class="tableoutLine"><iframe id="fme1" width="400" height="500" frameborder="0"></iframe></td>
</tr>
</table>
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
resize(620,620);
</SCRIPT>


<%
}catch(Exception e){
	out.print(e.toString());
}
%>