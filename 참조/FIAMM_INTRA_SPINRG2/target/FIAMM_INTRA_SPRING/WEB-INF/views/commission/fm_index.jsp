<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	ClientDAO cDAO = new ClientDAO(db);

	Vector vecClient = cDAO.getClient("매입");
%>



<html>
<head>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function addForm(){
	var frm = document.tForm;
	if( !nchk(frm.project_name,"프로젝트명") ) return;
	tForm.target = "id_DBC";
	tForm.action = "fm_formin.jsp";
	frm.submit();
}
</SCRIPT>
</head>

<body>
<table cellpadding="0" cellspacing="1" border="0" width="700" height="100%">
<form name="tForm" method="post">
<tr align=center height=25>
	<td class="ti1" width="70%">Project List</td>
	<td class="ti1" width="30%">PO List</td>
</tr>
<tr>
	<td class="tdAllLine">
		<iframe src="fm_project_list.jsp" id="fm0" name="fm0" width=100% height=100% frameborder=0></iframe></td>
	<td class="tdAllLine">
		<iframe id="fm1" name="fm1" width=100% height=100% frameborder=0></iframe></td>
</tr>
<tr height=20>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="100" align=right class="bk1_1">프로젝트명 :</td>
			<td class="bk2_1"><input type="text" name="project_name" value="" readonly class="inputbox1" size=30>
			<td rowspan=3 width=50 align=right>
				<input type="hidden" name="seq_project" value="">
				<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
		</tr>
		<tr>
			<td align=right class="bk1_1">PONO :</td>
			<td class="bk2_1">
				<input type="hidden" name="seq_po" value="">
				<input type="text" name="pono" value="" readonly size=20 class="inputbox"></td>
		</tr>
		<tr>
			<td align=right class="bk1_1">제조사 :</td>
			<td class="bk2_1">
				<select name="seq_client" class="selbox">
					<option value="">▒제조사▒</option>
			<%	for( int i=0 ; i<vecClient.size() ; i++ ){	
					Client cl = (Client)vecClient.get(i);		%>
					<option value="<%=cl.seq%>"><%=cl.bizName%></option>
			<%	}	%>
				 </select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" value="추가" onclick="addForm()" class="inputbox2"></td>
		</tr>
		</table></td>
</tr>
</form>
</table>
</body>
</html>

<iframe id="id_DBC" name="id_DBC" width=100% height=300></iframe>

<SCRIPT LANGUAGE="JavaScript">
resize(710,600);
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
	db = null;
}
%>