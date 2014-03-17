<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
		
	int seq_client = KUtil.nchkToInt(request.getParameter("seq_client"));

	ClientUserDAO cuDAO = new ClientUserDAO(db);
	Vector vecClientUser = cuDAO.getClientUser(seq_client);	%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_clientUser ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	chg_color();
	var pfrm = parent.document.estimateItem;
	pfrm.seq_clientUser.value = seq_clientUser;
	pfrm.clientUser_name.value = eval("document.clientForm.clientUser_name"+item_num).value;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function popAddClientUser(){
	var frm = parent.document.estimateItem;

	var lft = (screen.availWidth-700)/2;
	var tp	= (screen.availHeight-500)/2;
	var pop = window.open("/main/client/clientUser_write.jsp?reload=2&seq="+frm.seq_client.value,"cuadd","width=700,height=500,scrollbars=0,left="+lft+",top="+tp);
	pop.focus();

}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height=100%>
<form name="clientForm" method="post">
<input type="hidden" name="seq_client" value="">
<%	for( int i=0 ; i<vecClientUser.size() ; i++ ){		
		ClientUser cu = (ClientUser)vecClientUser.get(i);	%>
		<tr height="18">
			<td class="bk2_1">
			<IMG SRC="/images/icon_user.gif" BORDER="0" ALT="" align=absmiddle>  
			<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('<%=i%>','<%=cu.seq%>')"><%=cu.userName%>&nbsp;<%=cu.classPosi%></a>
			<input type="hidden" name="clientUser_name<%=i%>" value="<%=cu.userName%>"></td>
		</tr>
<%	}//for	%>

<%	if( vecClientUser.size()<1 ){	%>
		<tr height="50">
			<td>담당자가 없습니다.</td>
		</tr>

<%	}	%>
		<tr>
			<td></td>
		</tr>
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