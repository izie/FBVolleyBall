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
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	Vector vecClientUser = cuDAO.getClientUser(seq_client);
%>

<HTML>
<head>
<title>피암코리아</title>
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
	var ofrm = opener.document.projectForm;
	ofrm.seq_clientUser.value = seq_clientUser;
	ofrm.clientUser_name.value = eval("document.clientUser.clientUser_name"+item_num).value;
	self.close();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}

</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<form name="clientUser" method="post">
<tr>
	<td valign=top>


<%	for( int i=0 ; i<vecClientUser.size() ; i++ ){		
		ClientUser cu = (ClientUser)vecClientUser.get(i);	%>
<div style="height:19" class="bk2_1">
	<IMG SRC="/images/icon_user.gif" WIDTH="13" HEIGHT="13" BORDER="0" ALT="">
	<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('<%=i%>','<%=cu.seq%>')"><%=cu.userName%></a>
	<textarea name="clientUser_name<%=i%>" style="display:none"><%=cu.userName%></textarea></div>
<%	}//for	%>


<%	if( vecClientUser.size()<1 ){%>
<div style="height:50">담당자가 존재하지 않습니다.</div>
<%	}	%>
	</td>
</tr>
</form>
</table>

</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
resize(200,250);
</SCRIPT>
<%
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>