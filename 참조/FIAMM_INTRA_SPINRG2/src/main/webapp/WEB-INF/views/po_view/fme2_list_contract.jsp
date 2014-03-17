<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
	//requets
	Link lnk = new Link();
	lnk.seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));

	LinkDAO lkDAO = new LinkDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/tree/menu.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_contract ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	viewContract(seq_contract);
}
function viewContract(seq){
	var lft = (screen.availWidth-720)/2
	var pop = window.open("/main/contract/view.jsp?seq="+seq,"contractView","top=0,width=720,height=600,scrollbars=1,left="+lft);
	pop.focus();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}	
</SCRIPT>
</head>


<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<form name="fme2Form" method="post">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<tr valign=top>
	<td>
<%	Vector vecLink = lkDAO.getList(lnk);		
	for( int i=0 ; i<vecLink.size() ; i++ ){
		Link lk = (Link)vecLink.get(i);			
		Contract ct = ctDAO.selectOne(lk.seq_contract);
%>
<DIV style="width:100%" class="bk2_1">
	<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
	<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=ct.seq%>')"><%=ct.title%></a></DIV>
<%	}//for Link		%>
	</td>
</tr>
</table>
</form>
</BODY>
</HTML>



<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>