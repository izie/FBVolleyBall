<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_client = KUtil.nchkToInt(request.getParameter("seq_client"));
	
	ClientDAO cDAO = new ClientDAO(db);

	Client cl = cDAO.selectOne(seq_client);
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
function opWin(seq){
	var lft = (screen.availWidth-720)/2;
	var opt = window.open("/main/client/view.jsp?seq="+seq,"viEsti","width=720,height=600,left="+lft+",top=0,scrollbars=1");
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
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<tr valign=top>
	<td>
<%	if( cl.seq > 0 ){	%>
	<div class="bk2_1"><IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
	<a id="a" style="cursor:hand;" onclick="sel_item('a','<%=cl.seq%>')"><%=cl.bizName%></a></div>
<%	}else{	%>
<div>거래처 정보가 없습니다.</div>
<%	}	%>	
	</td>
</tr>
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