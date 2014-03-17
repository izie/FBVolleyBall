<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{ 
	//requets
	int seq_client = KUtil.nchkToInt(request.getParameter("seq_client"));
	int seq_clientUser = KUtil.nchkToInt(request.getParameter("seq_clientUser"));

	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	Client cl		= cDAO.selectOne(seq_client);
	ClientUser cu	= cuDAO.selectOne(seq_clientUser);




	
	if( cl.seq > 0 ){
%>
<form name="inform">
<textarea name="bizName" style="display:none"><%=KUtil.nchk(cl.bizName)%></textarea>
<textarea name="userName" style="display:none"><%=KUtil.nchk(cl.userName)%></textarea>
</form>
	<SCRIPT LANGUAGE="JavaScript">
		var opfrm = parent.opener.document.projectForm;
		var frm = document.inform;
		opfrm.client_name.value = frm.bizName.value;
		opfrm.seq_client.value = "<%=cl.seq%>";
		<%	if( cu.seq > 0 ){	%>
		opfrm.clientUser_name.value = frm.userName.value;
		opfrm.seq_clientUser.value = "<%=cu.seq%>";
		<%	}	%>
		parent.self.close();
	</SCRIPT>
<%
	}

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>