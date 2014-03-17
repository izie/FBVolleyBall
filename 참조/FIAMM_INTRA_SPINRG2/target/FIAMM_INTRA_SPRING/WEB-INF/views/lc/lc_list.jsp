<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
	
	LcDAO lcDAO			= new LcDAO(db);
	PoDAO poDAO			= new PoDAO(db);
	ClientDAO cDAO		= new ClientDAO(db);
	BankDAO bDAO		= new BankDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	PassItemLnkDAO pilDAO  = new PassItemLnkDAO(db);

	//requets
	int nowPage			= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	int seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	int seq_po			= KUtil.nchkToInt(request.getParameter("seq_po"));
	int seq_pil			= KUtil.nchkToInt(request.getParameter("seq_pil"));
	String sk			= KUtil.nchk(request.getParameter("sk"));
	String st			= KUtil.nchk(request.getParameter("st"));
	String oby			= KUtil.nchk(request.getParameter("oby"));
	String inOby		= "poYear DESC,poNum DESC,poNum DESC";
	if( oby.length() > 0 ){
		inOby = oby+","+inOby;
	}
	String bankCode		= KUtil.nchk(request.getParameter("bankCode"));
	
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"));
	
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	String pKinds		= KUtil.nchk(request.getParameter("pKinds"));
 
	int totCnt			= lcDAO.getTotal(sk, 
										 st, 
										 bankCode, 
										 seq_client,
										 seq_po, 
										 seq_pil,
										 sStDate,
										 sEdDate,
										 schKinds,
										 priceKinds,
										 pKinds,
										 "");
	Vector[] arrsum		= lcDAO.getSum(sk, 
									   st, 
									   bankCode, 
									   seq_client, 
									   seq_po, 
									   seq_pil,
									   sStDate,
									   sEdDate,
									   schKinds,
									   priceKinds,
									   pKinds,
									   "");
	int pageSize		=  10;// 한페이지에 보여줄 사이즈
	int start			= (nowPage*pageSize) - pageSize;

	PagingUtil paging	= new PagingUtil(pageSize,5,totCnt,nowPage);
	String indicator	= paging.getIndi();
	Vector vecList		= lcDAO.getList(start, 
										pageSize, 
										sk, 
										st, 
										bankCode, 
										seq_client, 
										seq_po, 
										seq_pil, 
										inOby,
										sStDate,
										sEdDate,
										schKinds,
										priceKinds,
										pKinds,
										"");

	
	Vector vecBank		= bDAO.getList();	//은행 리스트
	Vector vecPK		= pkDAO.getList();	//화폐단위 리스트
 

	PassItemLnk pil = pilDAO.selectOne(seq_pil);
%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function viewPo(seq){
	var lt = (screen.availWidth-720)/2;
	var tp = (screen.availheight-700)/2;
	var pop = window.open("/main/po/view.jsp?seq_po="+seq,"viPo","width=720,height=700,scrollbars=1,top="+tp+",left="+lt);
	pop.focus();
}
function viewClient(seq){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/client/view.jsp?seq="+seq,"viClient","top="+tp+",left="+lft+",scrollbars=1,width=720,height=660");
	pop.focus();
}
function opWinLc(seq){
	var tp = (screen.availHeight-260)/2;
	var lft = (screen.availWidth-600)/2;
	var pop = window.open("/main/lc/view.jsp?seq="+seq+"&reload=1","lcMView","top="+tp+",scrollbars=1,height=260,width=600,left="+lft);
		pop.focus();
}
function orderBy(val){
	var frm = document.lcForm;
	if( val=="pono" ){
		frm.oby.value = "";
	}else if( frm.oby.value.indexOf(val+" DESC") > -1 ){
		frm.oby.value = val+" ASC";
	}else{
		frm.oby.value = val+" DESC";
	}
	frm.nowPage.value="1";
	frm.action = "lc_list.jsp";
	frm.submit();
}
function move(pge){
	var frm = document.lcForm;
	frm.nowPage.value = pge;
	frm.action = "lc_list.jsp";
	frm.submit();
}
function repage(){
	var frm = document.lcForm;
	frm.action = "lc_list.jsp";
	frm.submit();
}
function opWinLcW(){
	var tp = (screen.availHeight-260)/2;
	var lft = (screen.availWidth-600)/2;
	var pop = window.open("/main/lc/write.jsp?seq_po=<%=seq_po%>&seq_pil=<%=seq_pil%>&reload=1","lcWView","top="+tp+",scrollbars=1,height=260,width=600,left="+lft);
	pop.focus(); 
}
</SCRIPT>
</head>



