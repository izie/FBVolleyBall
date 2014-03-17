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


	
	ProjectDAO pDAO = new ProjectDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);


	int totCnt = pDAO.getCommissionTotal(sk, st, seq_client);

	int pageSize =  10;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 5, totCnt, nowPage);
	
	String indicator = paging.getIndi("[<<]","[<]","[>]","[>>]");

	Vector vecProject = pDAO.getCommissionList(start, pageSize, sk, st, seq_client);
	int num = pageSize*nowPage - (pageSize-1);
	
	
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
	var pfrm = parent.document.tForm;
	pfrm.seq_project.value	= seq_project;
	pfrm.project_name.value	= eval("document.proj.project_name"+item_num).value;
	top.document.frames['fm1'].location.href = "fm_po_list.jsp?seq_project="+seq_project;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	var frm = document.proj;
	frm.nowPage.value=pge;
	frm.action = "fm_project_list.jsp";
	frm.submit();
}
function chkSearch(){
	var frm = document.proj;
	frm.nowPage.value = 1;
	frm.target = "_self";
	frm.action = "fm_project_list.jsp";
	return true;
}
</SCRIPT>
</head>
<BODY class="xnoscroll">
<table cellpadding="0" cellspacing="0" border="0" width="100%" id="id_mtb">
<form name="proj" method="post" onsubmit="return chkSearch();">
<input type="hidden" name="seq_client" value="<%=seq_client%>">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="sk" value="name">
<%	for( int i=0 ; i<vecProject.size() ; i++ ){		
		Project pj = (Project)vecProject.get(i);	
		Client cl = cDAO.selectOne(pj.seq_client);		%>
<tr height=20>
	<td  class="bk2_1">
		<IMG SRC="/images/icon_folder.gif" WIDTH="16" HEIGHT="15" BORDER="0" ALT="" align=absmiddle> 
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('<%=i%>','<%=pj.seq%>')"><%=pj.name%></a>
		<textarea name="project_name<%=i%>" style="display:none"><%=KUtil.nchk(pj.name)%></textarea></td>
</tr>
<%	}//for	%>
<%	if( vecProject.size()<1 ){	%>
<tr height=50>
	<td>데이타가 존재하지 않습니다.</td>
</tr>
<%	}	%>

<tr class="bgc1" align=center height="30">
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;<%=indicator%></td>
			<td align=right>
				<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>프로젝트명검색:</td>
					<td><input type="text" name="st" value="<%=KUtil.nchk(st)%>" size="10" class="inputbox">
						<input type="submit" value="검색" class="inputbox2"></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>
</form>
</table>

</BODY>
</HTML>


<SCRIPT LANGUAGE="JavaScript">
id_mtb.style.width = document.body.clientWidth;
</SCRIPT>
<%	
}catch(Exception e){
	out.print(e.toString());
}finally{

	db.closeAll();
}
%>