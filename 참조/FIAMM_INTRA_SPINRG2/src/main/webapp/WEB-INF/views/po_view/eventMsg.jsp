<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%@ include file="/inc/inc_per_w.jsp"%>

<%
	Database db = new Database();
try{ 
	int	seq_po= KUtil.nchkToInt(request.getParameter("seq_po"));

	PoDAO poDAO = new PoDAO(db);	
	Po po = poDAO.selectOne(seq_po);			%>

<HTML>
<HEAD>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function chkForm(){
	var frm = document.eventMsgForm;
	frm.action = "eventMsg_DBW.jsp";
	frm.submit();
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<form name="eventMsgForm" method="post">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<tr height=25 align=center>
	<td class=ti1><B>PONO:</B> <%=poDAO.getPoNo(po)%> 메모</td>
</tr>
<tr>
	<td><textarea name="eventMsg" style="width:100%;height:100%"><%=KUtil.nchk(po.eventMsg)%></textarea></td>
</tr>
<tr height=25 align=center>
	<td class=bmenu>
		<input type="button" value="입력" class="inputbox2" onclick="chkForm()"></td>
</tr>
</table>
</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
resize(300, 300);
</SCRIPT>

<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
