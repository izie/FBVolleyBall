<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
		
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));

	ClientDAO cDAO = new ClientDAO(db);

	int totCnt = cDAO.getTotal(sk, st, "매출");

	int pageSize =  10;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize,3,totCnt,nowPage);
	String indicator = paging.getIndi("","[<]","[>]","");
	Vector vecClient = cDAO.getList(start, pageSize, sk, st, "매출");

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
	parent.frames['iframe2'].location = "/blank.html";
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(nowPage){
	document.location = "fme0_client_list.jsp?nowPage="+nowPage;
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="clientForm" method="post">
<input type="hidden" name="seq_client" value="">


<%	for( int i=0 ; i<vecClient.size() ; i++ ){		
		Client cl = (Client)vecClient.get(i);	%>
<tr height=20>
	<td class="bk2_1">
		<IMG SRC="/images/icon_group.gif" WIDTH="14" HEIGHT="13" BORDER="0" ALT=""> 
		<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=cl.seq%>')"><%=cl.bizName%></a></td>
</tr>
<%	}//for	%>

<%	if( vecClient.size()<1 ){	%>
<tr height=50>
	<td>거래처가 없습니다.</td>
</tr>
<%	}	%>

<tr height=25 align=center>
	<td class="bgc1"><%=indicator%></td>
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