<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
		
	ClientDAO cDAO = new ClientDAO(db);
	Vector vecClient = cDAO.getClient();

%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_client ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	parent.frames['iframe1'].location = "fme1_contract_list.jsp?seq_client="+seq_client;
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
<%	for( int i=0 ; i<vecClient.size() ; i++ ){		
		Client cl = (Client)vecClient.get(i);	%>
<div class="bk2_1"><IMG SRC="/images/icon_group.gif" WIDTH="14" HEIGHT="13" BORDER="0" ALT=""> 
	<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=cl.seq%>')"><%=cl.bizName%></a></div>
<%	}//for	%>

<%	if( vecClient.size()<1 ){	%>
<div>거래처가 없습니다.</div>

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