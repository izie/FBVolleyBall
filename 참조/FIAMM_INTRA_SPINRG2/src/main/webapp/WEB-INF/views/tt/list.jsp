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
	
	TtDAO ttDAO			= new TtDAO(db);
	PoDAO poDAO			= new PoDAO(db);
	ClientDAO cDAO		= new ClientDAO(db);
	BankDAO bDAO		= new BankDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);


	//requets
	int prn			= KUtil.nchkToInt(request.getParameter("prn"));
	int nowPage			= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	int seq_po			= KUtil.nchkToInt(request.getParameter("seq_po"));
	int seq_pil			= KUtil.nchkToInt(request.getParameter("seq_pil"));
	int seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));

	String sk			= KUtil.nchk(request.getParameter("sk"));
	String st			= KUtil.nchk(request.getParameter("st"));
	String oby			= KUtil.nchk(request.getParameter("oby"),"poYear DESC,poNum DESC,poNum DESC");
	
	int pageSize	= KUtil.nchkToInt(request.getParameter("pageSize"),15);
	
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"),"invoDate");
	if( sStDate < 1 && sEdDate < 1 ){	//기본 데이타 2년 지정
		int nowDate	= KUtil.getIntDate("yyyyMMdd");	
		sStDate		= KUtil.getNextDate( nowDate, -365*2);
		//sEdDate		= nowDate;
	}
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	
	String viewMode		= KUtil.nchk(request.getParameter("viewMode"), "ING");

	int totCnt			= ttDAO.getTotal(sk, 
										 st,
										 seq_client, 
										 seq_po, 
										 seq_pil,
										 sStDate, 
										 sEdDate, 
										 schKinds, 
										 priceKinds, 
										 viewMode);

	if( prn == 1 ) pageSize = totCnt; //프린트시
	Vector vecsum		= null;
	if( priceKinds.length() > 0 ){
		vecsum = ttDAO.getSum(	sk, 
								st, 
								seq_client, 
								seq_po, 
								seq_pil,
							  	sStDate, 
							  	sEdDate, 
							  	schKinds, 
							  	priceKinds, 
							  	viewMode);
	} 
	int start			= (nowPage*pageSize) - pageSize;

	PagingUtil paging	= new PagingUtil(pageSize,10,totCnt,nowPage);
	String indicator	= paging.getIndi();
	Vector vecList		= ttDAO.getList(start, 
										pageSize, 
										sk, 
										st, 
										seq_client, 
										seq_po, 
										seq_pil, 
										oby, 
										sStDate, 
										sEdDate,
										schKinds, 
										priceKinds, 
										viewMode);

	
	Vector vecBank		= bDAO.getList();	//은행 리스트
	Vector vecPK		= pkDAO.getList();	//화폐단위 리스트
%>



