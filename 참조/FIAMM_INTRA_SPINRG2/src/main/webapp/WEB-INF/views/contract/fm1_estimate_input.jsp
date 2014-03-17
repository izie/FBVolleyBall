<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
	//request

	int seq_estimate	= KUtil.nchkToInt(request.getParameter("seq_estimate"));
	EstimateDAO emDAO = new EstimateDAO(db);
	Estimate em = emDAO.selectOne(seq_estimate);
%>



<form name="inform">
<textarea name="seq_estimate" style="display:none"><%=seq_estimate%></textarea>
<textarea name="title" style="display:none"><%=KUtil.nchk(em.title)%></textarea>
<textarea name="totPrice" style="display:none"><%=em.totPrice%></textarea>
<textarea name="priceKinds" style="display:none"><%=em.priceKinds%></textarea>
<textarea name="taxPrice" style="display:none"><%=em.taxPrice%></textarea>
<input type="hidden" name="isTax" value="<%=em.isTax%>">
</form>
<SCRIPT LANGUAGE="JavaScript">
var ofrm = parent.opener.document.contractAddForm;
var frm = document.inform;
ofrm.seq_estimate.value = frm.seq_estimate.value;
ofrm.estimate_name.value = frm.title.value;
ofrm.conTotPrice.value = frm.totPrice.value;

ofrm.conTotPrice.value = frm.totPrice.value;
if( frm.isTax.value == '1' ){	//부가세 별도
	ofrm.supPrice.value	= frm.totPrice.value;
	ofrm.taxPrice.value	= Number(frm.totPrice.value) * 0.1;
}else{	//부가세 명시 포함가
	ofrm.supPrice.value	= Number(frm.totPrice.value)-Number(frm.taxPrice.value);
	ofrm.taxPrice.value		= Number(frm.taxPrice.value);
}


ofrm.priceKinds.value = frm.priceKinds.value;
parent.opener.document.estFrm.limit.value = "<%=em.limitDate%>";
parent.opener.int2Com();
parent.opener.getNextDate();

top.self.close();
</SCRIPT>




<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>