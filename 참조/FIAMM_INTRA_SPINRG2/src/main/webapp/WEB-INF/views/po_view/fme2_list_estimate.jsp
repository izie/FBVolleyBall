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
	
	EstimateDAO emDAO = new EstimateDAO(db);

	Estimate em = emDAO.selectOne(seq_estimate);
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
function opWin(seq){
	var lft = (screen.availWidth-720)/2;
	var opt = window.open("/main/estimate/view.jsp?seq="+seq,"viEsti","width=720,height=600,left="+lft+",top=0,scrollbars=1");
}
var sel_stat = "";
function sel_item( item_num,seq_estimate ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	opWin(seq_estimate);
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="0" border="0" width="100%">

<%	if( em.seq > 0 ){	%>
<tr height=20>
	<td class="bk2_1">
		<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
		[<%=KUtil.cutIntDate(em.estYear,2,4,2)%><%=KUtil.formatDigit(em.estNum)%><%=em.estNumIncre>0?"-"+em.estNumIncre:""%>]
		<a id="a" style="cursor:hand;" onclick="sel_item('a','<%=em.seq%>')"><%=em.title%></a></td>
</tr>
<%	}else{	%>
<tr height=50>
	<td>견적서가 없습니다.</td>
</tr>
<%	}	%>	
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