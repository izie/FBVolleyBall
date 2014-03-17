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
	int seq_poitem = KUtil.nchkToInt(request.getParameter("seq_poitem"));

	int inst = piDAO.delete(seq_poitem);
	
	if( inst == -2 ){
		KUtil.scriptAlert(out,"������ �����ϴ� ��ġ���� ������ �����մϴ�.");
		return;
	}
	if( inst != 1 ){
		KUtil.scriptAlert(out,"���� ����");
		return;
	}
	
	KUtil.scriptOut(out,"parent.repage();");
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>