<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	ClientDAO clDAO = new ClientDAO(db);

	int seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	String project_name = KUtil.nchk(request.getParameter("project_name"));
	int seq_po			= KUtil.nchkToInt(request.getParameter("seq_po"));
	String pono			= KUtil.nchk(request.getParameter("pono"));
	int seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));

	Client cl = clDAO.selectOne(seq_client);	
%>
<form name='imsi'>
<textarea name="seq_client"><%=cl.seq > 0 ? cl.seq+"":""%></textarea>
<textarea name="client_name"><%=KUtil.nchk(cl.bizName)%></textarea>
<textarea name="seq_po"><%=seq_po > 0 ? seq_po+"":""%></textarea>
<textarea name="pono"><%=KUtil.nchk(pono)%></textarea>
<textarea name="seq_project"><%=seq_project>0?seq_project+"":""%></textarea>
<textarea name="project_name"><%=KUtil.nchk(project_name)%></textarea>
</form>


<SCRIPT LANGUAGE="JavaScript">
var ofrm	= top.opener.document.commissionForm;
var frm		= document.imsi;
var in_tb	= top.opener.id_inserttb01;
if( in_tb != '[object]' ) in_tb = top.opener.document.getElementById("id_inserttb01");
var oRow = in_tb.insertRow();
	oRow.align = "center";
var oCell0 = oRow.insertCell();	oCell0.width = "2%";	oCell0.className="menu2";
var oCell1 = oRow.insertCell(); oCell1.width = "15%";	oCell1.className="menu2";
var oCell2 = oRow.insertCell(); oCell2.width = "10%";	oCell2.className="menu2";
var oCell3 = oRow.insertCell(); oCell3.width = "73%";	oCell3.className="menu2";

oCell0.innerHTML = "<IMG SRC='/images/icon_close.gif' BORDER='0' style='cursor:hand' onclick='delRow1()'>";
oCell1.innerHTML = "<input type='hidden' name='seq_client' value=''>"
				 + "<input type='text' name='client_name' value='' style='width:99%' readonly class='inputbox'>";
oCell2.innerHTML = "<input type='hidden' name='seq_po' value=''>"
				 + "<input type='text' name='pono' value='' style='width:99%' readonly class='inputbox'>";
oCell3.innerHTML = "<input type='hidden' name='seq_project' value=''>"
				 + "<input type='text' name='project_name' value='' style='width:99%' readonly class='inputbox'>";

var len = in_tb.rows.length-1;
if( len > 0 ){
	ofrm.seq_client[len].value	= frm.seq_client.value;
	ofrm.client_name[len].value = frm.client_name.value;
	ofrm.seq_po[len].value		= frm.seq_po.value;
	ofrm.pono[len].value		= frm.pono.value;
	ofrm.seq_project[len].value = frm.seq_project.value;
	ofrm.project_name[len].value= frm.project_name.value;
}else{
	ofrm.seq_client.value	= frm.seq_client.value;
	ofrm.client_name.value = frm.client_name.value;
	ofrm.seq_po.value		= frm.seq_po.value;
	ofrm.pono.value		= frm.pono.value;
	ofrm.seq_project.value = frm.seq_project.value;
	ofrm.project_name.value= frm.project_name.value;
}
top.window.close();
</SCRIPT>

<%	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>