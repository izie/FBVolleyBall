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
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));

	PoDAO poDAO = new PoDAO(db);
	ClientDAO cDAO = new ClientDAO(db);

	int totCnt = poDAO.getTotal(sk, st, seq_client, priceKinds);

	int pageSize =  15;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil();
	paging.setPageSize(pageSize);
	paging.setBlockSize(10);
	paging.setRowCount(totCnt);
	paging.setCurrentPage(nowPage);
	
	String indicator = paging.getIndi();

	Vector vecPo = poDAO.getList(start, pageSize, sk, st, seq_client, priceKinds);
	int num = pageSize*nowPage - (pageSize-1);
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function move(pge){
	var frm = document.poListForm;
	frm.nowPage.value = pge;
	frm.action = "po_list.jsp";
	frm.submit();
}
function chkSearch(){
	var frm = document.poListForm;
	frm.nowPage.value=1;
	frm.action = "po_list.jsp";
}
function goSelect(seq_po){
	var lft = (screen.availWidth-720)/2;
	var tp	= (screen.availHeight-600)/2;
	var pop = window.open("/main/po/mod.jsp?seq_po="+seq_po,"viewPo","width=720,height=600,scrollbars=1,resizable=1,left="+lft+",top="+tp);
	pop.focus();
}
function selectClient(){
	var frm = document.poListForm;
	frm.nowPage.value = 1;
	frm.action = "po_list.jsp";
	frm.submit();
}
function selectPo(seq_po){
	document.location = "index_div.jsp?seq_po="+seq_po;
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="poListForm" method="post" onsubmit="return chkSearch();">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="seq" value="">
<tr height=35>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">PO 목록</FONT></B></td>
</tr>
<tr height=28>
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="30%" class="ti1">&nbsp;▶ 전체 PO: <%=totCnt%> 건</td>
			<td align=right class="ti1">
				<select name="seq_client" onchange="selectClient()">
					<option value="">▒▒전체 (매입) 업체▒▒</option>
			<%	Vector vecClient = cDAO.getClient("매입");
				for( int i=0 ; i<vecClient.size() ; i++ ){	
					Client cl  = (Client)vecClient.get(i);	%>
					<option value="<%=cl.seq%>" <%=cl.seq==seq_client?"selected":""%>><%=cl.bizName%></option>
			<%	}//for	%>
				</select>

				<select name="sk">
					<option value="title" <%=sk.equals("title")?"selected":""%>>제목</option>
					<option value="forwarder" <%=sk.equals("forwarder")?"selected":""%>>forwarder</option>
				</select>
				<input type="text" name="st" value="<%=st%>" class="inputbox">
				<input type="submit" value="검색" class="inputbox2">&nbsp;</td>
		</tr>
		</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr align=center height=30 bgcolor="#f7f7f7">
	<td class="menu1" width="50">선택</td>
	<td class="menu1" width="80">PO Date</td>
	<td class="menu1" width="70">PO NO.</td>
	<td class="menu1">제목</td>
	<td class="menu1" width="150">거래처(매입)</td>
</tr>
<%	for( int i=0 ; i<vecPo.size() ; i++ ){	
		Po po = (Po)vecPo.get(i);		
		String clas = i%2==0?"menu2_1":"menu2";			%>
<tr align=center class="bk2_1" height=25>
	<td class="<%=clas%>"><input type="button" value="선택" class="inputbox2" onclick="selectPo('<%=po.seq%>')"></td>
	<td class="<%=clas%>"><%=KUtil.toDateViewMode(po.poDate)%></td>
	<td class="<%=clas%>" align=left>&nbsp;
		<A HREF="javascript:goSelect('<%=po.seq%>')">
		<%=poDAO.getPoNo(po)%></A></td>
	<td class="<%=clas%>"><%=KUtil.cutTitle(po.title,25)%></td>
	<td class="<%=clas%>"><%=KUtil.nchk(cDAO.selectOne(po.seq_client).bizName,"&nbsp;")%></td>
</tr>
<%		num++;
	}//for	
	
	if( vecPo.size() < 1 ){	%>
<tr align=center height=50>
	<td colspan=9>데이타가 존재하지 않습니다.</td>
</tr>		

<%	}	%>

<tr align=center class="bgc2" height=2>
	<td colspan=9></td>
</tr>
<tr align=center height=25>
	<td colspan=9 class="bmenu">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;<%=indicator%></td>
			<td align=right><input type="button" value="닫기" class="inputbox2" onclick="top.window.close();">&nbsp;</td>
		</tr>
		</table></td>
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
