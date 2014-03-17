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
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));

	ClientDAO cDAO = new ClientDAO(db);

	int totCnt = cDAO.getTotal(sk, st, "매출");

	int pageSize =  15;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize,5,totCnt,nowPage);
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
	sel_stat = "a"+item_num;
	chg_color();
	parent.frames['fme1'].location = "fm1_project_list.jsp?seq_client="+seq_client;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(nowPage){
	document.location = "fm0_client_list.jsp?nowPage="+nowPage;
}
function inClient(){
	var frm = document.bizForm;
	var tp = (screen.availHeight-690)/2;
	var lf = (screen.availWidth-700)/2;
	var pop = window.open("/main/client/write.jsp","wForm","width=700,height=690,scrollbars=0,top=0,left="+lf);
	pop.focus();
}
function search(){
	var frm = document.clientForm;

	frm.action = "fm0_client_list.jsp?nowPage=1";
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top class="xnoscroll">
<table cellpadding="0" cellspacing="0" border="0" width="200" height="100%">
<form name="clientForm" method="post">


<%	for( int i=0 ; i<vecClient.size() ; i++ ){		
		Client cl = (Client)vecClient.get(i);	%>
		<tr height="20">
			<td class="bk2_1">
			<IMG SRC="/images/icon_group.gif" WIDTH="14" HEIGHT="13" BORDER="0" ALT=""> 
			<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('<%=i%>','<%=cl.seq%>')"><%=cl.bizName%></a>
			<textarea name="client_name<%=i%>" style="display:none"><%=KUtil.nchk(cl.bizName)%></textarea></td>
		</tr>
<%		if( cl.seq == seq_client )
			KUtil.scriptOut(out,"sel_item('"+i+"','"+cl.seq+"');");
	}//for	%>

<%	if( vecClient.size()<1 ){	%>
		<tr height="50">
			<td>거래처가 없습니다.</td>
		</tr>

<%	}	%>
		<tr>
			<td></td>
		</tr>
		<tr height=20 align=center>
			<td class="bgc1"><%=indicator%></td>
		</tr>
		<tr height=20 align=center>
			<INPUT TYPE="hidden" name="sk" value="bizName">
			<td class="bgc1">
				<input type="text" name="st" value="<%=st%>" class="inputbox" size="10">
				<input type="submit" value="거래처검색" class="inputbox2"></td>
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