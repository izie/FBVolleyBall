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

	
	EstimateDAO eiDAO = new EstimateDAO(db);	
	Vector vecEstimate = eiDAO.getList(seq_project);
%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function sel_item( i, seq ){
	var ofrm	= opener.document.contractAddForm;
	var frm		= document.estimateForm;
	ofrm.seq_estimate.value = seq;
	ofrm.estimate_name.value = eval("document.estimateForm.title"+i).value;
	top.window.close();
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
		<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('<%=i%>','<%=ei.seq%>')"><%=KUtil.nchk(ei.title)%></a>
		<textarea name="title<%=i%>" style="display:none"><%=KUtil.nchk(ei.title)%></textarea></td>
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
resize(300,400);
</SCRIPT>
<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>