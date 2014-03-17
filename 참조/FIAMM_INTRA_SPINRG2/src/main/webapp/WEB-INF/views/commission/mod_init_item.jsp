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
	Commission_linkDAO cmlDAO = new Commission_linkDAO(db);
	int seq		= KUtil.nchkToInt(request.getParameter("seq"));
	
	Vector vecCml = cmlDAO.getList(seq);
%>
<form name='imsi'>
<%	for( int i=0 ; i<vecCml.size() ; i++ ){		
		Commission_link cml = (Commission_link)vecCml.get(i);	%>
<textarea name="seq_client"><%=cml.seq_client > 0 ? cml.seq_client+"":""%></textarea>
<textarea name="client_name"><%=KUtil.nchk(cml.client_name)%></textarea>
<textarea name="seq_po"><%=cml.seq_po > 0 ? cml.seq_po+"":""%></textarea>
<textarea name="pono"><%=KUtil.nchk(cml.pono)%></textarea>
<textarea name="seq_project"><%=cml.seq_project>0?cml.seq_project+"":""%></textarea>
<textarea name="project_name"><%=KUtil.nchk(cml.project_name)%></textarea>
<SCRIPT LANGUAGE="JavaScript">
var in_tb	= top.id_inserttb01;
if( in_tb != '[object]' ) in_tb = top.document.getElementById("id_inserttb01");
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
</SCRIPT>
<%	}	%>
</form>


<SCRIPT LANGUAGE="JavaScript">
var ofrm	= top.document.commissionForm;
var frm		= document.imsi;
var in_tb	= top.id_inserttb01;
if( in_tb != '[object]' ) in_tb = top.document.getElementById("id_inserttb01");
var len = in_tb.rows.length-1;
<%	for( int i=0 ; i<vecCml.size() ; i++ ){		
		if( vecCml.size() > 1 ){		%>
			ofrm.seq_client[<%=i%>].value	= frm.seq_client[<%=i%>].value;
			ofrm.client_name[<%=i%>].value	= frm.client_name[<%=i%>].value;
			ofrm.seq_po[<%=i%>].value		= frm.seq_po[<%=i%>].value;
			ofrm.pono[<%=i%>].value			= frm.pono[<%=i%>].value;
			ofrm.seq_project[<%=i%>].value	= frm.seq_project[<%=i%>].value;
			ofrm.project_name[<%=i%>].value	= frm.project_name[<%=i%>].value;
<%		}else{	%>
			ofrm.seq_client.value			= frm.seq_client.value;
			ofrm.client_name.value			= frm.client_name.value;
			ofrm.seq_po.value				= frm.seq_po.value;
			ofrm.pono.value					= frm.pono.value;
			ofrm.seq_project.value			= frm.seq_project.value;
			ofrm.project_name.value			= frm.project_name.value;
<%		}//if
	}	//for%>
</SCRIPT>

<%	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>