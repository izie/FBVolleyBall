<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	TtDAO ttDAO = new TtDAO(db);
	
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));
	int reload = KUtil.nchkToInt(request.getParameter("reload"));

	Tt tt = ttDAO.selectOnePo(seq_po);
	
	String qry = "?seq_po="+seq_po+"&reload="+reload;
	
	if( tt.seq > 0 ){
		KUtil.scriptOut(out,"document.location='mod.jsp"+qry+"';");
	}else{
		KUtil.scriptOut(out,"document.location='write.jsp"+qry+"';");
	}

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>