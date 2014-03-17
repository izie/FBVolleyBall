<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="L"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%

	Database db = new Database();

try{ 
	PoDAO poDAO			= new PoDAO(db);
	ClientDAO cDAO		= new ClientDAO(db);
	ContractDAO ctDAO	= new ContractDAO(db);
	LinkDAO lkDAO		= new LinkDAO(db);

	//request
	int prn			= KUtil.nchkToInt(request.getParameter("prn"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	String poKind	= KUtil.nchk(request.getParameter("poKind"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	int pageSize	= KUtil.nchkToInt(request.getParameter("pageSize"),20);
	
	String oby		= KUtil.nchk(request.getParameter("oby"),"poYear DESC,poNum DESC,poCnt DESC,poNumIncre DESC");
	
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"),"poDate");
	if( sStDate < 1 && sEdDate < 1 ){	//기본 데이타 2년 지정
		int nowDate	= KUtil.getIntDate("yyyyMMdd");	
		sStDate		= KUtil.getNextDate( nowDate, -365*2);
		//sEdDate		= nowDate;
	}

	int totCnt = poDAO.getTotal(sk, st, seq_client, priceKinds, sStDate, sEdDate, schKinds, poKind);
	if( prn == 1 ) pageSize = totCnt; //프린트시
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 10, totCnt, nowPage);
	
	String indicator = paging.getIndi();

	Vector vecPo = poDAO.getList(start, pageSize, sk, st, seq_client, priceKinds, oby, sStDate, sEdDate, schKinds, poKind);
	int num = pageSize*nowPage - (pageSize-1);
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/list_print.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function move(pge){
	var frm = document.poListForm;
	frm.nowPage.value = pge;
	frm.action = "list.jsp";
	frm.submit();
}
function chkSearch(){
	var frm = document.poListForm;
	frm.nowPage.value=1;
	frm.action = "list.jsp";
}
function goSelect(seq_po){
	var pop = window.open("printPo.jsp?seq_po="+seq_po,"viewPo","scrollbars=1,resizable=1");
	pop.focus();
}
function selectClient(){
	var frm = document.poListForm;
	frm.nowPage.value = 1;
	frm.action = "list.jsp";
	frm.submit();
}
function goWrite(){
	var pop = window.open("write.jsp","writePo","scrollbars=1,resizable=1");
	pop.focus(); 
}
function viewClient(seq){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/client/view.jsp?seq="+seq,"viClient","top="+tp+",left="+lft+",scrollbars=1,width=720,height=660");
	pop.focus();
}
function viewContract(seq){
	var lft = (screen.availWidth-700)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/contract/view.jsp?seq="+seq+"&reload=4","padd","top="+tp+",left="+lft+",scrollbars=0,width=700,height=660");
	pop.focus();
}
function chPageSize(){
	var frm = document.poListForm;
	frm.action = "list.jsp";
	frm.nowPage.value=1;
	frm.submit();
}
function repage(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.submit();
}
function resort(w){
	var frm = document.poListForm;
	if( w=='no' ){
		if( frm.oby.value.indexOf("poYear DESC") > -1 ){
			frm.oby.value = "poYear,poNum,poCnt,poNumIncre";
		}else{
			frm.oby.value = "poYear DESC,poNum DESC,poCnt DESC,poNumIncre DESC";
		}
	}else if( w=='date' ){
		if( frm.oby.value.indexOf("wDate DESC") > -1 ){
			frm.oby.value = "wDate";
		}else{
			frm.oby.value = "wDate DESC";
		}
	}
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
</HEAD>

<BODY <%=prn != 1 ?"class='body1'":""%>>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="poListForm" method="post" onsubmit="return chkSearch();">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="seq" value="">
<input type="hidden" name="oby" value="<%=oby%>">
<tr>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">PO 목록</FONT></B></td>
</tr>
<tr>
	<td class="ti1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="150">&nbsp;▶ 전체: <%=totCnt%> 건</td>
			<td	align=right>
				<select name="seq_client" class="selbox" onchange="chPageSize()">
					<option value="">▒▒전체 (매입) 업체▒▒</option>
			<%	Vector vecClient = cDAO.getClient("매입");
				for( int i=0 ; i<vecClient.size() ; i++ ){	
					Client cl  = (Client)vecClient.get(i);	%>
					<option value="<%=cl.seq%>" <%=cl.seq==seq_client?"selected":""%>><%=cl.bizName%></option>
			<%	}//for	%>
				</select>
			<%	String	ponoSerarchText  = "CONCAT(if(SUBSTRING(poYear,3,2)<10,'0',''),";
						ponoSerarchText += "SUBSTRING(poYear,3,2)*if(poNum<100,1000,1)+if(poNum<100,poNum,0)";
						ponoSerarchText += ",if(poNum>99,poNum,'')";
						ponoSerarchText += ",if(poCnt>0,'(','')";
						ponoSerarchText += ",if(poCnt>0,poCnt,'')";
						ponoSerarchText += ",if(poCnt>0,')','')";
						ponoSerarchText += ",if(poNum>99,poNum,'')";
						ponoSerarchText += ",'-'";
						ponoSerarchText += ",poNumIncre	)";%>
				<select name="sk" id="sk" class="selbox" change="chgSrch();">
					<option value="<%=ponoSerarchText%>" <%=sk.equals(ponoSerarchText)?"selected":""%>>PO No</option>
					<option value="wDate" <%=sk.equals("wDate")?"selected":""%>>PO날짜</option>
				</select>
				<input type="text" name="st" value="<%=st%>" class="inputbox">&nbsp;<select name="poKind" class="selbox1">
			<option value="" <%="".equals(poKind)?"selected":""%>>전체</option>
			<option value="FK" <%="FK".equals(poKind)?"selected":""%>>FK</option>
			<option value="HB" <%="HB".equals(poKind)?"selected":""%>>HB</option>
		</select></td>
			<td rowspan=2 width="50"><input type="submit" value="검색" class="inputbox2" style="height:40"></td>
		</tr>
		<tr>
			<td><select name="pageSize" class="selbox" onchange="chPageSize()">
					<option value="5" <%=pageSize==5?"selected":""%>>5개씩보기</option>
					<option value="10" <%=pageSize==10?"selected":""%>>10개씩보기</option>
					<option value="15" <%=pageSize==15?"selected":""%>>15개씩보기</option>
					<option value="20" <%=pageSize==20?"selected":""%>>20개씩보기</option>
					<option value="30" <%=pageSize==30?"selected":""%>>30개씩보기</option>
					<option value="50" <%=pageSize==50?"selected":""%>>50개씩보기</option>
					<option value="100" <%=pageSize==100?"selected":""%>>100개씩보기</option>
					<option value="<%=totCnt%>" <%=pageSize==totCnt?"selected":""%>>전체보기</option>
				</select>
				<input type="button" value="프린트" onclick="popPrint();" class="Btn_prn"></td>
			<td align=right>
				<FONT class="schDuring">기간검색:
				<input type="text" name="sStDate" value="<%=sStDate>0?sStDate+"":""%>" class="inputbox" size=8 maxlength=8> 
				~ 
				<input type="text" name="sEdDate" value="<%=sEdDate>0?sEdDate+"":""%>" class="inputbox" size=8 maxlength=8>
				<select name="schKinds" class="selbox">
					<option value="poDate" <%=schKinds.equals("poDate")?"selected":""%>>PO Date</option>
				</select></FONT>&nbsp;</td>
		</tr>
		</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="100%" class="line-table_A2">
<tr align=center height=30>
	<th width="60"><A HREF="javascript:resort('date');">PO Date</A></th>
	<th width="80"><A HREF="javascript:resort('no');">PO 타입</A></th>
	<th width="80"><A HREF="javascript:resort('no');">PO NO</A></th>
	<th width="230">PO업체</th>
    <th width="150">금액</th>
	<th><table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" class="nontable">
        <tr>
            <th width="60">계약서</th>
            <th>계약처</th>
        </tr>
        </table></th>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" class="table_A2" width="100%">
<%	for( int i=0 ; i<vecPo.size() ; i++ ){	
		Po po = (Po)vecPo.get(i);		
		Vector vecLink = lkDAO.getList(po.seq);		
		Client ct0 = cDAO.selectOne(po.seq_client);	
		String cls = i%2==0?"databg_line":"";		%>
<tr align=center height=25>
	<td width="60" class="<%=cls%>"><%=KUtil.dateMode(po.poDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	<td width="80" class="<%=cls%>" align=left>&nbsp;
		<span <%=po.eff<0?"class='cline'":""%>><%=(po.poKind != null && !"".equals(po.poKind) )?po.poKind:"없음"%></span></td>
	<td width="80" class="<%=cls%>" align=left>&nbsp;
		<A HREF="javascript:goSelect('<%=po.seq%>')"><span <%=po.eff<0?"class='cline'":""%>><%=poDAO.getPoNo(po)%></span></A></td>
	
	<td width="230" class="<%=cls%>">
		<A HREF="javascript:" onclick="viewClient('<%=ct0.seq%>')"><%=KUtil.nchk(ct0.bizName)%></A></td>
	
	<td width="150" class="<%=cls%>" align=right>
		<%=KUtil.nchk(po.priceKinds)%> <%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","&nbsp;")%>&nbsp;</td>
	
	<td colspan=3 class="<%=cls%>">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" class="nontable">
	<%	int rcnt = 0;
		for( int j=0 ; j<vecLink.size() ; j++ ){	
			dao.Link lk = (dao.Link)vecLink.get(j);		
				Contract ct = ctDAO.selectOne(lk.seq_contract);
				if( ct.seq > 0 ){	
				Client ct1 = cDAO.selectOne(ct.seq_client);	
				rcnt++;			%>
		<tr align=center <%=j+1 != vecLink.size() ? "class='bk2_3'" : ""%>>
			<td width="60"><A HREF="javascript:" onclick="viewContract(<%=ct.seq%>)"><%=ctDAO.getContractNo(ct)%></A></td>
			<td width="1" bgcolor="#CECDCB"></td>
			<td><A HREF="javascript:" onclick="viewClient('<%=ct1.seq%>')"><%=KUtil.nchk(ct1.bizName)%></A></td>
		</tr>
	<%			}//if
		}//for	j	
		if( rcnt == 0 ){	%>
		<tr class="<%=cls%>">
			<td><table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr>
					<td width="60">&nbsp;</td>
					<td width="1" bgcolor="#CECDCB"></td>
					<td>&nbsp;</td>
				</tr>
				</table></td>
		</tr>
	<%	}%>

		</table></td>
</tr>
<%		num++;
	}//for	
	
	if( vecPo.size() < 1 ){	%>
<tr align=center height=50>
	<td colspan=9>데이타가 존재하지 않습니다.</td>
</tr>		

<%	}	%>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr align=center>
	<td colspan=12 class="bmenu">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td><%=indicator%></td>
			<td align=right>
				<input type="button" value="PO 추가" onclick="goWrite()" class="inputbox2"></td>
		</tr>
		</table></td>
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
