<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));

	LcDAO lDAO = new LcDAO(db);
	
	Lc lc = lDAO.selectOnePo(seq_po);
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<form name="topFrm" method="post" onsubmit="return">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<input type="hidden" name="seq" value="">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr height=25>
	<td width="100" class="bk1_1" align=right>L/C 오픈일</td>
	<td width="*" class="bk2_1">&nbsp;<%=KUtil.toDateViewMode(lc.lcOpenDate)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>L/C 번호</td>
	<td class="bk2_1">&nbsp;<%=KUtil.nchk(lc.lcNum,"&nbsp;")%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>L/C 은행명</td>
	<td class="bk2_1">&nbsp;<%=KUtil.nchk(lc.lcBank,"&nbsp;")%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>L/C 금액</td>
	<td class="bk2_1">&nbsp;<%=KUtil.longToCom(lc.lcPrice)%> <%=KUtil.nchk(lc.priceKinds,"&nbsp;")%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>L/C 만기일</td>
	<td class="bk2_1">&nbsp;<%=KUtil.toDateViewMode(lc.lcLimitDate)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>BL</td>
	<td class="bk2_1">&nbsp;<%=KUtil.toDateViewMode(lc.blDate)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>수입 보증금</td>
	<td class="bk2_1">&nbsp;<%=KUtil.longToCom(lc.guarPrice)%></td>
</tr>
</table>
</form>
</table>
</BODY>
</HTML>

<!-- 달력 -->
<div id=box style="position:absolute;background-color: #D9EBCD;width:120;height:25;display:none"></div>

<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>