<HTML>
<head>
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
function opWinTt(seq){
	var tp = (screen.availHeight-260)/2;
	var lft = (screen.availWidth-600)/2;
	var pop = window.open("/main/tt/view.jsp?seq="+seq+"&reload=1","lcView","top="+tp+",scrollbars=1,height=260,width=600,left="+lft);
		pop.focus();
}
function orderBy(val){
	var frm = document.lcForm;
	if( val == "pono" ){
		if( frm.oby.value.indexOf("poYear DESC") > -1 ){
			frm.oby.value = "poYear,poNum,poNum";
		}else{
			frm.oby.value = "poYear DESC,poNum DESC,poNum DESC";
		}
	}else if( val=="limitDate" ){
		if( frm.oby.value.indexOf("limitDate DESC") > -1 ){
			frm.oby.value = "limitDate";
		}else{
			frm.oby.value = "limitDate DESC";
		}
	}else if( val=="payDate" ){
		if( frm.oby.value.indexOf("payDate DESC") > -1 ){
			frm.oby.value = "payDate";
		}else{
			frm.oby.value = "payDate DESC";
		}
	}else if( val=="invoDate" ){
		if( frm.oby.value.indexOf("invoDate DESC") > -1 ){
			frm.oby.value = "invoDate";
		}else{
			frm.oby.value = "invoDate DESC";
		}
	}
	frm.action = "list.jsp";
	frm.submit();
}
function move(pge){
	var frm = document.lcForm;
	frm.nowPage.value = pge;
	frm.action = "list.jsp";
	frm.submit();
}
function opWinTtW(){
	var tp = (screen.availHeight-600)/2;
	var lft = (screen.availWidth-870)/2;
	var pop = window.open("/main/tt/po_list.jsp?reload=2","poView","top="+tp+",scrollbars=1,height=600,width=870,left="+lft);
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
	frm.nowPage.value=1;
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
		<B><FONT SIZE="4">T/T 목록</FONT></B></td>
</tr>
<tr>
	<td class="ti1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td WIDTH="150">&nbsp; ▶ 전체 : <%=totCnt%> 건</td>
			<td align=right>
				<select name="seq_client" class="selbox">
					<option value="">▒거래처별▒</option>
			<%	Vector vecClient = cDAO.getClient("매입");
				for( int i=0 ; i<vecClient.size() ; i++ ){	
					Client cl  = (Client)vecClient.get(i);	%>
					<option value="<%=cl.seq%>" <%=cl.seq==seq_client?"selected":""%>><%=cl.bizName%></option>
			<%	}//for	%>
				</select>
				
				<select name="priceKinds" class="selbox">
					<option value="">▒통화단위▒</option>
					<option value="ALL" <%=priceKinds.equals("ALL")?"selected":""%>>전체통화</option>
			<%	Vector vecPrice = pkDAO.getList();
				for( int i=0 ; i<vecPrice.size() ; i++ ){	
					String _priceKinds  = (String)vecPrice.get(i);	%>
					<option value="<%=_priceKinds%>" <%=_priceKinds.equals(priceKinds)?"selected":""%>><%=_priceKinds%></option>
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
					<option value="t.bankName" <%=sk.equals("t.bankName")?"selected":""%>>은행명</option>
				</select>
				<input type="text" name="st" value="<%=st%>" size="12" class="inputbox">&nbsp;</td>
			<td align=center rowspan=2 width="50"><input type="submit" value="검색" class="inputbox2" style="height:38"></td>
		</tr>
		<tr>
			<td><select name="pageSize" class="selbox" onchange="chPageSize()">
					<option value="5" <%=pageSize==5?"selected":""%>>5개씩보기</option>
					<option value="10" <%=pageSize==10?"selected":""%>>10개씩보기</option>
					<option value="15" <%=pageSize==15?"selected":""%>>15개씩보기</option>
					<option value="20" <%=pageSize==20?"selected":""%>>20개씩보기</option>
				</select>
				<input type="button" value="프린트" onclick="popPrint();" class="Btn_prn"></td>
			<td align=right>
				
				<select name="viewMode" class="selbox" onchange="search()">
					<option value="ING" <%=viewMode.equals("ING") ? "selected" : ""%>>TT진행중</option>
					<option value="CPT" <%=viewMode.equals("CPT") ? "selected" : ""%>>TT완료</option>
					<option value="ALL" <%=viewMode.equals("ALL") ? "selected" : ""%>>전체자료</option>
				</select>

				<FONT class="schDuring">기간검색:
				<input type="text" name="sStDate" value="<%=sStDate>0?sStDate+"":""%>" class="inputbox" size=8 maxlength=8> 
				~ 
				<input type="text" name="sEdDate" value="<%=sEdDate>0?sEdDate+"":""%>" class="inputbox" size=8 maxlength=8>
				<select name="schKinds" class="selbox">
					<option value="invoDate" <%=schKinds.equals("invoDate")?"selected":""%>>Invoice Date</option>
					<option value="limitDate" <%=schKinds.equals("limitDate")?"selected":""%>>TT 만기일</option>
					<option value="payDate" <%=schKinds.equals("payDate")?"selected":""%>>결제일</option>
				</select></FONT>&nbsp;</td>
		</tr>
		</table></td>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="100%" class="line-table2" style="layout:fixed">
<tr align=center height=30>
	<th width="80"><A HREF="javascript:orderBy('pono')">PO NO</A></th>
	
	<th>거래처</th>
	
	<th width="80">Invoice No</th>
	
	<th width="70"><A HREF="javascript:orderBy('invoDate')">Invoice Date</A></th>
	
	<th width="110">금액</th>
	
	<th width="70"><A HREF="javascript:orderBy('limitDate')">T/T만기일</A></th>
	
	<th width="70"><A HREF="javascript:orderBy('payDate')">결제일</A></th>

	<th width="70">은행명</th>

	<th width="90">미결제금액</th>
</tr>

<%	for( int i=0 ; i< vecList.size() ; i++ ){	
		Tt tt = (Tt)vecList.get(i);
		Po po = poDAO.selectOne(tt.seq_po);	
		Client cl = cDAO.selectOne(po.seq_client);	
		String clas = i%2==0 ? "databg_line" : "";				%>
<tr align=center class="<%=clas%>">
	<td align=left><A HREF="javascript:viewPo(<%=po.seq%>)"><%=poDAO.getPoNo(po)%></A></td>
	
	<td align=left><A HREF="javascript:viewClient(<%=cl.seq%>)"><%=KUtil.nchk(cl.bizName)%></A></td>
	
	<td align=left style="cursor:hand" onclick="opWinTt(<%=tt.seq%>)"><%=KUtil.nchk(tt.invoNum,"&nbsp;")%></td>
	
	<td style="cursor:hand" onclick="opWinTt(<%=tt.seq%>)"><%=KUtil.dateMode(tt.invoDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	
	<td style="cursor:hand" onclick="opWinTt(<%=tt.seq%>)" align=right>
		<%=tt.price != tt.p_price && tt.p_price != 0?"<font color='red'>":""%>
		<%=KUtil.nchk(tt.priceKinds)%> <%=NumUtil.numToFmt(tt.price,"###,###.##","0")%>
		<%=tt.price != tt.p_price && tt.p_price != 0?"</font>":""%>&nbsp;</td>
	
	<td style="cursor:hand" onclick="opWinTt(<%=tt.seq%>)"><%=KUtil.dateMode(tt.limitDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	
	<td style="cursor:hand" onclick="opWinTt(<%=tt.seq%>)"><%=KUtil.dateMode(tt.payDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	
	<td style="cursor:hand" onclick="opWinTt(<%=tt.seq%>)"><%=KUtil.nchk(tt.bankName,"&nbsp;")%></td>

	<td style="cursor:hand" onclick="opWinTt(<%=tt.seq%>)" align=right>
		<%	if( tt.payDate < 1 && tt.limitDate > 0 && tt.limitDate < KUtil.getIntDate("yyyyMMdd") ){
				out.print( NumUtil.numToFmt(tt.price-tt.p_price,"###,###.##","0") );
			}
		%>&nbsp;</td>
</tr>
<%	}	%>



<%	if( vecsum != null ){	%>
<tr align=right>
	<td class="menu1" colspan=4>합계</td>
	<td class="menu1">
		<%	for( int i=0 ; i<vecsum.size() ; i++ ){	
				PoSum psm = (PoSum)vecsum.get(i);	%>
			<div><%=KUtil.nchk(psm.priceKinds)%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
	<td class="menu1" colspan=2>&nbsp;</td>
</tr>
<%	}						%>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr height=2 class="bgc2">
	<td colspan=2></td>
</tr>
<tr height=25>
	<td width="50%" class="bmenu">&nbsp;<%=indicator%></td>
	<td width="50%" class="bmenu" align=right>
		<input type="button" class="inputbox2" value="입력" onclick="opWinTtW()">&nbsp;</td>
</tr>
</form>
</table>
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