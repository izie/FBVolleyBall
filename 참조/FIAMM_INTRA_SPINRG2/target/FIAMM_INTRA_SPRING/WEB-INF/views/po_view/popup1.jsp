<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));
	
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
function opWin(seq){
	var lft = (screen.availWidth-720)/2;
	var opt = window.open("/main/lc/view.jsp?seq_po="+seq,"viEsti","width=720,height=200,left="+lft+",top=0,scrollbars=1");
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0">

</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
opWin('<%=seq_po%>');
</SCRIPT>

<%

}catch(Exception e){
	out.print(e.toString());
}
%>