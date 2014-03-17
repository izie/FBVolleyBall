<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="commission"/>
	<jsp:param name="col" value="V"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	CommissionDAO cmDAO = new CommissionDAO(db);
	Commission_linkDAO cmlDAO = new Commission_linkDAO(db);
	
	int seq	= KUtil.nchkToInt(request.getParameter("seq"));

	Commission cm = cmDAO.selectOne(seq);
	Vector vecCml = cmlDAO.getList(cm.seq);
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function goModify(){
	var frm = document.commissionForm;
	frm.action = "mod.jsp";
	frm.submit();
}
function goDelete(){
	var frm = document.commissionForm;
	frm.action = "DBD.jsp";
	frm.submit();
}
</SCRIPT>
</HEAD>

<BODY class="xnoscroll">
<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="commissionForm" method="post" onsubmit="return false;">
<input type="hidden" name="seq" value="<%=seq%>">
<tr height=28 >
	<td class="ti1">
		&nbsp;▶ Commission Insert</td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<col width="20%"></col>
<col width="30%"></col>
<col width="15%"></col>
<col width="35%"></col>
<tr height=25 >
	<td class="bk1_1" align=right>Contract Date</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.dateMode(cm.conDate,"yyyyMMdd","yy, MM, dd","")%></td>
	<td class="bk1_1" align=right>거래처(매출)</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.nchk(cm.client_name)%></td>
</tr>
<tr height="23">
	<td class="bk1_1" align=right>Total Amount</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.nchk(cm.totPriceKinds)%> <%=NumUtil.numToFmt(cm.totPrice,"###,###.##","")%></td>
	<td class="bk1_1" align=right>Commission</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.nchk(cm.comPriceKinds)%> <%=NumUtil.numToFmt(cm.comPrice,"###,###.##","")%></td>
</tr>
<tr height="23">
	<td class="bk1_1" align=right>Rate(%)</td>
	<td class="bk2_1">&nbsp;
		<%=NumUtil.numToFmt(cm.rate,"###,###.##","")%> %</td>
	<td class="bk1_1" align=right>Invoice Date</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.dateMode(cm.invoDate, "yyyyMMdd", "yy, MM, dd", "")%></td>
</tr>
<tr height="23">
	<td class="bk1_1" align=right>수금일</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=KUtil.dateMode(cm.payDate, "yyyyMMdd", "yy, MM, dd", "")%></td>
</tr>
<tr height="23">
	<td class="bk1_1" align=right>파일첨부</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=FileCtl.fileViewLink(cm.afile,"",cm.seq,"commission",",",1)%></td>
</tr>
<tr height="23">
	<td class="bk1_1" align=center colspan=4>MEMO</td>
</tr>
<tr height=50>
	<td class="bk2_1" style="padding: 3 3 3 5" colspan=4 valign=top><%=KUtil.nchk(cm.memo)%></td>
</tr>
<tr height="23">
	<td class="bk1_1" align=center colspan=4>관련 Project 및 PO 정보</td>
</tr>
<tr height="23">
	<td colspan=4>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr align=center>
			<td width="15%" class="menu1">제조사</td>
			<td width="10%" class="menu1">PO</td>
			<td width="75%" class="menu1">Project</td>
		</tr>
		</table></td>
</tr>
<tr height="23">
	<td align=center colspan=4>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" id="id_inserttb01">
	<%	for( int i=0 ; i<vecCml.size() ; i++ ){		
		Commission_link cml = (Commission_link)vecCml.get(i);	
		String cls = i%2==0?"menu2_1":"menu2";				%>
		<tr align=center>
			<td width="15%" class="<%=cls%>"><%=KUtil.nchk(cml.client_name,"&nbsp;")%></td>
			<td width="10%" class="<%=cls%>"><%=KUtil.nchk(cml.pono,"&nbsp;")%></td>
			<td width="75%" class="<%=cls%>"><%=KUtil.nchk(cml.project_name,"&nbsp;")%></td>
		</tr>
	<%	}//for	%>
		</table></td>
</tr>
<tr align=center height=30>
	<td class="bmenu" colspan=4>
		<input type="button" value="수정" onclick="goModify()" class="inputbox2">
		<input type="button" value="삭제" onclick="goDelete()" class="inputbox2">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</table>


<iframe name="id_dbc01" id="id_dbc01" width="0" height="0"></iframe>

</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
resize(726, 470);
</SCRIPT>


<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