<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top class="xnoscroll">

<table cellpadding="0" cellspacing="0" border="0" width="850">
<form name="lcForm" method="post">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="oby" value="<%=oby%>">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<input type="hidden" name="seq_pil" value="<%=seq_pil%>">
<tr align=center height=30>
	<td class="menu1">거래처</td>
	<td class="menu1">거래은행</td>
	<td class="menu1">개설일</td>
	<td class="menu1">금액</td>
	<td class="menu1">L/C NO</td>
	<td class="menu1">BL인수일</td>
	<td class="menu1"><A HREF="javascript:orderBy('lcLimitDate')">LC만기일</A></td>
	<td class="menu1">결제일</td>
	<td class="menu1">수입보증금</td>
</tr>

<%	for( int i=0 ; i< vecList.size() ; i++ ){	
		Lc lc = (Lc)vecList.get(i);
		Po po = poDAO.selectOne(lc.seq_po);	
		Client cl = cDAO.selectOne(po.seq_client);	
		String clas = i%2==0?"menu2_1":"menu2";			%>
<tr align=center height=25>
	<td class="<%=clas%>"><A HREF="javascript:viewClient(<%=cl.seq%>)">
		<%=KUtil.nchk(cl.bizName)%></A></td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)">
		<%=KUtil.nchk(lc.bankName)%></td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)">
		<%=KUtil.dateMode(lc.lcOpenDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)" align=right>
		<%=KUtil.nchk(lc.lcPriceKinds)%> <%=NumUtil.numToFmt(lc.lcPrice,"###,###.##","0")%>&nbsp;</td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)">
		<%=KUtil.nchk(lc.lcNum,"&nbsp;")%></td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)">
		<%=KUtil.dateMode(lc.lcLimitDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)">
		<%=KUtil.dateMode(lc.lcLimitDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)">
		<%=KUtil.dateMode(lc.lcPayDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	<td class="<%=clas%>" style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)" align=right>
		<%=lc.guarPrice > 0 ? KUtil.nchk(lc.guarPriceKinds) : ""%>
		<%=NumUtil.numToFmt(lc.guarPrice,"###,###.##","0")%>&nbsp;</td>
</tr>
<%	}	%>


<%	if( pil.isUse == 0 ){		%>
<tr align=center height="50">
	<td colspan=10>해당사항 없음.</td>
</tr>
<%	}else if( vecList.size()<1 ){	%>
<tr align=center height="50">
	<td colspan=10>LC 정보가 존재하지 않습니다.</td>
</tr>
<%	}	%>

<tr align=right height=25>
	<td class=menu1 colspan=3>합계</td>
	
	<td class=menu1>
		<%	for( int i=0 ; i<arrsum[0].size() ; i++ ){	
				PoSum psm = (PoSum)arrsum[0].get(i);	%>
			<div><%=KUtil.nchk(psm.priceKinds)%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
	
	<td class=menu1 colspan=4>합계</td>
	
	<td class=menu1>
		<%	for( int i=0 ; i<arrsum[1].size() ; i++ ){	
				PoSum psm = (PoSum)arrsum[1].get(i);	%>
			<div><%=KUtil.nchk(psm.priceKinds)%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="850">
<tr height=2 class="bgc2">
	<td colspan=2></td>
</tr>
<tr height=25>
	<td class="bmenu" width="50%">&nbsp;<%=indicator%></td>
	<td class="bmenu" width="50%" align=right>
		<%	if( seq_po > 0 ){	%>
			<input type="button" class="inputbox2" value="입력" onclick="opWinLcW()">
		<%	}	%>&nbsp;</td>
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