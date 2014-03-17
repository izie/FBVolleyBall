<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
		
	int seq_project = KUtil.nchkToInt(request.getParameter("seq_project"));

	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);
	EstimateDAO eiDAO = new EstimateDAO(db);

	Project pj = pDAO.selectOne(seq_project);
	Vector vecEstimate = eiDAO.getList(seq_project);
	Client cl = cDAO.selectOne(pj.seq_client);
%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_estimate ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	document.location = "fm1_estimate_input.jsp?seq_estimate="+seq_estimate;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<form name="estimateForm" method="post">
<table cellpadding="0" cellspacing="0" border="0" width="100%">


<%	for( int i=0 ; i<vecEstimate.size() ; i++ ){		
		Estimate ei = (Estimate)vecEstimate.get(i);	%>
<tr height=20>
	<td class="bk2_1">
		[<%=eiDAO.getEstNo(ei)%>]
		<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
		<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=ei.seq%>')"><%=ei.title%></a></td>
</tr>
<%	}//for	%>

<%	if( vecEstimate.size()<1 ){	%>
<tr height=50>
	<td>견적서가 없습니다.</td>
</tr>

<%	}	%>

</form>
</table>
</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
var frm = parent.opener.document.contractAddForm;
frm.seq_project.value = "<%=pj.seq%>";
frm.project_name.value = "<%=pj.name%>";
frm.seq_estimate.value = "";
frm.estimate_name.value = "";
frm.conTotPrice.value = "0";
frm.deliDate.value = "";
frm.seq_client.value = "<%=pj.seq_client%>";
frm.client_name.value = "<%=cDAO.getBizName(cl,"KOR")%>";
frm.seq_clientUser.value = "<%=pj.seq_clientUser%>";
frm.clientUser_name.value = "<%=KUtil.nchk(cuDAO.selectOne(pj.seq_clientUser).userName)%>";
</SCRIPT>

<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>