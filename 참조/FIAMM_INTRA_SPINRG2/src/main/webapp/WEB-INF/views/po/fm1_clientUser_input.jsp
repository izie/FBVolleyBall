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
	String[] arr_seq_clientUser = request.getParameterValues("seq_clientUser"));

	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	Client cl		= cDAO.selectOne(seq_client);
	ClientUser cu	= cuDAO.selectOne(seq_clientUser);




	
	if( cl.seq > 0 ){
%>
	<SCRIPT LANGUAGE="JavaScript">
		var opfrm = parent.opener.document.poForm;
		opfrm.client_name.value = "<%=KUtil.nchk(cl.bizName).replaceAll("\"","\'")%>";
		opfrm.seq_client.value = "<%=cl.seq%>";
		<%	if( cu.seq > 0 ){	%>
		opfrm.clientUser_name.value = "<%=KUtil.nchk(cu.userName).replaceAll("\"","\'")%>";
		opfrm.seq_clientUser.value = "<%=cu.seq%>";
		<%	}	%>
		top.self.close();
	</SCRIPT>
<%
	}

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>