<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();

try{ 
	EstItemDAO eiDAO = new EstItemDAO(db);

	//request
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int seq_estItem = KUtil.nchkToInt(request.getParameter("seq_estItem"));
	
	//System.out.println("seq_estItem"+seq_estItem);

	int inst = eiDAO.delete(seq_estItem);
	
	if( inst == -2 ){
		KUtil.scriptAlert(out,"다음을 참조하는 출고정보가 존재합니다.");
		return;
	}
	if( inst != 1 ){
		KUtil.scriptAlert(out,"삭제 에러");
		return;
	}
	
	KUtil.scriptOut(out,"parent.document.location.reload();");
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>