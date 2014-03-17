<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="project"/>
	<jsp:param name="col" value="V"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);

	Project pj = pDAO.selectOne(seq);
	Client cl = cDAO.selectOne(pj.seq_client);
	ClientUser cu = cuDAO.selectOne(pj.seq_clientUser);
%>


<HTML>
<HEAD>
<title>�Ǿ��ڸ���</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function goList(){
	var frm = document.projectForm;
	frm.action = "list.jsp";
	frm.submit();
}
function changeClient(){
	var frm = document.projectForm;
	if( frm.n_seq_client.selectedIndex < 1 ){
		for( var i=0 ; i<frm.seq_clientUser.length ; i++ ){
			frm.seq_clientUser.options[1] = null;
		}
		return;
	}
	var seq_cl = frm.n_seq_client.value;
	document.frames['clientUser'].location="client_user.jsp?seq_client="+seq_cl;
}
function projectFormCheck(){
	var frm = document.projectForm;
	frm.action = "DBM.jsp";
	return chkProjectForm(frm);
}
function showClientUser(){
	var lft = (screen.availWidth-410)/2;
	var pop = window.open("fm_index.jsp","client","width=400,height=350,top=0,left="+lft);
	pop.focus();
}
function chkProjectForm(frm){
	if( frm.n_seq_client.selectedIndex < 1 ){
		alert("�ŷ�ó�� �����Ͽ� �ֽʽÿ�!");
		frm.n_seq_client.focus();
		return false;
	}else if( !nchk(frm.name,"������Ʈ��") ){
		return false;
	}else if( !nchk(frm.stDate,"������") ){
		return false;
	}
}
function goModify(seq){
	var frm = document.projectForm;
	frm.seq.value = seq;
	frm.action = "mod.jsp";
	frm.submit();
}
function goDelete(seq){
	var frm = document.projectForm;
	if( confirm("�����Ͻðڽ��ϱ�?") ){
		frm.seq.value = seq;
		frm.action = "DBD.jsp";
		frm.submit();
	}
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="xnoscroll">
<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="projectForm" method="post" onsubmit="return projectFormCheck()">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="sk" value="<%=sk%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="seq_client" value="<%=seq_client%>">
<input type="hidden" name="seq" value="<%=seq%>">
<tr height=35>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">������Ʈ ����</FONT></B></td>
</tr>
<tr height=28 >
	<td class="ti1">&nbsp;�� ������Ʈ</td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=25 >
	<td width="100" align=right class="bk1_1">�ŷ�ó/�����</td>
	<td class="bk2_1">&nbsp;
		<%=cl.bizName%> / <%=KUtil.nchk(cu.userName)%></td>
</tr>
<tr height=25 >
	<td align=right class="bk1_1">������Ʈ��</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.nchk(pj.name)%></td>
</tr>
<tr height=25 >
	<td align=right class="bk1_1">������</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.toTextMode(pj.itemCom)%></td>
</tr>
<tr height=25 >
	<td align=right class="bk1_1">������</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.toDateViewMode(pj.stDate)%></td>
</tr>
<tr >
	<td align=right class="bk1_1" bgcolor="#f7f7f7">����</td>
	<td class="bk2_1" style="padding:5 5 5 5" valign=top>
		<%=KUtil.nchk(pj.content)%></td>
</tr>
<tr height=2 align=center class="bgc2">
	<td colspan=2></td>
</tr>
<tr height=25 align=center class="bgc1">
	<td colspan=2>
		<!-- <input type="button" value="����Ʈ" onclick="goList()"> -->
		<input type="button" value="����" onclick="goModify('<%=pj.seq%>')" class="inputbox2"> </td>
</tr>


</table>


<!-- �޷� -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>

<iframe id="clientUser" width="0" height="0"></iframe>

</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
resize(710,415);
</SCRIPT>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>