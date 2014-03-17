<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function inputData(){
	
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="400">
<form name="estimateItem" method="post">
<input type="hidden" name="seq_client" value="">
<input type="hidden" name="seq_clientUser" value="">
<tr align=center height=28>
	<td class="ti1">업체명</td>
	<td class="ti1">담당자</td>
</tr>
<tr>
	<td class="tdAllLine"><iframe id="iframe0" src="fm0_client_list.jsp" width="200" height="350" frameborder="0"></iframe></td>
	<td class="tdAllLine"><iframe id="iframe1" width="200" height="350" frameborder="0"></iframe></td>
</tr>
<tr align=right>
	<td colspan=2 class="bmenu"><input type="button" value="닫기" onclick="self.close()" class="inputbox2">&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</form>
</table>
</BODY>
</HTML>


<SCRIPT LANGUAGE="JavaScript">
resize(415,485);
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}
%>