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
	
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));
	int seq_pil= KUtil.nchkToInt(request.getParameter("seq_pil"));
	int reload = KUtil.nchkToInt(request.getParameter("reload"));
	
	
	LcDAO lDAO			= new LcDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	PoDAO poDAO			= new PoDAO(db);
	ClientDAO	cDAO	= new ClientDAO(db);
	BankDAO	bDAO		= new BankDAO(db);

	
	
	Po po		= poDAO.selectOne(seq_po);
	Client cl	= cDAO.selectOne(po.seq_client);
	Vector vecBank  = bDAO.getList();
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
	frm.target = "fm_lc0";
	frm.action = "DBW.jsp";
	if( !validate(frm) ) return;
	frm.submit();
}
function validate(frm){
	if( !nchk(frm.bankName,"은행명") ) return false;
	else if( !nchk(frm.bankCode,"은행코드") ) return false;
	else if( !nchk(frm.lcNum,"LC No") ) return false;
	else if( !comNum(frm.lcPrice,"LC 금액") ) return false;
	else if( !dateCheck(frm.lcOpenDate,"LC 오픈일") )return false;
	//else if( !comNum(frm.guarPrice,"수입 보증금") ) return false;
	
	if( frm._lcPriceKinds.value==0 ){
		if( !nchk(frm.lcPriceKinds,"통화 종류") ) return false;
	}
	if( frm._guarPriceKinds.value==0 ){
		if( !nchk(frm.guarPriceKinds,"통화 종류") ) return false;
	}
	return true;
}
function comma(){
	var frm = document.topFrm;
	intToCom(frm.lcPrice);
	intToCom(frm.guarPrice);
}
function viewBank(pge){
	var lt = (screen.availWidth-220)/2;
	var tp = (screen.availHeight-400)/2;
	var pop = window.open("/main/bank/list.jsp?pge="+pge,"mngbank","width=220,height=400,scrollbars=1,left="+lt+",top="+tp);
	pop.focus();
}
function rateBlur(){
	var frm = document.topFrm;
	frm.rPrice.value = Number( filterNum(frm.rate.value) ) * Number( filterNum(frm.lcPrice.value) );
	commaFlag();
}
function commaFlag(){
	if( !keyCheck() ) return;
	var frm = document.topFrm;
	intToCom(frm.lcPrice);
	intToCom(frm.guarPrice);
	intToCom(frm.rate);
	intToCom(frm.rPrice);
}
function changeLcPriceKinds(obj){
	var frm = document.topFrm;
	if( obj.value=='0' ){
		frm.lcPriceKinds.value = "";
		id_k1.style.display = "block";
		frm.lcPriceKinds.focus();
	}else{
		frm.lcPriceKinds.value = obj.value;
		id_k1.style.display = "none";
	}
}
function changeGuarPriceKinds(obj){
	var frm = document.topFrm;
	if( obj.value=='0' ){
		frm.guarPriceKinds.value = "";
		id_k2.style.display = "block";
		frm.guarPriceKinds.focus();
	}else{
		frm.guarPriceKinds.value = obj.value;
		id_k2.style.display = "none";
	}
}
function DateAdd90(){
	var frm = document.topFrm;
	var val = calcDay( frm.blRecDate.value, 90);
	if( val != null && val != '' ){
		frm.lcLimitDate.value = val;
	}
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="noscroll">
<form name="topFrm" method="post" onsubmit="return false;">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<input type="hidden" name="seq_pil" value="<%=seq_pil%>">
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
		<input type="text" name="bankName" value="" size="10" readonly class="inputbox1">
		<input type="hidden" name="bankCode" value="" size="10" readonly class="inputbox1">
		<input type="button" value="선택" class="inputbox2" onclick="viewBank('1')"></td>
	<td class="bk1_1" align=right>L/C No:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcNum" value="" maxlength="200" style="width:90%" class="inputbox1"></td>
</tr>
<tr valign=top>
	<td class="bk1_1" align=right bgcolor="#f7f7f7">금액:</td>
	<td class="bk2_1">&nbsp;
		<select name="_lcPriceKinds" class="selbox1" onchange="changeLcPriceKinds(this)">
		<%	for( int i=0 ; i<vecPrice.size() ; i++ ){
				String kinds = (String)vecPrice.get(i);		%>
			<option value="<%=kinds%>"><%=kinds%></option>
		<%	}//for	%>
			<option value="0">입력</option>
		</select>
		<INPUT TYPE="text" NAME="lcPrice" maxlength=20 size=20 class="inputbox1" onkeyup="commaFlag()" value="">
		
		<div id="id_k1" style="display:none">&nbsp;
			화폐단위:
			<input type="text" name="lcPriceKinds" value="\" class="inputbox1" maxlength="30" size="10"></div></td>
	
	
	<td class="bk1_1" align=right bgcolor="#f7f7f7">수입보증금:</td>
	<td class="bk2_1">&nbsp;
		<select name="_guarPriceKinds" class="selbox1" onchange="changeGuarPriceKinds(this)">
		<%	for( int i=0 ; i<vecPrice.size() ; i++ ){
				String kinds = (String)vecPrice.get(i);		%>
			<option value="<%=kinds%>"><%=kinds%></option>
		<%	}//for	%>
			<option value="0">입력</option>
		</select>
		<INPUT TYPE="text" NAME="guarPrice" maxlength=20 size=20 class="inputbox" onkeyup="commaFlag()" value="">
		<div id="id_k2" style="display:none">&nbsp;
			화폐단위:<input type="text" name="guarPriceKinds" value="\" class="inputbox1" maxlength="30" size="10"></div></td>	
</tr>
<tr>
	<td class="bk1_1" align=right>개설일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcOpenDate" maxlength=8 size=8 class="inputbox1" value=""></td>
	<td class="bk1_1" align=right>BL 인수일</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="blRecDate" maxlength=8 size=8 class="inputbox" value="" onBlur="DateAdd90()"></td>
</tr>
<tr>
	<td class="bk1_1" align=right>BL 만기일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcLimitDate" maxlength=8 size=8 class="inputbox" value=""></td>
	<td class="bk1_1" align=right>결제일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcPayDate" maxlength=8 size=8 class="inputbox" value=""></td>
</tr>
<tr>
	<td class="bk1_1" align=right>상환 환율:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="rate" maxlength=20 size=15 class="inputbox" value="" onblur="rateBlur()"></td>
	<td class="bk1_1" align=right>원화결제금액:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="rPrice" maxlength=20 size=15 class="inputbox" value="" onblur="commaFlag()"></td>
</tr>
<tr>
	<td class="bk1_1" align=right>추가정보:</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<select name="atsight" class="selbox">
			<option value="">▒▒추가정보▒▒</option>
			<option value="ATSIGHT">ATSIGHT</option>
			<option value="USANCE">USANCE</option>
		</select></td>
</tr>
<tr>
	<td colspan=4>
		<textarea name="memo" style="width:100%;height:80"></textarea></td>
</tr>


<tr height=30 align=center valign=top>
	<td colspan=4 class="bmenu">
		<input type="button" value="입력" class="inputbox2" onclick="chkForm()">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</table>
</form>
</table>
</BODY>
</HTML>




<SCRIPT LANGUAGE="JavaScript">
editor_generate("memo");
resize(610,360);
</SCRIPT>
<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>
<div id=box style="position:absolute;background-color: #D9EBCD;width:120;height:25;display:none"></div>



<iframe name="fm_lc0" id="fm_lc0" width=0 height=0></iframe>



<%	if( po.seq > 0 ){	%>
<table cellpadding="0" cellspacing="0" border="0" width="0" height="0" style="display:none">
<form name='dataform'>
<textarea name="lcPriceKinds" style="display:none"><%=KUtil.nchk(po.priceKinds)%></textarea>
<textarea name="lcPrice" style="display:none"><%=po.poTotPrice>0?po.poTotPrice+"":""%></textarea>
</form>
</table>
<SCRIPT LANGUAGE="JavaScript">
var ofrm = document.topFrm;
var frm = document.dataform;
var flg = 0;
for( var i=0 ; i<ofrm._lcPriceKinds.length ; i++ ){
	if( ofrm._lcPriceKinds.options[i].value==frm.lcPriceKinds.value ){
		ofrm._lcPriceKinds.options[i].selected = true;
		flg = 1;
	}
}
if( flg == 0 ){
	for( var i=0 ; i<ofrm._lcPriceKinds.length ; i++ ){
		if( ofrm._lcPriceKinds.value=='0' ){
			ofrm._lcPriceKinds.options[i].selected = true;
		}
	}
	changeLcPriceKinds(ofrm._lcPriceKinds);
}
ofrm.lcPriceKinds.value = frm.lcPriceKinds.value;
ofrm.lcPrice.value = frm.lcPrice.value;
commaFlag();
</SCRIPT>	
<%	}//if


}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>