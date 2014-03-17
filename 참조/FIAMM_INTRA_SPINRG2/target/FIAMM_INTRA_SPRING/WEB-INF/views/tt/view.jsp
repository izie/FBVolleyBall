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
	
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	PoDAO poDAO			= new PoDAO(db);
	ClientDAO	cDAO	= new ClientDAO(db);
	BankDAO	bDAO		= new BankDAO(db);
	TtDAO	ttDAO		= new TtDAO(db);
	//TT_paymentDAO tpDAO = new TT_paymentDAO(db);
	
	Tt tt		= ttDAO.selectOne(seq);
	Po po		= poDAO.selectOne(tt.seq_po);
	Client cl	= cDAO.selectOne(po.seq_client);
	Vector vecPrice = pkDAO.getList();
	
	
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
function delTT(){
	var frm = document.topFrm;
	if( confirm("삭제하시겠습니까?") ){
		frm.target = "fm_tt0";
		frm.action = "DBD.jsp";
		frm.submit();
	}
}
function modTT(){
	var frm = document.topFrm;
	frm.target = "_self";
	frm.action = "mod.jsp";
	frm.submit();
}
function addPayment(){
	var pop = window.open("./inc/tt_payment_W.jsp?seq_tt=<%=tt.seq%>","tt_payment_W_","scrollbars=0,resizabled=0");
	pop.focus();
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="noscroll">



<table cellpadding="0" cellspacing="1" border="0" width="850" height="100%">
<tr valign=top>
	<!-- left -->
	<td width="600" style="border-right:1 solid #C0C0C0">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<form name="topFrm" method="post">
		<input type="hidden" name="seq" value="<%=tt.seq%>">
		<input type="hidden" name="seq_po" value="<%=po.seq%>">
		<input type="hidden" name="reload" value="<%=reload%>">
		<tr>
			<td valign=top>
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr height=30>
					<td class="ti1" colspan=4>&nbsp;▶ TT 정보 입력</td>
				</tr>

				<tr height=22>
					<td width="100" class="bk1_1" align=right>P/O No:</td>
					<td width="200" class="bk2_1">&nbsp;
						<%=poDAO.getPoNo(po)%></td>
					<td width="100" class="bk1_1" align=right>거래처:</td>
					<td width="200" class="bk2_1">
						<div id="id_bizName">&nbsp;
							<%=KUtil.nchk(cl.bizName)%></div></td>
				</tr> 


				<tr>
					<td class="bk1_1" align=right>Invoice No:</td>
					<td class="bk2_1">&nbsp;
						<%=tt.invoNum%></td>
					<td class="bk1_1" align=right>Invoice Date:</td>
					<td class="bk2_1">&nbsp;
						<%=KUtil.dateMode(tt.invoDate,"yyyyMMdd","yyyy, MM, dd","")%></td>
				</tr>
				<tr valign=top>
					<td class="bk1_1" align=right bgcolor="#f7f7f7">금액:</td>
					<td class="bk2_1">&nbsp;
						<%=KUtil.nchk(tt.priceKinds)%> <%=NumUtil.numToFmt(tt.price,"###,###.##","0")%></td>
					
					
					<td class="bk1_1" align=right bgcolor="#f7f7f7">TT 만기일:</td>
					<td class="bk2_1">&nbsp;
						<%=KUtil.dateMode(tt.limitDate,"yyyyMMdd","yyyy, MM, dd","")%></td>
				</tr>
				<tr>
					<td class="bk1_1" align=right>결제일:</td>
					<td class="bk2_1">&nbsp;
						<%=KUtil.dateMode(tt.payDate,"yyyyMMdd","yyyy, MM, dd","")%></td>
					<td class="bk1_1" align=right>은행명:</td>
					<td class="bk2_1">&nbsp;
						<%=KUtil.nchk(tt.bankName)%></td>
					
				</tr>
				<tr>
					<td class="bk1_1" align=right>상환환율:</td>
					<td class="bk2_1">&nbsp;
						<%=NumUtil.numToFmt(tt.rate,"###,###.##","0")%></td>
					<td class="bk1_1" align=right>원화결제금액:</td>
					<td class="bk2_1">&nbsp;
						<%=NumUtil.numToFmt(tt.rPrice,"###,###.##","0")%></td>
				</tr>
				<tr align=center>
					<td class="bk1_1" colspan=4>MEMO</td>
				</tr>
				<tr height="90">
					<td colspan=4 style="padding:5 5 5 5">
						<div style="width:100%;height:90;overflow-x:hidden;overflow-y:auto;"><%=KUtil.nchk(tt.memo,"&nbsp;")%></div></td>
				</tr>
				</table></td>
		</tr>
		<tr height="30" align=center>
			<td class="bmenu">
				<input type="button" value="수정" class="inputbox2" onclick="modTT()">
				<input type="button" value="삭제" class="inputbox2" onclick="delTT()">
				<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
		</tr>
		</form>
		</table></td>
	
	<!-- right -->
	<td width="250">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr height=30>
			<td class="ti1">&nbsp;▶ 결제 정보</td>
		</tr>
		<tr valign=top>
			<td><jsp:include page="/main/tt/inc/inc_payment_list.jsp" flush="true">
					<jsp:param name="seq_tt" value="<%=tt.seq%>"/>
				</jsp:include></td>
		</tr>
		<tr height="30" align=center>
			<td class="bmenu">
				<input type="button" value="결제정보추가" class="inputbox2" onclick="addPayment()"></td>
		</tr>
		</table></td>
</tr>
</table>

</BODY>
</HTML>

<iframe name="fm_tt0" id="fm_tt0" width=0 height=0></iframe>

<SCRIPT LANGUAGE="JavaScript">
resize(850,310);
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>