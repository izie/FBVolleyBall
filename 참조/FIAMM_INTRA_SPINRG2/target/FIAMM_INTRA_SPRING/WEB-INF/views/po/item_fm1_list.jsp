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
	
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	
	Item _im = iDAO.selectOne(seq);

	int ref		= _im.seq;
	int depth	= _im.depth+1;
	

	int totCnt = iDAO.getRefTotal(sk, st, ref, depth);

	int pageSize =  10;// 한페이지에 보여줄 사이즈
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
	parent.iframe2.location="item_fm2_list.jsp?seq="+seq;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	document.location = "item_fm1_list.jsp?nowPage="+pge+"&seq=<%=seq%>";
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
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('a<%=i%>','<%=im.seq%>')"><%=im.itemName%></a></td>
</tr>
<%	}//for	
	
	if( vecMakeCom.size() < 1 ){	%>
<tr height=50 align=center>
	<td>품명이 존재하지 않습니다.</td>
</tr>		
<%	}	%>
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
