<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{
	ItemDAO iDAO = new ItemDAO(db);
	
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int ref = 0;
	int depth = 0;


	int totCnt = iDAO.getRefTotal(sk, st, ref, depth);

	int pageSize =  9;// ���������� ������ ������
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 3, totCnt, nowPage);
	String indicator = paging.getIndi("","[<]","[>]","");
	Vector vecMakeCom = iDAO.getRefList(start, pageSize, sk, st, ref, depth);
%>

<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num, seq ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
	parent.iframe1.location="item_fm1_list.jsp?seq="+seq;
	parent.iframe2.location="/blank.html";
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	document.location = "item_fm0_list.jsp?nowPage="+pge;
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 class="xnoscroll">
<table cellpadding="0" cellspacing="0" border="0" width="300">
<%	for( int i=0 ; i<vecMakeCom.size() ; i++ ){		
		Item im = (Item)vecMakeCom.get(i);	%>
<tr height=20>
	<td class="bk2_1">
		<IMG SRC="/images/icon_box1.gif" BORDER="0" ALT="" align=absmiddle>
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('a<%=i%>','<%=im.seq%>')"><%=im.itemCom%></a></td>
</tr>
<%	}//for	%>
<tr height=20 align=center>
	<td class="bgc1"><%=indicator%></td>
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
