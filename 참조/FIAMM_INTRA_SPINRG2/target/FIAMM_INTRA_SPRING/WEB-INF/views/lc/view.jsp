<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="lctt"/>
	<jsp:param name="col" value="V"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	
	int seq		= KUtil.nchkToInt(request.getParameter("seq"));
	int reload	= KUtil.nchkToInt(request.getParameter("reload"));
	
	
	LcDAO lDAO			= new LcDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	PoDAO poDAO			= new PoDAO(db);
	ClientDAO	cDAO	= new ClientDAO(db);
	BankDAO	bDAO		= new BankDAO(db);

	
	
	Lc lc		= lDAO.selectOne(seq);
	Po po		= poDAO.selectOne(lc.seq_po);
	Client cl	= cDAO.selectOne(po.seq_client);
	
	Vector vecBank  = bDAO.getList();
	Vector vecPrice = pkDAO.getList();

	double lcPrice = lc.seq > 0 ? lc.lcPrice : 0 ;
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/dateAdd.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function delLc(){
	if( confirm("삭제하시겠습니까?") ){
		document.frames['fm_lc0'].location = "DBD.jsp?seq=<%=lc.seq%>";
	}
}

function modLc(){
	var frm = document.topFrm;
	frm.action = "mod.jsp";
	frm.submit();
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="noscroll">
<form name="topFrm" method="post">
<input type="hidden" name="seq_po" value="<%=po.seq%>">
<input type="hidden" name="seq_pil" value="<%=lc.seq_passItemLnk%>">
<input type="hidden" name="seq" value="<%=lc.seq%>">
<input type="hidden" name="reload" value="<%=reload%>">


<table cellpadding="0" cellspacing="0" border="0" width="600">
<tr height=27>
	<td class="ti1">&nbsp;▶ LC 정보</td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="600">
<tr height=22>
	<td width="100" class="bk1_1" align=right>P/O No:</td>
	<td width="200" class="bk2_1">&nbsp;
		<%=poDAO.getPoNo(po)%></td>
	<td width="100" class="bk1_1" align=right>거래처:</td>
	<td width="200" class="bk2_1">&nbsp;
		<%=KUtil.nchk(cl.bizName)%></td>
</tr> 


<tr>
	<td class="bk1_1" align=right>은행명:</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.nchk(lc.bankName)%> (<%=KUtil.nchk(lc.bankCode)%>)</td>
	<td class="bk1_1" align=right>L/C No:</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.nchk(lc.lcNum)%></td>
</tr>
<tr valign=top>
	<td class="bk1_1" align=right bgcolor="#f7f7f7">금액:</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.nchk(lc.lcPriceKinds)%> <%=NumUtil.numToFmt(lcPrice,"###,###.##","0")%></td>
	
	
	<td class="bk1_1" align=right bgcolor="#f7f7f7">수입보증금:</td>
	<td class="bk2_1">&nbsp;
		<%=lc.guarPriceKinds%> <%=NumUtil.numToFmt(lc.guarPrice,"###,###.##","0")%></td>	
</tr>
<tr>
	<td class="bk1_1" align=right>개설일:</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.dateMode(lc.lcOpenDate,"yyyyMMdd","yyyy, MM, dd","")%></td>
	<td class="bk1_1" align=right>BL 인수일:</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.dateMode(lc.blRecDate,"yyyyMMdd","yyyy, MM, dd","")%></td>
</tr>
<tr>
	<td class="bk1_1" align=right>BL 만기일:</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.dateMode(lc.lcLimitDate,"yyyyMMdd","yyyy, MM, dd","")%></td>
	<td class="bk1_1" align=right>결제일:</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.dateMode(lc.lcPayDate,"yyyyMMdd","yyyy, MM, dd","")%></td>
</tr>
<tr>
	<td class="bk1_1" align=right>상환환율:</td>
	<td class="bk2_1">&nbsp;
		<%=NumUtil.numToFmt(lc.rate,"###,###.##","0")%></td>
	<td class="bk1_1" align=right>원화결제금액:</td>
	<td class="bk2_1">&nbsp;
		<%=NumUtil.numToFmt(lc.rPrice,"###,###.##","0")%></td>
</tr>
</tr>
	<td class="bk1_1" align=right>추가정보:</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=KUtil.nchk(lc.atsight)%></td>
</tr>
<tr align=center>
	<td colspan=4 class="bk1_1">MEMO</td>
</tr>

<tr height="90" valign=top>
	<td colspan=4 style="padding:5 5 5 5">
		<div style="width:100%;height:90;overflow-x:hidden;overflow-y:auto;"><%=KUtil.nchk(lc.memo,"&nbsp;")%></td>
</tr>


<tr height=30 align=center>
	<td colspan=4 class="bmenu">
		<input type="button" value="수정" class="inputbox2" onclick="modLc()">
		<input type="button" value="삭제" class="inputbox2" onclick="delLc()">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</table>
</form>
</table>
</BODY>
</HTML>




<SCRIPT LANGUAGE="JavaScript">
resize(610,360);
</SCRIPT>
<!-- 달력 -->



<iframe name="fm_lc0" id="fm_lc0" width=0 height=0></iframe>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>