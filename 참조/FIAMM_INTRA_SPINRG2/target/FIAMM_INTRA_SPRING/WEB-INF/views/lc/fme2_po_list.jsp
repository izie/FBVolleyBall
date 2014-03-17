<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	LinkDAO lkDAO = new LinkDAO(db);
	PoDAO poDAO = new PoDAO(db);
	
	Link i_lk = new Link();
	i_lk.seq_contract	= KUtil.nchkToInt(request.getParameter("seq_contract"));
	
	Vector vecLink = lkDAO.getList(i_lk);
	
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
var sel_stat = "";
function sel_item( item_num,seq_po ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	var lft = (screen.availWidth-720)/2
	var pop = window.open("view.jsp?seq_po="+seq_po,"passView","top=0,scrollbars=1,height=200,width=720,left="+lft);
	pop.focus();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="f2ListForm" method="post">
<input type="hidden" name="seq_client" value="">

<%	for( int i=0 ; i<vecLink.size() ; i++ ){		
		Link lk = (Link)vecLink.get(i);
		Po po = poDAO.selectOne(lk.seq_po);
		if( po.seq > 0 ){		%>
<tr height=20>
	<td class="bk2_1">
		<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
		[<%=KUtil.cutIntDate(po.poYear,2,4,2)%><%=KUtil.formatDigit(po.poNum)%><%=po.poNumIncre>0?"-"+po.poNumIncre:""%>]
		<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=po.seq%>')"><%=po.title%></a></td>
</tr>
<%		}
	}//for	%>

<%	if( vecLink.size()<1 ){	%>
<tr height=50>
	<td>PO가 없습니다.</td>
</tr>
<%	}	%>
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