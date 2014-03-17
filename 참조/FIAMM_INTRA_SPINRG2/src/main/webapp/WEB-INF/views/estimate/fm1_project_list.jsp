<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{
	//request
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	int winp		= KUtil.nchkToInt(request.getParameter("winp"));

	
	ProjectDAO pDAO = new ProjectDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);


	int totCnt = pDAO.getTotal(sk, st, seq_client);

	int pageSize =  8;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 5, totCnt, nowPage);
	
	String indicator = paging.getIndi("[<<]","[<]","[>]","[>>]");

	Vector vecProject = pDAO.getList(start, pageSize, sk, st, seq_client);
	int num = pageSize*nowPage - (pageSize-1);
	
	Vector vecClient = cDAO.getClient("매입");
	
	
%>

<HTML>
<head>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/move.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_project ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	chg_color();
	parent.opener.document.estimateForm.seq_project.value	= seq_project;
	parent.opener.document.estimateForm.projName.value		= eval("document.proj.projName"+item_num).value;
	parent.opener.document.estimateForm.title.value			= eval("document.proj.projName"+item_num).value;
	parent.opener.document.estimateForm.seq_client.value	= eval("document.proj.seq_client"+item_num).value;
	parent.opener.document.estimateForm.client_name.value	= eval("document.proj.client_name"+item_num).value;
	parent.opener.document.estimateForm.seq_clientUser.value= eval("document.proj.seq_clientUser"+item_num).value;
	parent.opener.document.estimateForm.clientUser_name.value= eval("document.proj.clientUser_name"+item_num).value;
	window.top.self.close();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	var frm = document.proj;
	frm.nowPage.value=pge;
	frm.action = "fm1_project_list.jsp";
	frm.submit();
}
function inProject(){
	var lft = (screen.availWidth-700)/2;
	var tp = (screen.availHeight-390)/2;
	var pop = window.open("/main/project/write.jsp?seq_client=<%=seq_client%>","padd","top="+tp+",left="+lft+",scrollbars=0,width=700,height=390");
	pop.focus();
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 class="xnoscroll">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="proj" method="post">
<input type="hidden" name="seq_client" value="<%=seq_client%>">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<%	for( int i=0 ; i<vecProject.size() ; i++ ){		
		Project pj = (Project)vecProject.get(i);	
		Client cl = cDAO.selectOne(pj.seq_client);		%>
<tr height=20>
	<td  class="bk2_1">
		<IMG SRC="/images/icon_folder.gif" WIDTH="16" HEIGHT="15" BORDER="0" ALT="" align=absmiddle> 
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('<%=i%>','<%=pj.seq%>')"><%=pj.name%></a>
		<textarea name="projName<%=i%>" style="display:none"><%=pj.name%></textarea>
		<input type="hidden" name="seq_client<%=i%>" value="<%=pj.seq_client%>">
		<input type="hidden" name="client_name<%=i%>" value="<%=cDAO.getBizName(cl,"KOR")%>">
		<input type="hidden" name="seq_clientUser<%=i%>" value="<%=pj.seq_clientUser%>">
		<input type="hidden" name="clientUser_name<%=i%>" value="<%=KUtil.nchk(cuDAO.selectOne(pj.seq_clientUser).userName)%>"></td>
</tr>
<%	}//for	%>
<%	if( vecProject.size()<1 ){	%>
<tr height=50>
	<td>데이타가 존재하지 않습니다.</td>
</tr>
<%	}	%>
<tr class="bgc1" align=center height="30">
	<td><%=indicator%></td>
</tr>
</form>
</table>

</BODY>
</HTML>





<SCRIPT LANGUAGE="JavaScript">
function insertItemCom(obj){
	var frm = document.frmPrjAdd;
	var str = obj.value.split("↕");
	var opt = new Option(str[1],str[0]);
	frm.itemCom.options[frm.itemCom.length] = opt;
}
function chkProjectForm(frm){
	if( !nchk(frm.seq_client, "거래처") ) return false;
	else if( !nchk(frm.name, "프로젝트명") ) return false;
	else if( !dateCheck(frm.stDate, "시작일") ) return false;
	return true;
}
function projectAdd(){
	var frm = document.frmPrjAdd;
	for( var i=0 ; i<frm.itemCom.length ; i++ ){
		frm.itemCom.options[i].selected = true;
	}
	if( chkProjectForm(frm)  ){
		frm.target = "fm_pa";
		frm.action = "/main/project/DBW.jsp";
		frm.submit();
	}
}
function showClientUser(){
	var lft = (screen.availWidth-400)/2;
	var tp	= (screen.availHeight-360)/2;
	var pop = window.open("fm_index2.jsp?seq_client=<%=seq_client%>","client","width=400,height=500,top="+tp+",left="+lft);
	pop.focus();
}
function delItem(){
	var frm = document.frmPrjAdd;
	for( var i=frm.itemCom.length-1 ; i>=0 ; i-- ){
		if( frm.itemCom.options[i].selected ){
			frm.itemCom.options[i] = null;
		}
	}
}
</SCRIPT>

<!-- onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" -->
<DIV id="id_pa" style="display:block;position:absolute;top:105;left:1;width:99%;;">
<table cellpadding="0" cellspacing="0" border="0" width="100%" style="border:1 solid #804000">
<form name="frmPrjAdd" method="post" onsubmit="return false;">
<input type="hidden" name="seq_client" value="<%=seq_client%>">
<input type="hidden" name="reload" value="close">
<tr height=25>
	<td class="ti1" width="100">▶ 프로젝트 추가</td>
	<td class="ti1" align=right><A HREF="javascript:" onclick="id_pa.style.display='none';"><IMG SRC="/images/icon_del1.gif" WIDTH="13" HEIGHT="13" BORDER="0" ALT="닫기"></A></td>
</tr>
<tr height=25 >
	<td class="bk1_1" width="100" align=right>거래처/담당자</td>
	<td class="bk2_1">&nbsp;
		<input type="text" class="inputbox1" name="client_name" value="" size="15" readonly>
		<input type="text" class="inputbox" name="clientUser_name" value="" size="13" readonly>
		<input type="hidden" name="seq_clientUser" value="">
		<input type="button" value="선택" onclick="showClientUser()" class="inputbox2"></td>
</tr>
<tr height=25 >
	<td class="bk1_1" align=center>프로젝트명</td>
	<td class="bk2_1">&nbsp;
		<input type="text" name="name" value="" size="20" maxlength="150" class="inputbox1"></td>
</tr>

<tr height=50 >
	<td class="bk1_1" align=center>프로젝트구분</td>
	<td class="bk2_1">
		<select name="_itemCom" class="selbox"  MULTIPLE SIZE=3 ondblclick="insertItemCom(this)" style="width:100%; height:70px;">
	<%	for( int i=0 ; i<vecClient.size() ; i++ ){	
			Client cl = (Client)vecClient.get(i);		%>
			<option value="<%=cl.seq%>↕<%=cl.bizName%>"><%=cl.bizName%></option>
	<%	}	%>
		</select>
		<select name="itemCom" class="selbox" MULTIPLE SIZE=3  class="selbox" style="width:100%; height:70px;">	
		</select>
		<input type="button" value="선택항목삭제" onclick="delItem()" class="inputbox2"></td>
</tr>
<tr height=25 >
	<td class="bk1_1" align=center>시작일</td>
	<td class="bk2_1">&nbsp;
		<input type="text" name="stDate" value="<%=KUtil.getIntDate("yyyyMMdd")%>" class="inputbox1" size="12" maxlength="8"></td>
</tr>
<tr height=25 align=right>
	<td colspan=2><input type="button" value="입력" class="inputbox2" onclick="projectAdd()"></td>
</tr>
</form>
</table></DIV>
<iframe name="fm_pa" id="fm_pa" width="0" height="0" frameborder="0"></iframe>

<%
	if( winp == 1 ){
		KUtil.scriptOut(out,"resize(400,529);");
	}
%>
<SCRIPT LANGUAGE="JavaScript">
id_pa.style.top = document.body.clientHeight-300;
</SCRIPT>
<%	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>