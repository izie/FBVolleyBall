<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{
	ProjectDAO cDAO = new ProjectDAO(db);
	Vector vecProject = cDAO.getList();

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
	parent.iframe1.location='list_origin.jsp?seq_project='+seq_project;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="18">
<%	for( int i=0 ; i<vecProject.size() ; i++ ){		
		Project pj = (Project)vecProject.get(i);	%>
<tr height=20>
	<td width="14" class="bk2_1"><IMG SRC="/images/icon_group.gif" WIDTH="14" HEIGHT="13" BORDER="0" ALT=""></td>
	<td class="bk2_1"> <a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('a<%=i%>','<%=pj.seq%>')"><%=pj.name%></a></td>
</tr>
<%	}//for	%>
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