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
	int seq_client = KUtil.nchkToInt(request.getParameter("seq_client"));

	ContractDAO ctDAO = new ContractDAO(db);
	Vector vecList = ctDAO.getList(seq_client);

%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_contract,seq_estimate ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	parent.frames['iframe2'].location = "fme2_item_list.jsp?seq_estimate="+seq_estimate+"&seq_contract="+seq_contract;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}

</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<form name="clientForm" method="post">
<input type="hidden" name="seq_client" value="">
<%	for( int i=0 ; i<vecList.size() ; i++ ){		
		Contract cl = (Contract)vecList.get(i);	%>
<div class="bk2_1">
	<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
	<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=cl.seq%>','<%=cl.seq_estimate%>')"><%=cl.title%></a></div>
<%	}//for	%>

<%	if( vecList.size()<1 ){	%>
<div>계약서가 없습니다.</div>

<%	}	%>
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