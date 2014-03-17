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
	int seq_project	= KUtil.nchkToInt(request.getParameter("seq_project"));

	
	ProjectDAO pDAO		= new ProjectDAO(db);
	ContractDAO cDAO	= new ContractDAO(db);
	Vector vecContract	= cDAO.getListInProject(seq_project);		
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
	document.location = "inpro_fme0_project_list.jsp?nowPage="+pge;
}
function insertContract(i,seq_contract){
	sel_item( i );
	parent.document.frames['iframe1'].location = "inpro_frm_item_input.jsp?seq_project=<%=seq_project%>&seq_contract="+seq_contract;
}
function clickProject(i,seq_contract){
	sel_item( i );
	parent.document.frames['iframe1'].location = "inpro_fme1_item_list.jsp?seq_project=<%=seq_project%>&seq_contract="+seq_contract;
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 class="xnoscroll">



<table cellpadding="0" cellspacing="0" border="0" width="100%" id="id_mtb">

<form name="proj" method="post">


<%	for( int i=0 ; i<vecContract.size() ; i++ ){		
		Contract ct = (Contract)vecContract.get(i);	%>
<tr height=20>
	<td  class="bk2_1">
		<A HREF="javascript:" onclick="insertContract('<%=i%>','<%=ct.seq%>')">
			<IMG SRC="/images/icon_folder.gif" WIDTH="16" HEIGHT="15" BORDER="0" ALT="" align=absmiddle></a>
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:clickProject('<%=i%>','<%=ct.seq%>')">
			<%=cDAO.getContractNo(ct)%></a></td>
</tr>
<%	}//for	%>




<%	if( vecContract.size()<1 ){	%>
<tr height=50>
	<td>데이타가 존재하지 않습니다.</td>
</tr>
<%	}	%>
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