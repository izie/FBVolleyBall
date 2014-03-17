<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="lctt"/>
	<jsp:param name="col" value="L"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db  = new Database();
try{ 
	 
	LcDAO lcDAO			= new LcDAO(db);
	PoDAO poDAO			= new PoDAO(db);
	ClientDAO cDAO		= new ClientDAO(db);
	BankDAO bDAO		= new BankDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);


	//requets
	int prn				= KUtil.nchkToInt(request.getParameter("prn"));
	int nowPage			= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	int seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	int seq_po			= KUtil.nchkToInt(request.getParameter("seq_po"));
	int seq_pil			= KUtil.nchkToInt(request.getParameter("seq_pil"));
	String sk			= KUtil.nchk(request.getParameter("sk"));
	String st			= KUtil.nchk(request.getParameter("st"));
	String oby			= KUtil.nchk(request.getParameter("oby"),"poYear DESC,poNum DESC,poNum DESC");
	
	String viewMode		= KUtil.nchk(request.getParameter("viewMode"), "ING");

	String bankCode		= KUtil.nchk(request.getParameter("bankCode"));
	int pageSize		= KUtil.nchkToInt(request.getParameter("pageSize"),20);

	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"),"lcOpenDate");
	if( sStDate < 1 && sEdDate < 1 ){	//기본 데이타 2년 지정
		int nowDate	= KUtil.getIntDate("yyyyMMdd");	
		sStDate		= KUtil.getNextDate( nowDate, -365*2);
		//sEdDate		= nowDate;
	}
 
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	String pKinds		= KUtil.nchk(request.getParameter("pKinds"));

	int totCnt			= lcDAO.getTotal(sk, st, bankCode, seq_client, seq_po, 
									     seq_pil, sStDate, sEdDate, schKinds, priceKinds,
										 pKinds, viewMode);

	if( prn == 1 ) pageSize = totCnt; //프린트시
	
	Vector[] arrsum		= null;
	if( priceKinds.length() > 0 ){
		arrsum = lcDAO.getSum(sk, st, bankCode, seq_client, seq_po,
							  seq_pil, sStDate, sEdDate, schKinds, priceKinds,
							  pKinds, viewMode);
	}
		
	int start			= (nowPage*pageSize) - pageSize;

	PagingUtil paging	= new PagingUtil(pageSize,10,totCnt,nowPage);
	String indicator	= paging.getIndi();
	Vector vecList		=  lcDAO.getList(start, pageSize, sk, st, bankCode,
										 seq_client, seq_po, seq_pil, oby, sStDate,
										 sEdDate, schKinds, priceKinds, pKinds, viewMode);

	
	Vector vecPK		= pkDAO.getList();	//화폐단위 리스트
%>



<HTML>
<head>
<title>fiamm</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/list_print.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function viewPo(seq){
	var lt = (screen.availWidth-720)/2;
	var tp = (screen.availheight-700)/2;
	var pop = window.open("/main/po/printPo.jsp?seq_po="+seq,"viPo","width=720,height=700,scrollbars=1,top="+tp+",left="+lt);
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
	var pop = window.open("/main/lc/view.jsp?seq="+seq+"&reload=1","lcView","top="+tp+",scrollbars=1,height=260,width=600,left="+lft);
		pop.focus();
}
function orderBy(val){
	var frm = document.lcForm;
	if( val=="pono" ){
		if( frm.oby.value.indexOf("poYear DESC") > -1 ){
			frm.oby.value = "poYear,poNum,poNum";
		}else{
			frm.oby.value = "poYear DESC,poNum DESC,poNum DESC";
		}
	}else if( val=='lcLimitDate' ){
		if( frm.oby.value.indexOf("lcLimitDate DESC") > -1 ){
			frm.oby.value = "lcLimitDate";
		}else{
			frm.oby.value = "lcLimitDate DESC";
		}
	}else if( val=='lcOpenDate' ){
		if( frm.oby.value.indexOf("lcOpenDate DESC") > -1 ){
			frm.oby.value = "lcOpenDate";
		}else{
			frm.oby.value = "lcOpenDate DESC";
		}
	}
	frm.nowPage.value="1";
	frm.action = "list.jsp";
	frm.submit();
}
function move(pge){
	var frm = document.lcForm;
	frm.nowPage.value = pge;
	frm.action = "list.jsp";
	frm.submit();
}
function opWinLcW(){
	var tp = (screen.availHeight-600)/2;
	var lft = (screen.availWidth-870)/2;
	var pop = window.open("/main/lc/po_list.jsp?reload=2","poView","top="+tp+",scrollbars=1,height=600,width=870,left="+lft);
	pop.focus(); 
}
function repage(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.submit();
}
function chPageSize(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.submit();
}
function search(){
	var frm = document.forms[0];
	frm.nowPage.value = 1;
	frm.action = "list.jsp";
	frm.submit();
}
function popPrint(){
	var frm = document.forms[0];
	var w = screen.availWidth;
	var h = screen.availHeight;
	var pop = window.open("","listprint","width=100,height=100,top=0,left=0");
	frm.nowPage.value = 1;
	frm.target = "listprint";
	frm.action = "list.jsp?prn=1";
	frm.submit();
	pop.focus();
	frm.target = "_self";
}
</SCRIPT>
</head>
<BODY <%=prn != 1 ?"class='body1'":""%>>




