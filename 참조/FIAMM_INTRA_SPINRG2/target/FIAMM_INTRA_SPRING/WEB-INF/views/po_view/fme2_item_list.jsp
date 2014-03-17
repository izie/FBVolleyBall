<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_estimate = KUtil.nchkToInt(request.getParameter("seq_estimate"));
	int seq_contract = KUtil.nchkToInt(request.getParameter("seq_contract"));
	
	EstimateDAO emDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);

	Estimate em = emDAO.selectOne(seq_estimate);
	Vector vecEstItem = eiDAO.getList(seq_estimate);
%>


<HTML>
<HEAD>
<title>ÇÇ¾ÏÄÚ¸®¾Æ</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">

function inputBoxChk(){
	var frm = document.estimateViewForm;
	frm.action = "frm_item_input.jsp";
	document.estimateViewForm.rowIndex.value = parent.opener.document.poForm.rowCount.value;
	return chkBoxChk(frm.seq_estItem, "°ßÀû¼­");
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0">




	<table cellpadding="0" cellspacing="1" border="0" width="100%">
	<form name="estimateViewForm" method="post" onsubmit="return inputBoxChk();">
	<input type="hidden" name="seq_estimate" value="<%=seq_estimate%>">
	<input type="hidden" name="seq_contract" value="<%=seq_contract%>">
	<input type="hidden" name="rowIndex" value="">
	<tr align=center class="bk1_1" height=28>
		<td width=20>àÔ ÷É</td>
		<td>ù¡ Ù£</td>
		<td>Ð® Ì«</td>
		<td>â¦ Õá</td>
		<td>Ó¤ Ê¤</td>
		<td>ÐÝ äþ</td>
	</tr>
<%	long reTotPrice = 0;
	for( int i=0 ; i<vecEstItem.size() ; i++ ){	
		EstItem ei = (EstItem)vecEstItem.get(i);
		Item im = iDAO.selectOne(ei.seq_item);	
		reTotPrice += ei.cnt*(long)ei.unitPrice;
%>
	<tr align=center class="bk2_1" height=28>
		<td><input type="checkbox" name="seq_estItem" value="<%=ei.seq%>"></td>
		<td><%=im.itemCom%> / <%=im.itemName%></td>
		<td><%=im.itemDim%></td>
		<td><%=KUtil.intToCom(ei.cnt)%></td>
		<td><%=KUtil.intToCom(ei.unitPrice)%></td>
		<td><%=KUtil.longToCom(ei.cnt*(long)ei.unitPrice)%></td>
	</tr>
<%	}//for					%>
	<tr class="bgc1" align=center>
		<td colspan=6>
			<input type="button" value="ÀüÃ¼¼±ÅÃ/ÇØÁ¦" onclick="chkAll(seq_estItem)">
			<input type="submit" value="¼±ÅÃÀÔ·Â"></td>
	</tr>
	</form>
	</table>





</BODY>
</HTML>


<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>