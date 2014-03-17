<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<%  
	response.setHeader("cache-control","no-cache");  
	response.setHeader("expires","0");  
	response.setHeader("pragma","no-cache");  
try{ 
	String fileName = request.getParameter("fileName");	
	String saveDir = request.getRealPath("/main/po/form");

	File file = new File(saveDir, fileName);
	if( KUtil.nchk(fileName).length()<1 || !file.exists() ){
		KUtil.scriptAlertBack(out,"파일이 존재하지 않습니다.");
		return;
	}
	String memo = KUtil.fileRead(saveDir, fileName);
	String flag		= "_@@@@_";
	String[] arrStr = memo.split(flag);
%>

<FORM METHOD=POST NAME="iForm">
<%	for( int i=0 ; i<arrStr.length ; i++ ){	%>
<textarea name="t<%=i+1+""%>" style="display:none"><%=KUtil.nchk(arrStr[i])%></textarea>
<%	}	%>
</FORM>

<SCRIPT LANGUAGE="JavaScript">
<%	for( int i=0 ; i<arrStr.length ; i++ ){	%>
parent.parent.document.bForm.t<%=i+1+""%>.value = document.iForm.t<%=i+1+""%>.value;
<%	}//for	%>
parent.parent.show4('di1');
parent.parent.dshow();
</SCRIPT>

<%
}catch(Exception e){
	out.print(e.toString());
}
%>