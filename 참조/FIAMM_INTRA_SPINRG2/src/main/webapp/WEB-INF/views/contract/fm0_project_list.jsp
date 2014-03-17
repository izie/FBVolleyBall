<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
	//request
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));

	
	ProjectDAO pDAO = new ProjectDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);


	int totCnt = pDAO.getTotal(sk, st, seq_client);

	int pageSize =  15;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 3, totCnt, nowPage);
	
	String indicator = paging.getIndi("[<<]","[<]","[>]","[>>]");

	Vector vecProject = pDAO.getList(start, pageSize, sk, st, seq_client);
%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_project ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	parent.frames['iframe1'].location = "fm1_estimate_list.jsp?seq_project="+seq_project;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	document.location = "fm0_project_list.jsp?nowPage="+pge+"&seq_client=<%=seq_client%>";
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<form name="projectForm" method="post">


<%	for( int i=0 ; i<vecProject.size() ; i++ ){		
		Project pj = (Project)vecProject.get(i);	%>
<tr height=20>
	<td class="bk2_1">
		<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
		<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=pj.seq%>')"><%=pj.name%></a></td>
</tr>
<%	}//for	%>

<%	if( vecProject.size()<1 ){	%>
<tr height=50>
	<td>프로젝트가 없습니다.</td>
</tr>
<%	}	%>
<tr>
	<td></td>
</tr>
<tr height=20 align=center>
	<td class="bgc1"><%=indicator%></td>
</tr>
</table>
</form>
</BODY>
</HTML>



<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>