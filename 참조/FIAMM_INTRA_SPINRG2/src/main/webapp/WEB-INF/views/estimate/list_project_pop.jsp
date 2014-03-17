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

	int pageSize =  20;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 5, totCnt, nowPage);
	
	String indicator = paging.getIndi();

	Vector vecProject = pDAO.getList(start, pageSize, sk, st, seq_client);
	int num = pageSize*nowPage - (pageSize-1);

	
	
%>

<HTML>
<head>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_project ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	chg_color();
	opener.document.estimateForm.seq_project.value=seq_project;
	opener.document.estimateForm.projName.value = eval("document.proj.projName"+item_num).value;
	opener.document.estimateForm.seq_client.value=eval("document.proj.seq_client"+item_num).value;
	opener.document.estimateForm.client_name.value = eval("document.proj.client_name"+item_num).value;
	opener.document.estimateForm.seq_clientUser.value=eval("document.proj.seq_clientUser"+item_num).value;
	opener.document.estimateForm.clientUser_name.value = eval("document.proj.clientUser_name"+item_num).value;
	self.close();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	document.location = "list_project_pop.jsp?nowPage="+pge;
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<form name="proj" method="post">
<tr>
	<td valign=top>

<%	for( int i=0 ; i<vecProject.size() ; i++ ){		
		Project pj = (Project)vecProject.get(i);	%>
<div style="height:19" class="bk2_1">
	<IMG SRC="/images/icon_folder.gif" WIDTH="16" HEIGHT="15" BORDER="0" ALT="" align=absmiddle> 
	<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('<%=i%>','<%=pj.seq%>')"><%=pj.name%></a>
	<textarea name="projName<%=i%>" style="display:none"><%=pj.name%></textarea>
	<input type="hidden" name="seq_client<%=i%>" value="<%=pj.seq_client%>">
	<input type="hidden" name="client_name<%=i%>" value="<%=KUtil.nchk(cDAO.selectOne(pj.seq_client).bizName)%>">
	<input type="hidden" name="seq_clientUser<%=i%>" value="<%=pj.seq_clientUser%>">
	<input type="hidden" name="clientUser_name<%=i%>" value="<%=KUtil.nchk(cuDAO.selectOne(pj.seq_clientUser).userName)%>"></div>
<%	}//for	%>
<%	if( vecProject.size()<1 ){	%>
	<div style="height:50">데이타가 존재하지 않습니다.</div>
<%	}	%>
	</td>
</tr>
<tr class="bgc1" align=center height="30">
	<td><%=indicator%></td>
</tr>
</form>
</table>

</BODY>
</HTML>

<%
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>