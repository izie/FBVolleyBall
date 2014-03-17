<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_project = KUtil.nchkToInt(request.getParameter("seq_project"));
	
	
	ContractDAO cDAO = new ContractDAO(db);
	EstimateDAO emDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	EstItemOutDAO eoDAO = new EstItemOutDAO(db);



	int seq_estimate = 0;
	int deliDate = 0;
	Vector vecContract = cDAO.getListInProject(seq_project);
	if( vecContract.size() > 0 ){
		Contract ct = (Contract)vecContract.get(0);
		seq_estimate = ct.seq_estimate;
		deliDate = ct.deliDate;
	}else{
		Vector vecEstimate = emDAO.getListProj(0,1,"","",seq_project);
		if( vecEstimate.size() > 0 ){
			Estimate ei = (Estimate)vecEstimate.get(0);
			seq_estimate = ei.seq;
		}
	}
	
	if( seq_estimate == 0 ){
		KUtil.scriptAlert(out,"�������� �������� �ʽ��ϴ�.");
		return;
	}

	Vector vecItem = eiDAO.getList(seq_estimate);
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/move.js"></SCRIPT>
<script language="javascript">
var sel_stat = "";
function sel_item( item_num,seq_estimate ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	opWin( seq_estimate );
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function inDeli(i){
	var frm = document.outform;
	if( Number(eval("document.listform.ableCnt"+i).value) < 1 ){
		alert("���� ������ �����ϴ�.");
		return;
	}
	frm.reset();
	frm.seq_estItem.value	= eval("document.listform.seq_estItem"+i).value;
	frm.cnt.value			= eval("document.listform.ableCnt"+i).value;
	frm.ablecnt.value		= eval("document.listform.ableCnt"+i).value;

	var obj = eval('div_add');    
	obj.style.pixelTop = event.clientY;
	obj.style.display='block';
	frm.realDeliDate.focus();
}
function modDeli( i, seq ){
	var frm = document.modform;
	frm.reset();
	document.frames['fme0'].location = "deli_input.jsp?seq="+seq;
	frm.ablecnt.value		= eval("document.listform.ableCnt"+i).value;
	var obj = eval('div_mod');    
	obj.style.pixelTop = event.clientY;
	obj.style.display='block';
	frm.realDeliDate.focus();
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="xnoscroll">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="listform" method="post">


<tr align=center>
	<td class="bk1_1">ǰ�� �� �԰�</td>
	<td width="80" class="bk1_1">����</td>
	<td width=1 bgcolor="#808080"></td>
	<td width="80" class="bk1_1">��ೳ����</td>
	<td width="80" class="bk1_1">������</td>
	<td width="80" class="bk1_1">��ġ��</td>
	<td width="180" class="bk1_1">��ġ���</td>
	<td width="80" class="bk1_1">����</td>
</tr>
<%	for( int i=0 ; i<vecItem.size() ; i++ ){	
		EstItem ei = (EstItem)vecItem.get(i);	
		Vector vecEstOut = eoDAO.getList(ei.seq);		%>
<tr align=center>
	<td class="bk2_1"><A HREF="javascript:" onclick="inDeli('<%=i%>');"><%=KUtil.nchk(ei.itemName)%> <%=KUtil.nchk(ei.itemDim)%></A></td>
	<td class="bk2_1"><%=KUtil.intToCom(ei.cnt)%></td>
	<td width=1 bgcolor="#808080"></td>
	<td class="bk2_1" colspan=5>
	<%	int outCnt = 0;
		for( int j=0 ; j<vecEstOut.size() ; j++ ){	
			EstItemOut eio = (EstItemOut)vecEstOut.get(j);	%>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" style="">
		<tr align=center style="cursor:hand" onclick="modDeli('<%=i%>','<%=eio.seq%>')">
			<td width="80" class="bk2_1"><%=KUtil.toTextMode(eio.deliDate)%></td>
			<td width="80" class="bk2_1"><%=KUtil.toDateViewMode(eio.realDeliDate)%></td>
			<td width="80" class="bk2_1"><%=KUtil.toDateViewMode(eio.setupDate)%></td>
			<td width="180" class="bk2_1"><%=KUtil.toTextMode(eio.place)%></td></td>
			<td width="80" class="bk2_1"><%=KUtil.intToCom(eio.cnt)%></td>
		</tr>
		</table>
	<%		outCnt += eio.cnt;
		}//for	%></td>
<input type="hidden" name="seq_estItem<%=i%>" value="<%=ei.seq%>">
<input type="hidden" name="ableCnt<%=i%>" value="<%=ei.cnt-outCnt%>">		
</tr>
<%	}//for	%>


</form>
</table>
</BODY>
</HTML>




<!------------------------- �߰��� ------------------------->
<SCRIPT LANGUAGE="JavaScript">
function chkeckDeliForm(){
	var frm = document.outform;
	if( nchk1(frm.deliDate) ){
		if( !dateCheck(frm.deliDate,"��ೳ����") ) return false;
	}
	if( nchk1(frm.realDeliDate) ){
		if( !dateCheck(frm.realDeliDate,"������") ) return false;
	}


	//if( !dateCheck(frm.setupDate,"��ġ��") ) return false;
	//else 
	if( !onlyNumber(frm.cnt,"����") ) return false;
	else if( Number(frm.cnt.value) > Number(frm.ablecnt.value)  ){
		alert("������ �ʰ� �Ǿ����ϴ�."); return false;
	}
	return true;
}
</SCRIPT>
<div style="width:530;" id="div_add" style="display:none;position:absolute;left:300" onClick="MM_dragLayer('div_add','',0,0,530,20,true,false,-1,-1,-1,-1,false,false,0,'',false,'')">
<table cellpadding="0" cellspacing="1" border="0" style="border:1 solid #993300" bgcolor="#F3E8FF">
<form name="outform" method="post" action="deli_DBW.jsp" onsubmit="return chkeckDeliForm();">
<input type="hidden" name="seq_project" value="<%=seq_project%>">
<input type="hidden" name="seq_estimate" value="<%=seq_estimate%>">
<input type="hidden" name="seq_estItem" value="">
<input type="hidden" name="ablecnt" value="">
<tr align=center>
	<td valign=top class="bk1_1">
		<A HREF="javascript:" onclick="show1('div_add','none')"><IMG SRC="/images/icon_del1.gif" BORDER="0" ALT="�ݱ�"></A></td>
	<td class="bk1_1">��ೳ����</td>
	<td class="bk1_1">������</td>
	<td class="bk1_1">��ġ��</td>
	<td class="bk1_1">��ġ���</td>
	<td class="bk1_1">����</td>
	<td class="bk1_1">&nbsp;</td>
</tr>
<tr>
	<td class="bk2_1" width="9" valign=top>&nbsp;</td>
	<td class="bk2_1" width="80">
		<input type="text" name="deliDate" value="<%=deliDate>0?deliDate+"":""%>" class="inputbox" style="width:100%"></td>
	<td class="bk2_1" width="80">
		<input type="text" name="realDeliDate" value="" class="inputbox" style="width:100%"></td>
	<td class="bk2_1" width="80">
		<input type="text" name="setupDate" value="" class="inputbox" style="width:100%"></td>
	<td class="bk2_1" width="180">
		<textarea style="width:100%;height:100%" name="place"></textarea></td>
	<td class="bk2_1" width="80">
		<input type="text" name="cnt" value="" class="inputbox1" style="width:100%"></td>
	<td class="bk2_1" width="30">
		<input type="submit" value="�Է�" class="inputbox2"></td>
</tr>
</form>
</table></div>




<!------------------------- ������ ------------------------->
<SCRIPT LANGUAGE="JavaScript">
function chkeckDeliFormMod(){
	var frm = document.modform;
	if( nchk1(frm.deliDate) ){
		if( !dateCheck(frm.deliDate,"��ೳ����") ) return false;
	}
	if( nchk1(frm.realDeliDate) ){
		if( !dateCheck(frm.realDeliDate,"������") ) return false;
	}


	if( !dateCheck(frm.setupDate,"��ġ��") ) return false;
	else if( !onlyNumber(frm.cnt,"����") ) return false;
	else if( Number(frm.cnt.value) > Number(frm._cnt.value)+Number(frm.ablecnt.value)   ){
		alert("������ �ʰ� �Ǿ����ϴ�."); return false;
	}
	frm.action = "deli_DBM.jsp";
	return true;
}
function deliDel(){
	var frm = document.modform;
	if( confirm("�����Ͻðڽ��ϱ�?") ){
		frm.action = "deli_DBD.jsp";
		frm.submit();
	}
}
</SCRIPT>
<div style="width:570;" id="div_mod" style="display:none;position:absolute;left:270" onClick="MM_dragLayer('div_mod','',0,0,570,20,true,false,-1,-1,-1,-1,false,false,0,'',false,'')">

<table cellpadding="0" cellspacing="1" border="0" style="border:1 solid #993300" bgcolor="#F3E8FF">
<form name="modform" method="post" onsubmit="return chkeckDeliFormMod();">
<input type="hidden" name="seq_project" value="<%=seq_project%>">
<input type="hidden" name="seq" value="">
<input type="hidden" name="_cnt" value="">
<input type="hidden" name="ablecnt" value="">
<tr align=center>
	<td valign=top class="bk1_1">
		<A HREF="javascript:" onclick="show1('div_mod','none')"><IMG SRC="/images/icon_del1.gif" BORDER="0" ALT="�ݱ�"></A></td>
	<td class="bk1_1">��ೳ����</td>
	<td class="bk1_1">������</td>
	<td class="bk1_1">��ġ��</td>
	<td class="bk1_1">��ġ���</td>
	<td class="bk1_1">����</td>
	<td class="bk1_1">&nbsp;</td>
</tr>
<tr>
	<td class="bk2_1" width="9" valign=top>&nbsp;</td>
	<td class="bk2_1" width="80">
		<input type="text" name="deliDate" value="" class="inputbox" style="width:100%"></td>
	<td class="bk2_1" width="80">
		<input type="text" name="realDeliDate" value="" class="inputbox" style="width:100%"></td>
	<td class="bk2_1" width="80">
		<input type="text" name="setupDate" value="" class="inputbox" style="width:100%"></td>
	<td class="bk2_1" width="180">
		<textarea style="width:100%;height:20" name="place"></textarea></td>
	<td class="bk2_1" width="80">
		<input type="text" name="cnt" value="" class="inputbox1" style="width:100%"></td>
	<td class="bk2_1" width="90">
		<input type="submit" value="����" class="inputbox2">
		<input type="button" value="����" class="inputbox2" onclick="deliDel()"></td>
</tr>
</form>
</table></div>


<!-- �޷� -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>
<iframe name="fme0" id="fme0" width="0" height="0"></iframe>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>