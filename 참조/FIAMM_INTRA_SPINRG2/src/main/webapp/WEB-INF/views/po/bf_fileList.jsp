<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

try{ 
	String saveDir = request.getRealPath("/main/po/form");
	File folder = new File(saveDir);
	File[] files = folder.listFiles();
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,itemCom ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	chg_color();
	var frm = document.bForm;
	frm.fileName.value = eval("document.bForm.fileName"+item_num).value;
	frm.target = "inv";
	frm.action = "bf_fileInsert.jsp";
	frm.submit();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function fileDel(i){
	var frm = document.bForm;
	if( confirm("삭제하시겠습니까?") ){
		frm.fileName.value = eval("document.bForm.fileName"+i).value;
		frm.target = "inv";
		frm.action = "bf_fileDel.jsp";
		frm.submit();
	}
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="400">
<form name="bForm" method="post">
<textarea name="fileName" style="display:none"></textarea>


<%	for( int i=0 ; i<files.length ; i++ ){	%>
<tr height=20>
	<td><IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
		<A href="javascript:" id="a<%=i%>" onclick="sel_item('<%=i%>')"><%=files[i].getName()%></A>
		<A HREF="javascript:fileDel('<%=i%>')">[삭제]</A>
		<textarea name="fileName<%=i%>" style="display:none"><%=files[i].getName()%></textarea></td>
</tr>
<%	}	%>

</form>
</table>
<iframe name="inv" id="inv" width=0 height=0></iframe>

</BODY>
</HTML>


<%
}catch(Exception e){
	out.print(e.toString());
}
%>