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
		KUtil.scriptAlert(out,"다음을 참조하는 설치대장 정보가 존재합니다.");
		return;
	}
	if( inst != 1 ){
		KUtil.scriptAlert(out,"삭제 에러");
		return;
	}
	
	KUtil.scriptOut(out,"parent.repage();");
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>