<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="lcForm" method="post" onsubmit="return search();">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="oby" value="<%=oby%>">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<tr>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">L/C 목록</FONT></B></td>
</tr>
<tr height=28>
	<td class="ti1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;▶ 전체 : <%=totCnt%> 건
				<% if(prn != 1) { %><input type="button" value="프린트" onclick="popPrint();" class="Btn_prn"><%} %></td>
			<% if(prn != 1) { %>
			<td align=right>
				<select name="seq_client" class="selbox">
					<option value="">▒거래처별▒</option>
			<%	Vector vecClient = cDAO.getClient("매입");
				for( int i=0 ; i<vecClient.size() ; i++ ){	
					Client cl  = (Client)vecClient.get(i);	%>
					<option value="<%=cl.seq%>" <%=cl.seq==seq_client?"selected":""%>><%=cl.bizName%></option>
			<%	}//for	%>
				</select>
			<%	String	ponoSerarchText  = "CONCAT(";
						ponoSerarchText += "p.poYear*if(p.poNum<100,1000,1)+if(p.poNum<100,p.poNum,0)";
						ponoSerarchText += ",if(p.poNum>99,p.poNum,'')";
						ponoSerarchText += ",if(p.poCnt>0,'(','')";
						ponoSerarchText += ",if(p.poCnt>0,p.poCnt,'')";
						ponoSerarchText += ",if(p.poCnt>0,')','')";
						ponoSerarchText += ",if(p.poNum>99,p.poNum,'')";
						ponoSerarchText += ",'-'";
						ponoSerarchText += ",poNumIncre	)";%>
				<select name="sk" class="selbox">
					<option value="<%=ponoSerarchText%>" <%=sk.equals(ponoSerarchText)?"selected":""%>>PO No.</option>
					<option value="l.bankName" <%=sk.equals("l.bankName")?"selected":""%>>은행명</option>
					<option value="l.bankCode" <%=sk.equals("l.bankCode")?"selected":""%>>은행코드</option>
				</select>
				<input type="text" name="st" value="<%=st%>" size="12" class="inputbox">&nbsp;</td>
			<td rowspan=2 align=center><input type="submit" value="검색" class="inputbox2" style="height:40">&nbsp;</td>
		</tr>
		<tr>
			<td>
				<select name="pageSize" class="selbox" onchange="chPageSize()">
					<option value="5" <%=pageSize==5?"selected":""%>>5개씩보기</option>
					<option value="10" <%=pageSize==10?"selected":""%>>10개씩보기</option>
					<option value="15" <%=pageSize==15?"selected":""%>>15개씩보기</option>
					<option value="20" <%=pageSize==20?"selected":""%>>20개씩보기</option>
					<option value="30" <%=pageSize==30?"selected":""%>>30개씩보기</option>
					<option value="50" <%=pageSize==50?"selected":""%>>50개씩보기</option>
					<option value="100" <%=pageSize==100?"selected":""%>>100개씩보기</option>
					<option value="<%=totCnt%>" <%=pageSize==totCnt?"selected":""%>>전체보기</option>
				</select></td>
			<td align=right>
				
				<select name="viewMode" class="selbox" onchange="search()">
					<option value="ING" <%=viewMode.equals("ING") ? "selected" : ""%>>LC진행중</option>
					<option value="CPT" <%=viewMode.equals("CPT") ? "selected" : ""%>>LC완료</option>
					<option value="ALL" <%=viewMode.equals("ALL") ? "selected" : ""%>>전체자료</option>
				</select>

				<FONT class="schDuring">&nbsp;
				<select name="priceKinds" class="selbox">
					<option value="">▒통화단위▒</option>
					<option value="ALL" <%=priceKinds.equals("ALL")?"selected":""%>>전체통화</option>
			<%	Vector vecPrice = pkDAO.getList();
				for( int i=0 ; i<vecPrice.size() ; i++ ){	
					String _priceKinds  = (String)vecPrice.get(i);	%>
					<option value="<%=_priceKinds%>" <%=_priceKinds.equals(priceKinds)?"selected":""%>><%=_priceKinds%></option>
			<%	}//for	%>
				</select>
				<select name="pKinds" class="selbox">
					<option value="lcPriceKinds" <%=pKinds.equals("lcPriceKinds")?"selected":""%>>LC금액</option>
					<option value="guarPriceKinds" <%=pKinds.equals("guarPriceKinds")?"selected":""%>>수입보증금</option>
				</select>&nbsp;</FONT>
				&nbsp;
				
				<FONT class="schDuring">기간검색:
				<input type="text" name="sStDate" value="<%=sStDate>0?sStDate+"":""%>" class="inputbox" size=8 maxlength=8> 
				~ 
				<input type="text" name="sEdDate" value="<%=sEdDate>0?sEdDate+"":""%>" class="inputbox" size=8 maxlength=8>
				<select name="schKinds" class="selbox">
					<option value="lcOpenDate" <%=schKinds.equals("lcOpenDate")?"selected":""%>>개설일</option>
					<option value="blRecDate" <%=schKinds.equals("blRecDate")?"selected":""%>>BL 인수일</option>
					<option value="lcLimitDate" <%=schKinds.equals("lcLimitDate")?"selected":""%>>BL 만기일</option>
					<option value="lcPayDate" <%=schKinds.equals("lcPayDate")?"selected":""%>>결제일</option>
				</select></FONT></td>
				<% } %>
		</tr>
		</table></td>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="100%" class="line-table2">
