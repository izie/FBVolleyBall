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
function chkForm(){
	var frm = document.topFrm;
	frm.target = "fm_lc0";
	frm.action = "DBM.jsp";
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
function delLc(){
	if( confirm("삭제하시겠습니까?") ){
		document.frames['fm_lc0'].location = "DBD.jsp?seq=<%=lc.seq%>";
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
		<input type="text" name="bankName" value="<%=KUtil.nchk(lc.bankName)%>" size="10" readonly class="inputbox1">
		<input type="text" name="bankCode" value="<%=KUtil.nchk(lc.bankCode)%>" size="10" readonly class="inputbox1">
		<input type="button" value="선택" class="inputbox2" onclick="viewBank('1')"></td>
	<td class="bk1_1" align=right>L/C No:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcNum" value="<%=KUtil.nchk(lc.lcNum)%>" maxlength="200" style="width:90%" class="inputbox1"></td>
</tr>
<tr valign=top>
	<td class="bk1_1" align=right bgcolor="#f7f7f7">금액:</td>
	<td class="bk2_1">&nbsp;
		<select name="_lcPriceKinds" class="selbox1" onchange="changeLcPriceKinds(this)">
		<%	String lcPriceKinds = "";
			boolean flag = false;
			for( int i=0 ; i<vecPrice.size() ; i++ ){
				String kinds = (String)vecPrice.get(i);		
				String sel = "";
				if( lc.seq > 0 &&  KUtil.nchk(lc.lcPriceKinds).equals(kinds) ){
					flag = true; sel = "selected";
				}else if( lc.seq < 1 && kinds.equals(po.priceKinds) ){
					flag = true; sel = "selected";
				}				%>
			<option value="<%=kinds%>" <%=sel%>><%=kinds%></option>
		<%	}//for	%>
			<option value="0" <%=!flag ? "selected" : ""%>>입력</option>
		</select>
		<INPUT TYPE="text" NAME="lcPrice" maxlength=20 size=20 class="inputbox1" onkeyup="commaFlag()" value="<%=NumUtil.numToFmt(lcPrice,"###,###.##","0")%>">
		
		<div id="id_k1" style="display:<%=!flag ? "block":"none"%>">&nbsp;
			화폐단위:
			<input type="text" name="lcPriceKinds" value="<%=lc.seq>0 && !flag?KUtil.nchk(lc.lcPriceKinds):po.priceKinds%>" class="inputbox1" maxlength="30" size="10"></div></td>
	
	
	<td class="bk1_1" align=right bgcolor="#f7f7f7">수입보증금:</td>
	<td class="bk2_1">&nbsp;
		<select name="_guarPriceKinds" class="selbox1" onchange="changeGuarPriceKinds(this)">
		<%	boolean flag1 = false;
			for( int i=0 ; i<vecPrice.size() ; i++ ){
				String kinds = (String)vecPrice.get(i);	
				String sel = "";
				if( lc.seq > 0 && KUtil.nchk(lc.guarPriceKinds).equals(kinds) ){
					flag1 = true; sel = "selected";
				}		
		%>
			<option value="<%=kinds%>" <%=sel%>><%=kinds%></option>
		<%	}//for	%>
			<option value="0" <%=lc.seq>0 && !flag1?"selected":""%>>입력</option>
		</select>
		<INPUT TYPE="text" NAME="guarPrice" maxlength=20 size=20 class="inputbox" onkeyup="commaFlag()" value="<%=NumUtil.numToFmt(lc.guarPrice,"###,###.##","0")%>">
		<div id="id_k2" style="display:<%=lc.seq>0 && !flag1?"block":"none"%>">&nbsp;
			화폐단위:<input type="text" name="guarPriceKinds" value="<%=lc.seq>0 && !flag1?KUtil.nchk(lc.guarPriceKinds):"\\"%>" class="inputbox1" maxlength="30" size="10"></div></td>	
</tr>
<tr>
	<td class="bk1_1" align=right>개설일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcOpenDate" maxlength=8 size=8 class="inputbox1" value="<%=lc.lcOpenDate>0 ? lc.lcOpenDate+"" : ""%>"></td>
	<td class="bk1_1" align=right>BL 인수일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="blRecDate" maxlength=8 size=8 class="inputbox" value="<%=lc.blRecDate>0 ? lc.blRecDate+"" : ""%>" onBlur="DateAdd90()"></td>
</tr>
<tr>
	<td class="bk1_1" align=right>BL 만기일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcLimitDate" maxlength=8 size=8 class="inputbox" value="<%=lc.lcLimitDate>0 ? lc.lcLimitDate+"" : ""%>"></td>
	<td class="bk1_1" align=right>결제일:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="lcPayDate" maxlength=8 size=8 class="inputbox" value="<%=lc.lcPayDate>0 ? lc.lcPayDate+"" : ""%>"></td>
</tr>
<tr>
	<td class="bk1_1" align=right>상환 환율:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="rate" maxlength=20 size=15 class="inputbox" value="<%=NumUtil.numToFmt(lc.rate,"###,###.##","0")%>" onblur="rateBlur()"></td>
	<td class="bk1_1" align=right>원화결제금액:</td>
	<td class="bk2_1">&nbsp;
		<INPUT TYPE="text" NAME="rPrice" maxlength=20 size=15 class="inputbox" value="<%=NumUtil.numToFmt(lc.rPrice,"###,###.##","0")%>" onblur="commaFlag()"></td>
</tr>
</tr>
	<td class="bk1_1" align=right>추가정보:</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<select name="atsight" class="selbox">
			<option value="">▒▒추가정보▒▒</option>
			<option value="ATSIGHT" <%=KUtil.nchk(lc.atsight).equals("ATSIGHT")?"selected":""%>>ATSIGHT</option>
			<option value="USANCE" <%=KUtil.nchk(lc.atsight).equals("USANCE")?"selected":""%>>USANCE</option>
		</select></td>
</tr>
<tr>
	<td colspan=4>
		<textarea name="memo" style="width:100%;height:80"><%=KUtil.nchk(lc.memo)%></textarea></td>
</tr>


<tr height=30 align=center>
	<td colspan=4 class="bmenu">
		<input type="button" value="<%=lc.seq > 0?"수정":"입력"%>" class="inputbox2" onclick="chkForm()">
	<%	if( lc.seq > 0 ){	%>
		<input type="button" value="삭제" class="inputbox2" onclick="delLc()">
	<%	}%>
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</table>
<%=lc.blRecDate%>
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
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>