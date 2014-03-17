<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="lctt"/>
	<jsp:param name="col" value="M"/>
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
	
	
	Tt tt = ttDAO.selectOne(seq);
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
function chkForm(){
	var frm = document.topFrm;
	frm.target = "fm_tt0";
	frm.action = "DBM.jsp";
	if( !validate(frm) ) return;
	frm.submit();
}
function validate(frm){
	if( !nchk(frm.invoNum,"Invoice No") ) return false;
	else if( !dateCheck(frm.invoDate,"Invoice Date") ) return false;
	else if( !dateCheck(frm.limitDate,"TT 만기일") ) return false;
	if( frm._priceKinds.value==0 ){
		if( !nchk(frm.priceKinds,"통화종류") ) return false;
	}
	return true;
}
function rateBlur(){
	var frm = document.topFrm;
	frm.rPrice.value = Number( filterNum(frm.rate.value) ) * Number( filterNum(frm.price.value) );
	commaFlag();
}
function commaFlag(){
	if( !keyCheck() ) return;
	var frm = document.topFrm;
	intToCom(frm.price);
	intToCom(frm.rate);
	intToCom(frm.rPrice);
}
function viewBank(pge){
	var lt = (screen.availWidth-220)/2;
	var tp = (screen.availHeight-400)/2;
	var pop = window.open("/main/bank/list.jsp?pge="+pge,"mngbank","width=220,height=400,scrollbars=1,left="+lt+",top="+tp);
	pop.focus();
}
function changePriceKinds(){
	var frm = document.topFrm;
	var obj = frm._priceKinds;
	if( obj.value=='0' ){
		frm.priceKinds.value = "";
		id_k1.style.display = "block";
		frm.priceKinds.focus();
	}else{
		frm.priceKinds.value = obj.value;
		id_k1.style.display = "none";
	}
}
function delTT(){
	var frm = document.topFrm;
	if( confirm("삭제하시겠습니까?") ){
		frm.target = "fm_tt0";
		frm.action = "DBD.jsp";
		frm.submit();
	}
}
function DateAdd(){
	var addDate = 30;
	var frm = document.topFrm;
	var bname = document.getElementById("id_bizName").innerHTML.toUpperCase();
	if( bname.indexOf("FIAMM") > -1 )
		addDate = 75;
	else if( bname.indexOf("GUTOR") > -1 )
		addDate = 30;
	else if( bname.indexOf("ALCAD") > -1 )
		addDate = 90;
	else
		return;

	var val = calcDay( frm.invoDate.value, addDate);
	if( val != null && val != '' ){
		frm.limitDate.value = val;
	}
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="noscroll">
<form name="topFrm" method="post" onsubmit="return false;">
<input type="hidden" name="seq" value="<%=tt.seq%>">
<input type="hidden" name="seq_po" value="<%=po.seq%>">
<input type="hidden" name="reload" value="<%=reload%>">


<table cellpadding="0" cellspacing="0" border="0" width="600">
<tr height=27>
	<td class="ti1">&nbsp;▶ TT 정보 입력</td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="600">
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
		<INPUT TYPE="text" NAME="invoNum" maxlength=200 style="width:90%" class="inputbox1" value="<%=tt.invoNum%>"></td>
	<td class="bk1_1" align=right>Invoice Date:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="invoDate" maxlength=8 size=8 class="inputbox1" value="<%=tt.invoDate%>" onblur="DateAdd()"></td>
</tr>
<tr valign=top>
	<td class="bk1_1" align=right bgcolor="#f7f7f7">금액:</td>
	<td class="bk2_1">&nbsp;
		<select name="_priceKinds" class="selbox1" onchange="changePriceKinds()">
		<%	boolean flag = false;
			for( int i=0 ; i<vecPrice.size() ; i++ ){
				String kinds = (String)vecPrice.get(i);		
				if( kinds.equals(tt.priceKinds) ) flag = true;	%>
			<option value="<%=kinds%>" <%=kinds.equals(tt.priceKinds)?"selected":""%>><%=kinds%></option>
		<%	}//for	%>
			<option value="0" <%=!flag?"selected":""%>>입력</option>
		</select>
		<INPUT TYPE="text" NAME="price" maxlength=20 size=20 class="inputbox1" onkeyup="commaFlag()" value="<%=NumUtil.numToFmt(tt.price,"###,###.##","0")%>">
		
		<div id="id_k1" style="display:<%=!flag?"block":"none"%>">&nbsp;
			화폐단위: <input type="text" name="priceKinds" value="<%=KUtil.nchk(tt.priceKinds)%>" class="inputbox1" maxlength="30" size="10"></div></td>
	
	
	<td class="bk1_1" align=right bgcolor="#f7f7f7">TT 만기일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="limitDate" maxlength=8 size=8 class="inputbox1" value="<%=tt.limitDate>0?tt.limitDate+"":""%>"></td>
</tr>
<tr>
	<td class="bk1_1" align=right>결제일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="payDate" maxlength=8 size=8 class="inputbox" value="<%=tt.payDate>0?tt.payDate+"":""%>"></td>
	<td class="bk1_1" align=right>은행명:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="bankName" maxlength=50 size=8 class="inputbox" value="<%=KUtil.nchk(tt.bankName)%>">
		<input type="hidden" name="bankCode" value="">
		<input type="button" value="선택" class="inputbox2" onclick="viewBank('2')"></td>
	
</tr>
<tr>
	<td class="bk1_1" align=right>상환 환율:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="rate" maxlength=20 size=15 class="inputbox" value="<%=NumUtil.numToFmt(tt.rate,"###,###.##","0")%>" onblur="rateBlur()"></td>
	<td class="bk1_1" align=right>원화결제금액:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="rPrice" maxlength=20 size=15 class="inputbox" value="<%=NumUtil.numToFmt(tt.rPrice,"###,###.##","0")%>" onblur="commaFlag()"></td>
</tr>
<tr>
	<td colspan=4>
		<textarea name="memo" style="width:100%;height:80"><%=KUtil.nchk(tt.memo)%></textarea></td>
</tr>


<tr height=40 align=center valign=top>
	<td colspan=4 class="bmenu">
		<input type="button" value="수정" class="inputbox2" onclick="chkForm()">
		<input type="button" value="삭제" class="inputbox2" onclick="delTT()">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</table>
</form>
</table>
</BODY>
</HTML>




<SCRIPT LANGUAGE="JavaScript">
editor_generate("memo");
</SCRIPT>
<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>
<div id=box style="position:absolute;background-color: #D9EBCD;width:120;height:25;display:none"></div>



<iframe name="fm_tt0" id="fm_tt0" width=0 height=0></iframe>

<SCRIPT LANGUAGE="JavaScript">
resize(600,310);
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>