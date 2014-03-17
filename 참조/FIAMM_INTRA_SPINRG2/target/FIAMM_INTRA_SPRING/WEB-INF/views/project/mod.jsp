<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="project"/>
	<jsp:param name="col" value="M"/>
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
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));


	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);

	Project pj = pDAO.selectOne(seq);
	Client cl = cDAO.selectOne(pj.seq_client);
	ClientUser cu = cuDAO.selectOne(pj.seq_clientUser);

	Vector vecClient = cDAO.getClient("매입");
%>


<HTML>
<HEAD>
<title>피암코리아</title>
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
	for( var i=0 ; i<frm.itemCom.length ; i++ ){
		frm.itemCom.options[i].selected = true;
	}
	return chkProjectForm(frm);
}
function showClientUser(){
	var lft = (screen.availWidth-300)/2;
	var pop = window.open("list_clientUser_pop.jsp?seq_client=<%=cl.seq%>","clientUser","scrollbars=1");
	pop.focus();
}
function chkProjectForm(frm){
	//if( !nchk(frm.client_name,"거래처") ) return false;
	//else if( !nchk(frm.clientUser_name,"담당자") ) return false;
	//else if( !nchk(frm.name,"프로젝트명") ) return false;
	//else 
	if( !nchk(frm.stDate,"시작일") ) return false;
	return true;
}
function delProject(){
	if( confirm("삭제하시겠습니까?") ){
		var frm = document.projectForm;
		frm.action = "DBD.jsp";
		frm.submit();
	}	
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

<BODY leftmargin="0" topmargin="0" class="xnoscroll">


<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="projectForm" method="post" onsubmit="return projectFormCheck()">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="sk" value="<%=sk%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="seq_client" value="<%=seq_client%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="reload" value="<%=reload%>">
<tr height=28 >
	<td class="ti1">&nbsp;▶ 프로젝트 수정</td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=25 >
	<td class="bk1_1" width="100" align=right>거래처/담당자</td>
	<td class="bk2_1">&nbsp;
		<%=cl.bizName%>
		<input type="text" class="inputbox" name="clientUser_name" value="<%=KUtil.nchk(cu.userName)%>" size="10" readonly>
		<input type="hidden" name="seq_clientUser" value="<%=cu.seq%>">
		<input type="button" value="선택" onclick="showClientUser()" class="inputbox2"></td>
</tr>
<tr height=25 >
	<td class="bk1_1" align=right>프로젝트명</td>
	<td class="bk2_1">&nbsp;
		<input type="text" name="name" value="<%=KUtil.nchk(pj.name)%>" size="40" maxlength="150" class="inputbox1"></td>
</tr>
<tr height=25 >
	<td class="bk1_1" align=right>프로젝트구분</td>
	<td class="bk2_1">&nbsp;
		<select name="_itemCom" class="selbox" MULTIPLE SIZE=3 ondblclick="insertItemCom(this)">
	<%	for( int i=0 ; i<vecClient.size() ; i++ ){	
			Client cl1 = (Client)vecClient.get(i);		%>
			<option value="<%=cl1.seq%>↕<%=cl1.bizName%>"><%=cl1.bizName%></option>
	<%	}	%>
		</select>
	
		<select name="itemCom" class="selbox" MULTIPLE SIZE=3>	
	<%	String[] arrName	= KUtil.nchk(pj.itemCom).split("\n");	
		String[] arrSeq		= KUtil.nchk(pj.com_seq_client).split(",");
		if( arrSeq != null ){
			for( int i=0 ; i<arrSeq.length && KUtil.nchk(arrSeq[i]).length() > 0  ; i++ ){		%>
			<option value="<%=KUtil.nchk(arrSeq[i])%>"><%=KUtil.nchk(arrName[i])%></option>	
	<%		}//for
		}//if	%>	
		</select>
		
		<input type="button" value="선택항목삭제" onclick="delItem()" class="inputbox2"></td>
</tr>
<tr height=25 >
	<td class="bk1_1" align=right>시작일</td>
	<td class="bk2_1">&nbsp;
		<input type="text" name="stDate" value="<%=KUtil.toDateViewMode(pj.stDate)%>" class="inputbox1" size="12" maxlength="10" readonly>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.projectForm.stDate,'',calStr);showbox1(calStr,'block',100,-30);" align=absmiddle></td>
</tr>
<tr height=25 >
	<td class="bk1_1" align=right>Commission</td>
	<td class="bk2_1">&nbsp;
		<input type="checkbox" name="isCommission" value="1" <%=pj.isCommission==1?"checked":""%>> 
		Commission Project 일경우 체크하여 주십시요!</td>
</tr>
<tr >
	<td class="bk1_bg" align=right>내용</td>
	<td style="padding:0 0 0 5"><textarea name="content" style="width:590;height:200"><%=KUtil.nchk(pj.content)%></textarea></td>
</tr>
<tr height=2 align=center class="bgc2">
	<td colspan=2></td>
</tr>

<tr height=25 align=center class="bgc1">
	<td colspan=2>
		<input type="submit" value="수정" class="inputbox2">	
		<input type="button" value="삭제" class="inputbox2" onclick="delProject()">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>


</table>




<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>

<iframe id="clientUser" width="0" height="0"></iframe>

</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
editor_generate("content");
resize(725,470);
</SCRIPT>


<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>