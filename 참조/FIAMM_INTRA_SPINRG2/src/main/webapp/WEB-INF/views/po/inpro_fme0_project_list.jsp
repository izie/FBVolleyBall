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


	int totCnt = pDAO.getTotal(sk, st, seq_client);

	int pageSize =  15;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 5, totCnt, nowPage);
	
	String indicator = paging.getIndi("","[<]","[>]","");

	Vector vecProject = pDAO.getList(start, pageSize, sk, st, seq_client);
	int num = pageSize*nowPage - (pageSize-1);

	
	
%>

<HTML>
<head>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	chg_color();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	document.location = "inpro_fme0_project_list.jsp?nowPage="+pge+"&seq_client=<%=seq_client%>";
}
function clickProject(i,seq_project){
	sel_item( i );
	parent.document.frames['iframe2'].location = "inpro_fme2_contract_list.jsp?seq_project="+seq_project;
	parent.frames['iframe1'].location = "/blank.html"
}
function insertProject(seq_project){
	parent.document.frames['iframe1'].location = "inpro_frm_item_input.jsp?seq_project="+seq_project;
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 class="xnoscroll">



<table cellpadding="0" cellspacing="0" border="0" width="100%" id="id_mtb">

<form name="proj" method="post">


<%	for( int i=0 ; i<vecProject.size() ; i++ ){		
		Project pj = (Project)vecProject.get(i);	%>
<tr height=20>
	<td  class="bk2_1">
		<A HREF="javascript:;" onclick="insertProject('<%=pj.seq%>')"><IMG SRC="/images/icon_folder.gif" WIDTH="16" HEIGHT="15" BORDER="0" ALT="" align=absmiddle></A>
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:clickProject('<%=i%>','<%=pj.seq%>')"><%=pj.name%></a></td>
</tr>
<%	}//for	%>




<%	if( vecProject.size()<1 ){	%>
<tr height=50 align=center>
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
id_mtb.style.width = document.body.clientWidth;
</SCRIPT>
<%
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>