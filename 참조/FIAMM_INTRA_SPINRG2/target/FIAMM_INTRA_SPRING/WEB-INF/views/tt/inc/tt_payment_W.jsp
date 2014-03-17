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
	TtDAO ttDAO = new TtDAO(db);
	int seq_tt	= KUtil.nchkToInt(request.getParameter("seq_tt"));
	Tt tt = ttDAO.selectOne(seq_tt);
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function chkForm(){
	var frm = document.topFrm;
	if( !dateCheck(frm.pDate,"결제일") ) return;
	else if( Number(filterNum(frm.price.value)) < 1 ){
		alert("금액을 입력하여 주십시요");
		return;
	}
	frm.action = "tt_payment_DBW.jsp";
	frm.submit();
}
</SCRIPT>
</HEAD>

<BODY onload="topFrm.pDate.focus();">

<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" id="id_tb01">
<form name="topFrm" method="post">
<input type="hidden" name="seq_tt" value="<%=seq_tt%>">
<tr height=27>
	<td class="ti1" colspan=2>&nbsp;▶ TT 결제 정보 입력</td>

</tr>
<tr height=22>
	<td width="100" class="bk1_1" align=right>결제일&nbsp;</td>
	<td width="200" class="bk2_1">
		<input type="text" name="pDate" value="" maxlength="8" size="8" class="inputbox1"></td>
</tr>
<tr height=22>
	<td width="100" class="bk1_1" align=right>금액&nbsp;</td>
	<td width="200" class="bk2_1">
		<input type="text" name="price" value="<%=NumUtil.numToFmt(tt.price-tt.p_price,"###,###.##","0")%>" maxlength="20" size="15" onblur="intToCom(this);" class="inputbox1"></td>
</tr> 
<tr height=22>
	<td colspan=2 align=center>내용</td>
</tr>
<tr>
	<td colspan=2 align=center><textarea name="memo" style="width:100%;height:100%;border:1 solid #C0C0C0"></textarea></td>
</tr>
<tr height=25 align=center>
	<td class="bmenu"  colspan=2>
		<input type="button" value="입력" class="inputbox2" onclick="chkForm()">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>

</tr>
</form>
</table>


</table>
</BODY>
</HTML>

<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>
<div id=box style="position:absolute;background-color: #D9EBCD;width:120;height:25;display:none"></div>


<SCRIPT LANGUAGE="JavaScript">
resize(250,250);
id_tb01.style.width=document.body.clientWidth;
</SCRIPT>


<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>