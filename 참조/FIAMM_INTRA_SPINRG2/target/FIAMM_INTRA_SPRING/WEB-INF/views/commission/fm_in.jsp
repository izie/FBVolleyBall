<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));

	PoDAO poDAO		= new PoDAO(db);
	
	Po po		= poDAO.selectOne(seq_po);
	
%>
<SCRIPT LANGUAGE="JavaScript">
var tfrm = top.document.tForm;
<%	
	if( po.seq_client != 0 ){	%>
		for( var i=0 ; i<tfrm.seq_client.length ; i++ ){
			if( Number( tfrm.seq_client.options[i].value ) == <%=po.seq_client%> ){
				tfrm.seq_client.options[i].selected=true;
			}
		}
<%	}								%>
	tfrm.pono.value = "<%=poDAO.getPoNo(po)%>";
	tfrm.seq_po.value = "<%=seq_po%>";
</SCRIPT>

<%	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>