<tr align=center height=30>
	<th width="80"><A HREF="javascript:orderBy('pono')">PO NO</A></th>
	
	<th width="80">거래은행</th>

	<th>L/C NO</th>

	<th width="70"><A HREF="javascript:orderBy('lcOpenDate')">개설일</A></th>
	
	<th width="110">금액</th>

	<th width="130">거래처</th>
		
	<th width="70"><A HREF="javascript:orderBy('lcLimithate')">BL만기일</A></th>
	
	<th width="100">수입보증금</th>
</tr>

<%	for( int i=0 ; i< vecList.size() ; i++ ){	
		Lc lc = (Lc)vecList.get(i);
		Po po = poDAO.selectOne(lc.seq_po);	
		Client cl = cDAO.selectOne(po.seq_client);	
		String clas = i%2==0 ? "databg_line" : "";		%>
<tr align=center class="<%=clas%>">
	<td align=left><A HREF="javascript:viewPo(<%=po.seq%>)"><%=poDAO.getPoNo(po)%></A></td>
	
	<td style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)"><%=KUtil.nchk(lc.bankName)%></td>

	<td align=left style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)"><%=KUtil.nchk(lc.lcNum,"&nbsp;")%></td>
	
	<td style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)"><%=KUtil.dateMode(lc.lcOpenDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	
	<td style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)" align=right><%=KUtil.nchk(lc.lcPriceKinds)%> <%=NumUtil.numToFmt(lc.lcPrice,"###,###.##","0")%>&nbsp;</td>

	<td align=left><A HREF="javascript:viewClient(<%=cl.seq%>)"><%=KUtil.nchk(cl.bizName)%></A></td>
	
	<td style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)"><%=KUtil.dateMode(lc.lcLimitDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	
	<td style="cursor:hand" onclick="opWinLc(<%=lc.seq%>)" align=right>
		<%=lc.guarPrice > 0 ? KUtil.nchk(lc.guarPriceKinds) : ""%>
		<%=NumUtil.numToFmt(lc.guarPrice,"###,###.##","0")%>&nbsp;</td>
</tr>
<%	}	%>

<%	if( arrsum != null ){		%>
<tr align=right height=25>
	<td class=menu1 colspan=4>합계</td>
	
	<td class=menu1>
		<%	for( int i=0 ; i<arrsum[0].size() ; i++ ){	
				PoSum psm = (PoSum)arrsum[0].get(i);	%>
			<div><%=KUtil.nchk(psm.priceKinds)%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
	
	<td class=menu1 colspan=2>합계</td>
	
	<td class=menu1>
		<%	for( int i=0 ; i<arrsum[1].size() ; i++ ){	
				PoSum psm = (PoSum)arrsum[1].get(i);	%>
			<div><%=KUtil.nchk(psm.priceKinds)%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
</tr>
<%	}	%>


</table>
<% if(prn != 1) { %>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr height=2 class="bgc2">
	<td colspan=2></td>
</tr>
<tr height=25>
	<td width="50%" class="bmenu">&nbsp;<%=indicator%></td>
	<td width="50%" class="bmenu" align=right>
		<input type="button" class="inputbox2" value="입력" onclick="opWinLcW()">&nbsp;</td>
</tr>

</table>
<% } %>
</form>
</BODY>
</HTML>



<jsp:include page="/inc/inc_print.jsp" flush="true"/>


<%
	if( prn == 1 ) 	KUtil.scriptOut(out, "list_print_preview()");
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>