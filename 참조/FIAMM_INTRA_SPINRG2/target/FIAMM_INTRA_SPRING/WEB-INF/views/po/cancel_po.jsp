<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="M"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

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
	var frm = document.cancenForm;
	if( !confirm("PO를 취소할 경우 다시 복구가 불가능하며\n\n모든 LC,TT,통관 정보가 삭제됩니다.\n\n다음 PO를 취소하시겠습니까?") )
		return;
	frm.action = "cancel_po_DBD.jsp";
	frm.submit();
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">

<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<form name="cancenForm" method="post">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<input type="hidden" name="eff" value="-1">
<tr height=25 align=center>
	<td class=ti1><B>PONO:</B> <%=poDAO.getPoNo(po)%> 취소 사유(특이사항)</td>
</tr>
<tr>
	<td><textarea name="eventMsg" style="width:100%;height:100%"></textarea></td>
</tr>
<tr height=25 align=center>
	<td class=bmenu>
		<input type="button" value="취소입력" class="inputbox2" onclick="chkForm()"></td>
</tr>
</form>
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
