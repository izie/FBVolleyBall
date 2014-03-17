<%@page language="Java" contentType="text/html;charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	int idx = KUtil.nchkToInt(request.getParameter("idx"));
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function itemLenView(){
	var frm = document.estimateItem;
	var obj	= opener.document.getElementById("in_table01");
	var len = obj.rows.length;
	var lenObj = document.getElementById("lenObj");
	lenObj.innerHTML = "견적서품목: <b><font color='#660000'>"+len+"</font></b> 개";
}
</SCRIPT>
</HEAD>

<BODY>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="estimateItem" method="post">
<input type="hidden" name="idx" value="<%=idx%>">
<tr height=28 align=center>
	<td class="ti1">제조사</td>
	<td class="ti1">품명</td>
</tr>
<tr>
	<td width="300" class="tdAllLine">
		<iframe id="iframe0" src="item_fm0_list.jsp" width="100%" height="250" frameborder="0"></iframe></td>
	<td width="300" class="tdAllLine">
		<iframe id="iframe1" width="100%" height="250" frameborder="0"></iframe></td>
</tr>
<tr align=center height=28>
	<td class="ti1" colspan=2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr align=center>
			<td width="150" id="lenObj">&nbsp;</td>
			<td>품목 리스트</td>
			<td width="150" align=right><input type="button" value="닫기" class="inputbox2" onclick="self.close()">&nbsp;</td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2 class="tdAllLine">
		<iframe id="iframe2" width="100%" height="500" frameborder="0"></iframe></td>
</tr>
</form>
</table>
</BODY>
</HTML>



<%
}catch(Exception e){
	out.print(e.toString());
}
%>