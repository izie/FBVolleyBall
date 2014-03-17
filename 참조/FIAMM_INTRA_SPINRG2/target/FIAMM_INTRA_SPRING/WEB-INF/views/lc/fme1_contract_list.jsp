<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
	ContractDAO ctDAO = new ContractDAO(db);

	
	//requets
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client = KUtil.nchkToInt(request.getParameter("seq_client"));

	int totCnt = ctDAO.getTotal(sk, st, seq_client);

	int pageSize =  10;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize,3,totCnt,nowPage);
	String indicator = paging.getIndi("[<<]","[<]","[>]","[>>]");
	Vector vecList = ctDAO.getList(start, pageSize, sk, st, seq_client);

%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_contract ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	parent.frames['iframe2'].location = "fme2_po_list.jsp?seq_contract="+seq_contract;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	document.location = "fme1_contract_list.jsp?nowPage="+pge+"&seq_client=<%=seq_client%>";
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="clientForm" method="post">
<input type="hidden" name="seq_client" value="">
<%	for( int i=0 ; i<vecList.size() ; i++ ){		
		Contract cl = (Contract)vecList.get(i);	%>
<tr height=20>
	<td class="bk2_1">
	<IMG SRC="/images/folderopen.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
	<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('a<%=i%>','<%=cl.seq%>')"><%=cl.title%></a></td>
</tr>
<%	}//for	%>

<%	if( vecList.size()<1 ){	%>
<tr height=50>
	<td>계약서가 없습니다.</td>
</tr>
<%	}	%>


<tr height=20>
	<td align=center class="bgc1"><%=indicator%></td>
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