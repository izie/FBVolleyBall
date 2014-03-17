<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

	Database db = new Database();

try{ 


	//request
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	
	String gubun	= "seq_client";
	int seq			= KUtil.nchkToInt(request.getParameter("seq_client"));
	if( seq < 1 ){
		seq			= KUtil.nchkToInt(request.getParameter("seq_project"));
		gubun		= "seq_project";
	}

	EstimateDAO eDAO = new EstimateDAO(db);
	int totCnt = eDAO.getTotal(sk, st, seq, gubun);

	int pageSize =  20;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil();
	paging.setPageSize(pageSize);
	paging.setBlockSize(10);
	paging.setRowCount(totCnt);
	paging.setCurrentPage(nowPage);
	
	String indicator = paging.getIndi();

	Vector vecEstimate = eDAO.getList(start, pageSize, sk, st, seq, gubun);
	int num = pageSize*nowPage - (pageSize-1);

	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function move(pge){
	var frm = document.estimateForm;
	frm.nowPage.value = pge;
	frm.action = "list.jsp";
	frm.submit();
}
var sel_stat = "";
function sel_item( item_num,seq ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();

	var lft = (screen.availWidth-720)/2;
	var pop = window.open("view.jsp?seq="+seq,"esti","width=720,height=700,top=0,left="+lft+",scrollbars=1");
	pop.focus();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="100%">
<form name="estimateForm" method="post" onsubmit="return chkSearch();">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="<%=gubun%>" value="<%=seq%>">
<input type="hidden" name="seq" value="">
<tr height=28>
	<td class="ti1"><B>전체 견적 : <%=totCnt%> 건</B></td>
</tr>


<%	for( int i=0 ; i<vecEstimate.size() ; i++ ){	
		Estimate em = (Estimate)vecEstimate.get(i);		%>
<tr height=20>
	<td class="bk2_1">
		<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
		[<%=KUtil.cutIntDate(em.estYear,2,4,2)%><%=KUtil.formatDigit(em.estNum)%><%=em.estNumIncre>0?"-"+em.estNumIncre:""%>]
		<a id="a<%=i%>" style="cursor:hand;height;25" onclick="javascript:sel_item('a<%=i%>','<%=em.seq%>')"><%=KUtil.nchk(em.title)%></a>
		(<%=KUtil.toDateViewMode(em.wDate)%>)</td>
</tr>
<%	}//for	%>

<%	if( vecEstimate.size() < 1 ){	%>
<tr height=50>
	<td >데이타가 존재하지 않습니다.</td>
</tr>
<%	}	%>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="100%" height="30">
<tr align=center class="bgc2" height=2>
	<td></td>
</tr>
<tr align=center class="bgc1" height=25>
	<td><%=indicator%></td>
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