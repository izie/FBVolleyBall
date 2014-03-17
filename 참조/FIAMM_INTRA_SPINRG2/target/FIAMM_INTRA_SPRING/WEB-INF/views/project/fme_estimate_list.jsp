<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_project = KUtil.nchkToInt(request.getParameter("seq_project"));
	int id			= KUtil.nchkToInt(request.getParameter("id"));
	
	
	EstimateDAO emDAO = new EstimateDAO(db);
	ContractDAO cDAO = new ContractDAO(db);

	String strEstNo	   = cDAO.getListEstSeq(seq_project);
	Vector vecEstimate = emDAO.getList(seq_project);
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
function opWin(seq){
	var lft = (screen.availWidth-720)/2;
	var pop = window.open("/main/estimate/view.jsp?seq="+seq+"&reload=1","viEsti","width=720,height=700,left="+lft+",top=0,scrollbars=1,resizable=1");
	pop.focus();
}
var sel_stat = "";
function sel_item( item_num,seq_estimate ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	opWin( seq_estimate );
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function popEstimateW(){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-740)/2;
	var pop = window.open("/main/estimate/write.jsp?seq_project=<%=seq_project%>&reload=1","viEsti1","width=720,height=600,left="+lft+",top=0,scrollbars=1");
	pop.focus();
}
function popContractW(seq_estimate){
	parent.popContractW('<%=seq_project%>',seq_estimate);
}
function addEstimate(){
	var lt = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-700)/2;
	var pop = window.open("/main/estimate/write.jsp?seq_project=<%=seq_project%>","estAdd","left="+lt+",top="+tp+",width=720,height=700, scrollbars=1");
	pop.focus();
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="xnoscroll">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" id="id_tb">
<tr>
	<td valign=top>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<%	for( int i=0 ; i<vecEstimate.size() ; i++ ){		
				Estimate em = (Estimate)vecEstimate.get(i);	%>
		<tr height=20>
			<td class="bk2_1">
			<A HREF="javascript:popContractW('<%=em.seq%>')">
				<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
			<%	if( strEstNo.indexOf("@"+em.seq+"@") != -1){
					out.print("<FONT COLOR='#CC0000'>");
				}
				out.print("["+emDAO.getEstNo(em)+"]");
				out.print("</FONT>");		%>
			</A>
			<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=em.seq%>')"><%=em.title%></a></td>
		</tr>
		<%	}//for	%>

		<%	if( vecEstimate.size()<1 ){	%>
		<tr height=50>
			<td>견적서가 없습니다.</td>
		</tr>
		<%	}	%>	
			</td>
		</tr>
		</table></td>
</tr>
</table>
</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
//id_tb.style.width=document.body.clientWidth;
</SCRIPT>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>