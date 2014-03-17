<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	int seq_contract	= KUtil.nchkToInt(request.getParameter("seq_contract"));

	ProjectDAO pDAO		= new ProjectDAO(db);
	ContractDAO cDAO	= new ContractDAO(db);
	EstimateDAO emDAO	= new EstimateDAO(db);
	EstItemDAO eiDAO	= new EstItemDAO(db);
	ItemDAO iDAO		= new ItemDAO(db);	

	Contract ct = cDAO.selectOne(seq_contract);
%>


<HTML>
<HEAD>
<title>ÇÇ¾ÏÄÚ¸®¾Æ</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">

function inputBoxChk(){
	var frm = document.estimateViewForm;
	if( !chkBoxChk(frm.seq_estItem, "Ç°¸ñ") ) return false;
	frm.rdx.value = top.opener.in_table01.rows.length;
	frm.submit();
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="xnoscroll">

<table cellpadding="0" cellspacing="1" border="0" width="100%" id="id_mtb">

<form name="estimateViewForm" method="post" onsubmit="return false;" action="inpro_frm_item_input.jsp">
<input type="hidden" name="seq_project" value="<%=seq_project%>">
<input type="hidden" name="seq_contract" value="<%=seq_contract%>">
<input type="hidden" name="rdx" value="">
		<tr align=center class="bk1_1" height=28>
			<td width=20>àÔ ÷É</td>
			<td>ù¡ Ù£</td>
			<td>Ð® Ì«</td>
			<td>â¦ Õá</td>
			<td>Ó¤ Ê¤</td>
			<td>ÐÝ äþ</td>
		</tr>
<%	Estimate em = emDAO.selectOne(ct.seq_estimate);
	Vector vecEstItem = eiDAO.getList(ct.seq_estimate);		%>
	<%	for( int i=0 ; i<vecEstItem.size() ; i++ ){	
			EstItem ei = (EstItem)vecEstItem.get(i);		%>
		<tr align=center class="bk2_1" height=28>
			<td><input type="checkbox" name="seq_estItem" value="<%=ei.seq%>"></td>
			<td><%=ei.itemName%></td>
			<td><%=KUtil.nchk(ei.itemDim)%></td>
			<td><%=KUtil.intToCom(ei.cnt)%></td>
			<td><%=NumUtil.numToFmt(ei.unitPrice,"###,###.##","0")%></td>
			<td><%=NumUtil.numToFmt(ei.totPrice,"###,###.##","0")%></td>
		</tr>
	<%	
		}//for i			
	if( ct.seq<1 ){	%>
		<tr height=50 align=center>
			<td class="bgc1">°è¾à¼­°¡ Á¸ÀçÇÏÁö ¾Ê½À´Ï´Ù.</td>
		</tr>
<%	}else{	%>
		<tr class="bgc1" align=center>
			<td colspan=6>
				<input type="button" value="ÀüÃ¼¼±ÅÃ/ÇØÁ¦" onclick="chkAll(seq_estItem)" class="inputbox2">
				<input type="button" value="¼±ÅÃÀÔ·Â" class="inputbox2" onclick="inputBoxChk()"></td>
		</tr>
<%	}//if	%>
		


</form>

</table>

</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
id_mtb.style.width = document.body.clientWidth;
</SCRIPT>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>