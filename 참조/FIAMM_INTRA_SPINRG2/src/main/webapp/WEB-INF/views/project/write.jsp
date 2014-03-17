<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="project"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));


	ClientDAO cDAO = new ClientDAO(db);

	Vector vecClient = cDAO.getClient("매입");
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function showClientUser(){
	var lft = (screen.availWidth-400)/2;
	var tp	= (screen.availHeight-360)/2;
	var pop = window.open("fm_index.jsp?seq_client=<%=seq_client%>","client","width=400,height=500,top="+tp+",left="+lft);
	pop.focus();
}
function viewItemCom(){
	var lft = (screen.availWidth-720)/2;
	var tp	= (screen.availHeight);
	var pop = window.open("/main/item/index.jsp","client","width=720,height="+tp+",top=0,left="+lft);
	pop.focus();
}
function projectFormCheck(){
	var frm = document.projectForm;
	frm.action = "DBW.jsp";
	for( var i=0 ; i<frm.itemCom.length ; i++ ){
		frm.itemCom.options[i].selected = true;
	}
	return chkProjectForm(frm);
}
function chkProjectForm(frm){
	if( !nchk(frm.client_name, "거래처") ) return false;
	else if( !nchk(frm.name, "프로젝트명") ) return false;
	else if( !dateCheck(frm.stDate, "시작일") ) return false;
	else if( !nchk(frm.stDate, "시작일") ) return false;
	return true;
}
function insertItemCom(obj){
	var frm = document.projectForm;
	var str = obj.value.split("↕");
	var opt = new Option(str[1],str[0]);
	frm.itemCom.options[frm.itemCom.length] = opt;
}
function delItem(){
	var frm = document.projectForm;
	for( var i=frm.itemCom.length-1 ; i>=0 ; i-- ){
		if( frm.itemCom.options[i].selected ){
			frm.itemCom.options[i] = null;
		}
	}
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="projectForm" method="post" onsubmit="return projectFormCheck()">
<tr height=28 >
	<td class="ti1">&nbsp;▶ 신규 프로젝트 입력</td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">

<tr height=25 >
	<td class="bk1_1" width="100" align=right>거래처/담당자</td>
	<td class="bk2_1">&nbsp;
		<input type="text" class="inputbox1" name="client_name" value="" size="20" readonly>
		<input type="hidden" name="seq_client" value="">
		<input type="text" class="inputbox" name="clientUser_name" value="" size="13" readonly>
		<input type="hidden" name="seq_clientUser" value="">
		<input type="button" value="선택" onclick="showClientUser()" class="inputbox2"></td>
</tr>

<tr height=25 >
	<td class="bk1_1" align=right>프로젝트명</td>
	<td class="bk2_1">&nbsp;
		<input type="text" name="name" value="" size="50" maxlength="150" class="inputbox1"></td>
</tr>

<tr height=25 >
	<td class="bk1_1" align=right>프로젝트구분</td>
	<td class="bk2_1">&nbsp;
		<select name="_itemCom" class="selbox" MULTIPLE SIZE=3 ondblclick="insertItemCom(this)">
	<%	for( int i=0 ; i<vecClient.size() ; i++ ){	
			Client cl = (Client)vecClient.get(i);		%>
			<option value="<%=cl.seq%>↕<%=cl.bizName%>"><%=cl.bizName%></option>
	<%	}	%>
		</select>
		<select name="itemCom" class="selbox" MULTIPLE SIZE=3>	
		</select>
		<input type="button" value="선택항목삭제" onclick="delItem()" class="inputbox2"></td>
</tr>

<tr height=25 >
	<td class="bk1_1" align=right>시작일</td>
	<td class="bk2_1">&nbsp;
		<input type="text" name="stDate" value="<%=KUtil.getIntDate("yyyyMMdd")%>" class="inputbox1" size="12" maxlength="8">
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.projectForm.stDate,'',calStr);showbox1(calStr,'block',100,50);" align=absmiddle></td>
</tr>

<tr height=25 >
	<td class="bk1_1" align=right>Commission</td>
	<td class="bk2_1">&nbsp;
		<input type="checkbox" name="isCommission" value="1"> Commission Project 일경우 체크하여 주십시요!</td>
</tr>
<!-- <tr height=25 >
	<td class="bk1_1" align=right>일련번호</td>
	<td class="bk2_1">&nbsp;
		<input type="text" name="serial" value="" class="inputbox" size="30" maxlength="100"></td>
</tr> -->
<tr >
	<td class="bk1_bg" align=right>내용</td>
	<td style="padding:0 0 0 5"><textarea name="content" style="width:590;height:200"></textarea></td>
</tr>
<tr height=2 align=center class="bgc2">
	<td colspan=2></td>
</tr>
<tr height=25 align=center class="bgc1">
	<td colspan=2>
	<input type="submit" value="입력" class="inputbox2">
	<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>


</table>


<!-- 달력 -->
<div id="calStr" style="position:absolute;display:none;"></div>

<iframe id="clientUser" width="0" height="0"></iframe>

</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
editor_generate("content");
resize(740, 525);
</SCRIPT>


<%

}catch(Exception e){
	out.print(e.toString());  
}finally{
	db.closeAll(); 
}
%>
