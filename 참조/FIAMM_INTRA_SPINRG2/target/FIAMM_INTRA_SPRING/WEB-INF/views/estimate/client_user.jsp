<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%
	Database db  = new Database();
try{ 
	//request
	int seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	int seq_clientUser	= KUtil.nchkToInt(request.getParameter("seq_clientUser"));
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	Vector vecUser = cuDAO.getClientUser(seq_client);
%>




<SCRIPT LANGUAGE="JavaScript">
var frm = parent.estimateForm;
var len = frm.seq_clientUser.length;
for( var i=0 ; i<len ; i++ ){
	frm.seq_clientUser.options[1] = null;
}
<%	for( int i=0 ; i<vecUser.size() ; i++ ){	
		ClientUser cu = (ClientUser)vecUser.get(i);			%>
	var opt = new Option('<%=cu.userName%>','<%=cu.seq%>');  
	frm.seq_clientUser.options[<%=i+1%>] = opt;
<%		if( seq_clientUser > 0 && seq_clientUser==cu.seq ){	%>
			frm.seq_clientUser.options[<%=i+1%>].selected = true;	
<%		}//if
	}//for	%>
</SCRIPT>




<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>