<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();

try{ 
	PoItemDAO piDAO = new PoItemDAO(db);

	//request
	int seq_po		= KUtil.nchkToInt(request.getParameter("seq_po"));
	int seq_poitem	= KUtil.nchkToInt(request.getParameter("seq_poitem"));
	

	int inst = piDAO.delete(seq_poitem);

	if( inst != 1 ){
		KUtil.scriptAlertBack(out,"���� ����");
		return;
	}
	
	KUtil.scriptAlertMove(out,"�����Ǿ����ϴ�.","mod.jsp?seq_po="+seq_po);
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>