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
	int nowPage			= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk			= KUtil.nchk(request.getParameter("sk"));
	String st			= KUtil.nchk(request.getParameter("st"));
	int seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	int pageSize		= KUtil.nchkToInt(request.getParameter("pageSize"),10);
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"),"p.wDate");
	String oby			= KUtil.nchk(request.getParameter("oby"),"p.poYear DESC,p.poNum DESC,p.poCnt DESC,p.poNumIncre DESC");
	if( sStDate < 1 && sEdDate < 1 ){
		int nowDate			= KUtil.getIntDate("yyyyMMdd");	
		sStDate = KUtil.getNextDate( nowDate, -365*2);
		//sEdDate	= nowDate;
	}

	//생성자
	ProjectDAO pDAO			= new ProjectDAO(db);
	PoDAO poDAO				= new PoDAO(db);
	LinkDAO lkDAO			= new LinkDAO(db);
	ContractDAO ctDAO		= new ContractDAO(db);
	PoItemDAO poiDAO		= new PoItemDAO(db);
	ClientDAO cDAO			= new ClientDAO(db);
	ClientUserDAO cuDAO		= new ClientUserDAO(db);
	PassDAO psDAO			= new PassDAO(db);
	PassItemLnkDAO pilDAO	= new PassItemLnkDAO(db);
	SetupItemDAO siDAO		= new SetupItemDAO(db);
	LcDAO lcDAO				= new LcDAO(db);
	TtDAO ttDAO				= new TtDAO(db);
	PriceKindsDAO pkDAO		= new PriceKindsDAO(db);
	Pass ps = null;
	Link lnk = new Link();
	

	

	
	int totCnt		= poDAO.getTotal1(sk, st, seq_client, priceKinds, sStDate, sEdDate, schKinds);
	int start		= (nowPage*pageSize) - pageSize;
	
	PagingUtil paging = new PagingUtil(pageSize,5,totCnt,nowPage);
	String indicator = paging.getIndi();

	Vector vecPo = poDAO.getList1(start, pageSize, sk, st, seq_client, priceKinds, sStDate, sEdDate, schKinds, oby);


	Vector vecSum = null;
	if( priceKinds.length() > 0 ){
		vecSum = poDAO.getSum1(sk, st, seq_client, priceKinds, sStDate, sEdDate, schKinds);
	}
	

%>


<HTML>
<HEAD>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function move(pge){
	var frm = document.poListForm;
	frm.nowPage.value = pge;
	frm.action = "list_all_wide.jsp";
	frm.submit();
}
function opWin(seq){
	var lt = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-600)/2;
	var opt = window.open("/main/po/printPo.jsp?seq_po="+seq+"&reload=1","viEsti","width=720,height=600,left="+lt+",top="+tp+",scrollbars=1");
	opt.focus();
}
function cWin(seq){
	var opt = window.open("/main/contract/view.jsp?seq="+seq+"&reload=1","viEsti","scrollbars=0");
	opt.focus();
}
function showboxPosition(object,work,left,top){
	var obj = document.getElementById(object); 
	obj.style.pixelLeft = event.clientX + document.body.scrollLeft + Number(left) + 5;
	obj.style.pixelTop	= event.clientY + document.body.scrollTop + Number(top);
	obj.style.display	= work;
}
function hide(object,work){ 
    var obj = document.getElementById(object);    
    obj.style.display=work;  
}
function showClient(seq_client){
	var lt = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-600)/2;
	var opt = window.open("/main/client/view.jsp?seq="+seq_client+"&reload=1","clientView","width=720,height=600,left="+lt+",top="+tp+",scrollbars=1");
	opt.focus();
}
function opWinPass(seq_po, seq_pil){
	var pop = window.open("/main/pass/index.jsp?seq_po="+seq_po+"&seq_pil="+seq_pil,"passView","scrollbars=0");
	pop.focus();
}

function opWinPass1(seq_po){
	var pop = window.open("/main/pass/select.jsp?seq_po="+seq_po+"&fwd=1","passView","scrollbars=1");
	pop.focus();
}

function opWinLc(seq_po, seq_pil){
	var pop = window.open("/main/lc/index_div.jsp?seq_po="+seq_po+"&seq_pil="+seq_pil,"lcView","scrollbars=1");
	pop.focus();
}

function opWinTt(seq_po, seq_pil){
	var tp = (screen.availHeight-700)/2;
	var lft = (screen.availWidth-720)/2;
	var pop = window.open("/main/tt/index_div.jsp?seq_po="+seq_po+"&seq_pil="+seq_pil,"ttView","top="+tp+",scrollbars=1,height=700,width=720,left="+lft);
	pop.focus();
}
function opWinOutExcel(){
	var frm = document.poListForm;
	frm.action = "list_all_wide_excel.jsp";
	frm.submit();
}
function opWinWide(){
	var frm = document.poListForm;
	var tp  = screen.availHeight-40;
	var lt = 1024;
	window.open("","wideView","resizable=1,top=0,left=0,scrollbars=1,height="+tp+",width="+lt);
	frm.target = "wideView";
	frm.action = "list_all_wide.jsp";
	frm.submit();
}
function selectClient(){
	var frm = document.poListForm;
	frm.nowPage.value = 1;
	frm.action = "list_all_wide.jsp";
	frm.submit();
}
function chkSearch(){
	var frm = document.poListForm;
	frm.nowPage.value=1;
	frm.action = "list_all_wide.jsp";
}
function repage(){
	var frm = document.poListForm;
	frm.action = "list_all_wide.jsp";
	frm.submit();
}
function chPageSize(){
	var frm = document.poListForm;
	frm.action = "list_all_wide.jsp";
	frm.submit();
}
function inputEventMsg(seq_po){
	var pop = window.open("eventMsg.jsp?seq_po="+seq_po,"eventMsg","scrollbars=0,resizable=0");
	pop.focus();
}
function sortby(w){
	var frm = document.poListForm;
	if( w=='1' ){
		if( frm.oby.value.indexOf("p.wDate DESC") > -1 )	
			frm.oby.value = "p.wDate";
		else 
			frm.oby.value = "p.wDate DESC";
	}else if( w=='2' ){
		if( frm.oby.value.indexOf("p.poYear DESC") > -1 )	
			frm.oby.value = "p.poYear,p.poNum,poCnt,p.poNumIncre";
		else 
			frm.oby.value = "p.poYear DESC,p.poNum DESC,p.poCnt DESC,p.poNumIncre DESC";
	}else if( w=='3' ){
		if( frm.oby.value.indexOf("s.exw DESC") > -1 )	
			frm.oby.value = "s.exw";
		else 
			frm.oby.value = "s.exw DESC";
	}else if( w=='4' ){
		if( frm.oby.value.indexOf("s.etd DESC") > -1 )	
			frm.oby.value = "s.etd";
		else 
			frm.oby.value = "s.etd DESC";
	}else if( w=='5' ){
		if( frm.oby.value.indexOf("s.eta DESC") > -1 )	
			frm.oby.value = "s.eta";
		else 
			frm.oby.value = "s.eta DESC";
	}else if( w=='6' ){
		if( frm.oby.value.indexOf("s.currDate DESC") > -1 )	
			frm.oby.value = "s.currDate";
		else 
			frm.oby.value = "s.currDate DESC";
	}else if( w=='7' ){
		if( frm.oby.value.indexOf("s.pass DESC") > -1 )	
			frm.oby.value = "s.pass";
		else 
			frm.oby.value = "s.pass DESC";
	}else if( w=='8' ){
		if( frm.oby.value.indexOf("s.deliDate DESC") > -1 )	
			frm.oby.value = "s.deliDate";
		else 
			frm.oby.value = "s.deliDate DESC";
	}
	frm.action = "list_all_wide.jsp";
	frm.submit();
}
</SCRIPT>
</HEAD>

<BODY>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="poListForm" method="post" onsubmit="return chkSearch();">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="seq" value="">
<input type="hidden" name="oby" value="<%=oby%>">
<tr height=35>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">PO별 리스트</FONT></B></td>
</tr>
<tr height=50>
	<td class="ti1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr valign=middle align=center>
			<td rowspan=2 width="100" valign=bottom>
				<select name="pageSize" class="selbox" onchange="chPageSize()">
					<option value="5" <%=pageSize==5?"selected":""%>>5개씩보기</option>
					<option value="10" <%=pageSize==10?"selected":""%>>10개씩보기</option>
					<option value="15" <%=pageSize==15?"selected":""%>>15개씩보기</option>
					<option value="20" <%=pageSize==20?"selected":""%>>20개씩보기</option>
					<option value="<%=totCnt%>" <%=pageSize==totCnt?"selected":""%>>전체보기</option>
				</select></td>
			<td align=right>
				<select name="seq_client" class="selbox" onchange="chPageSize()">
					<option value="">▒전체 (매입) 업체▒</option>
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
			
			<%	String	ponoSerarchText  = "concat(";
						ponoSerarchText += "p.poYear*if(p.poNum<100,1000,1)+if(p.poNum<100,p.poNum,0)";
						ponoSerarchText += ",if(p.poNum>99,p.poNum,'')";
						ponoSerarchText += ",if(p.poCnt>0,'(','')";
						ponoSerarchText += ",if(p.poCnt>0,p.poCnt,'')";
						ponoSerarchText += ",if(p.poCnt>0,')','')";
						ponoSerarchText += ",if(p.poNum>99,p.poNum,'')";
						ponoSerarchText += ",'-'";
						ponoSerarchText += ",poNumIncre	)";%>
				<select name="sk" class="selbox">
					<option value="<%=ponoSerarchText%>" <%=sk.equals(ponoSerarchText)?"selected":""%>>PO NO</option>
				</select>
				<input type="text" name="st" value="<%=st%>" class="inputbox"></td>
			<td rowspan=2 width="50"><input type="submit" value="검색" class="inputbox2" style="height:40"></td>
		</tr>
		<tr align=right>
			<td><FONT class="schDuring">기간검색:
				<input type="text" name="sStDate" value="<%=sStDate>0?sStDate+"":""%>" class="inputbox" size=8 maxlength=8> 
				~ 
				<input type="text" name="sEdDate" value="<%=sEdDate>0?sEdDate+"":""%>" class="inputbox" size=8 maxlength=8>
				<select name="schKinds" class="selbox">
					<option value="p.wDate" <%=schKinds.equals("p.wDate")?"selected":""%>>PO DATE</option>
					<option value="s.EXW" <%=schKinds.equals("s.EXW")?"selected":""%>>EXW</option>
					<option value="s.ETD" <%=schKinds.equals("s.ETD")?"selected":""%>>ETD</option>
					<option value="s.ETA" <%=schKinds.equals("s.ETA")?"selected":""%>>ETA</option>
					<option value="s.currDate" <%=schKinds.equals("s.currDate")?"selected":""%>>납기일</option>
					<option value="s.pass" <%=schKinds.equals("s.pass")?"selected":""%>>통관일</option>
					<option value="s.deliDate" <%=schKinds.equals("s.deliDate")?"selected":""%>>납품일</option>
				</select></FONT></td>
		</tr>
		</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr align=center height=20 bgcolor="#B3BFD9">
	<td class="menu1" width="50" rowspan=2><A HREF="javascript:sortby('1')"><B>Date</B></A></td>
	<td class="menu1" width="60" rowspan=2><A HREF="javascript:sortby('2')">P/O<br>NO</A></td>
	<td class="menu1" width="45" rowspan=2>계약<br>NO</td>
	<td class="menu1" width="110">PO 업체</td>
	<td rowspan=2 colspan=11>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr align=center>
			<td class="menu1" rowspan=2 width="3%">보</td>
			<td class="menu1" rowspan=2 width="10%">매출처</td>
			<td class="menu1" rowspan=2 width="14%">품명 [수량]</td>
			<td class="menu1" rowspan=2 width="9%">설치장소</td>
			<td class="menu1" rowspan=2 width="9%"><A HREF="javascript:sortby('3')">EXW</A></td>
			<td class="menu1" rowspan=2 width="9%"><A HREF="javascript:sortby('4')">ETD</A></td>
			<td class="menu1" rowspan=2 width="9%"><A HREF="javascript:sortby('5')">ETA</A></td>

			<td class="menu1" rowspan=2 width="9%"><A HREF="javascript:sortby('6')">납기일</A></td>
			<td class="menu1" rowspan=2 width="9%"><A HREF="javascript:sortby('7')">통관일</A></td>
			<td class="menu1" rowspan=2 width="9%"><A HREF="javascript:sortby('8')">납품일</A></td>
			<td class="menu1" rowspan=2 width="10%">결재방법</td>
		</tr>
		</table></td>
</tr>
<tr align=center height=20 bgcolor="#B3BFD9">
	<td class="menu1">금액</td>
</tr>

<%	for( int i=vecPo.size()-1 ; i>=0 ; i-- ){	
		Po po = (Po)vecPo.get(i);				
		Client cl = cDAO.selectOne(po.seq_client);		
		Vector vecPil	 = pilDAO.getList(po.seq);
		String clas = i%2==0?"menu2_1":"menu2";	
		int msglen = KUtil.nchk(po.eventMsg).length();	%>

<tr align=center height=20>
	<td class="<%=clas%>" rowspan=2>
		<%=KUtil.dateMode(po.wDate,"yyyyMMdd","yy.MM.dd","&nbsp")%>
		<BR>
			<%	if( msglen>0 ){	%>
			<IMG SRC="/images/icon/msg.gif" WIDTH="14" HEIGHT="11" BORDER="0" ALT="" onclick="inputEventMsg(<%=po.seq%>)" style="cursor:hand" onmouseover="show5(id_msg<%=i%>,'block')" onmouseout="show5(id_msg<%=i%>,'none')">
			<div id="id_msg<%=i%>" style="display:none;position:absolute;width:150;height:100;background-color:lightyellow;border:1 solid #C0C0C0;padding:5 0 0 5;text-align:left"><%=KUtil.toTextMode(po.eventMsg,"&nbsp;")%></div>
			<%	}else{			%>
			<IMG SRC="/images/icon/bmsg.gif" WIDTH="14" HEIGHT="11" BORDER="0" ALT="" style="cursor:hand" onclick="inputEventMsg(<%=po.seq%>)">
			<%	}	%></td>

	<td class="<%=clas%>" rowspan=2>
		<A HREF="javascript:opWin('<%=po.seq%>');"><span <%=po.eff<0?"class='cline'":""%>><%=poDAO.getPoNo(po)%></span></A></td>


	<td class="<%=clas%>" rowspan=2>
	<%	int inCnt = 0;
		Vector vecLink = lkDAO.getListCon(po.seq);		
		for( int j=0 ; j<vecLink.size() ; j++ ){
			Contract ct = ctDAO.selectOne(((Integer)vecLink.get(j)).intValue() );
			if( ct.seq > 0 ){
				inCnt++;			%>
			<div><A HREF="javascript:cWin('<%=ct.seq%>')"><%=KUtil.nchk(ctDAO.getContractNo(ct),"&nbsp;")%></A></div>
	<%		}//if 
		}//for Link		

		if( inCnt ==0 ) out.println("&nbsp;");		%></td>
	
	
	<td class="<%=clas%>">
		<A HREF="javascript:showClient('<%=cl.seq%>')">
			<%=KUtil.cutTitle( KUtil.nchk(cl.bizName,"&nbsp;") ,15,"..")%></A></td>

	<td rowspan=2 colspan=11>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<%	for( int h=0 ; h<vecPil.size() ; h++ ){		
				PassItemLnk pil = (PassItemLnk)vecPil.get(h);	
				Vector vecLc = lcDAO.getListPil(pil.seq);		
				Vector vecTt = ttDAO.getListPil(pil.seq);		
				Contract ct = null;
				Client ct1 = null;
				if( pil.seq_contract >0 ) ct = ctDAO.selectOne(pil.seq_contract);
				if( ct != null ) ct1 = cDAO.selectOne(ct.seq_client);				%>
		<tr align=center>
			<td width="3%" class="<%=clas%>" >
				<%=KUtil.nchk(pil.isDropGuar,"N")%></td>
			<td width="10%" class="<%=clas%>" style="word-break:break-all">
				<%	if( ct1==null ) out.print("&nbsp;");
					else{
						out.print( KUtil.nchk(ct1.bizName,"&nbsp;") );		}%></td>
			<td width="14%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass1('<%=po.seq%>')" align=left>
			
			<%	Vector vecSetupItem = siDAO.getListIn(pil.seq_setupitem);
				for( int g=0 ; g<vecSetupItem.size() ; g++ ){	
					SetupItem si = (SetupItem)vecSetupItem.get(g);			
					PoItem pi = poiDAO.selectOne(si.seq_poitem);	%>		

				<div style="width:100%">
					<A onmouseover="showboxPosition('id_<%=i%><%=h%><%=g%>','block',0,-15);" onmouseout="hide('id_<%=i%><%=h%><%=g%>','none')">&nbsp;
						<%=KUtil.cutTitle( KUtil.nchk(pi.itemName) ,13,"..")%> 
						<FONT COLOR="#3300CC">[<%=KUtil.intToCom(si.cnt)%>]</FONT></A></div>

				<div style="position:absolute;display:none;background-color:lightyellow;border:1 solid #C0C0C0;padding:0 0 0 5" id="id_<%=i%><%=h%><%=g%>">
					<table cellpadding="0" cellspacing="0" border="0" width="300" height="100%">
					<tr>
						<td><%=KUtil.nchk(pi.itemName)+" / "+KUtil.nchk(pi.itemDim)%> 
							<B>수량:</B> <FONT COLOR="#3300CC"><%=KUtil.intToCom(si.cnt)%></FONT></td>
					</tr>
					</table></div>
			<%	}//for	%>
			<%=vecSetupItem.size()<1?"&nbsp;":""%></td>
			<td width="9%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass(<%=po.seq%>, '<%=pil.seq%>')">
				<%	if( KUtil.nchk(pil.place).length() > 0 ){	%>
					<A onmouseover="showboxPosition('idpl_<%=i%><%=h%>','block',0,-15);"  onmouseout="hide('idpl_<%=i%><%=h%>','none')">
						<%=KUtil.cutTitle( KUtil.nchk(pil.place) ,8 ,"..")%></A>
					<div style="position:absolute;display:none;width:150;height:40;background-color:lightyellow;border:1 solid #C0C0C0" id="idpl_<%=i%><%=h%>">
						<%=KUtil.nchk(pil.place)%></div>
				<%	}else{	out.println("&nbsp;");	}			%></td>
			<td width="9%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass(<%=po.seq%>, '<%=pil.seq%>')">
				<%	ps = psDAO.selectLastOne(pil.seq,"EXW");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , "&nbsp;"));
					else out.print(KUtil.nchk(ps.memo,"&nbsp;"));		%></td>
			<td width="9%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass(<%=po.seq%>, '<%=pil.seq%>')">
				<%	ps = psDAO.selectLastOne(pil.seq,"ETD");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , "&nbsp;"));
					else out.print(KUtil.nchk(ps.memo,"&nbsp;"));		%></td>
			<td width="9%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass(<%=po.seq%>, '<%=pil.seq%>')">
				<%	ps = psDAO.selectLastOne(pil.seq,"ETA");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , "&nbsp;"));
					else out.print(KUtil.nchk(ps.memo,"&nbsp;"));		%></td>
		
			<td width="9%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass(<%=po.seq%>, '<%=pil.seq%>')">
				<%=KUtil.dateMode(pil.currDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
			<td width="9%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass(<%=po.seq%>, '<%=pil.seq%>')">
				<%	ps = psDAO.selectLastOne(pil.seq,"통관일");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , "&nbsp;"));
					else out.print(KUtil.nchk(ps.memo,"&nbsp;"));		%></td>
			<td width="9%" class="<%=clas%>" style="cursor:hand" onclick="opWinPass(<%=po.seq%>, '<%=pil.seq%>')">
				<%=KUtil.dateMode(pil.deliDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
			<td width="10%" class="<%=clas%>">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr align=center>
					<%	if( vecLc.size() > 0 ){	%>
					<td><A HREF="javascript:" onclick="opWinLc(<%=po.seq%>, '<%=pil.seq%>')">L/C</A></td>
					<%	}else if( vecLc.size()<1 && KUtil.nchk(po.termPay).indexOf("L/C") > -1 ){	%>
					<td><A HREF="javascript:;" onclick="opWinLc(<%=po.seq%>, '<%=pil.seq%>')" style="background-color:#E0DFF9">L/C</A></td>
					<%	}	%>
					
					<%	if( vecTt.size() > 0 ){	%>
					<td><A HREF="javascript:" onclick="opWinTt(<%=po.seq%>, '<%=pil.seq%>')">T/T</A></td>
					<%	}else if( vecTt.size()<1 && KUtil.nchk(po.termPay).indexOf("T/T") > -1 ){	%>
					<td><A HREF="javascript:" onclick="opWinTt(<%=po.seq%>, '<%=pil.seq%>')" style="background-color:#FBE4CC">T/T</A></td>
					<%	}	%>
				</tr>
				</table></td>
		</tr>
		<%	}//for	
			if( vecPil.size() < 1 ){	%>
		<tr>
			<td class="<%=clas%>" style="cursor:hand" onclick="opWinPass1('<%=po.seq%>')">&nbsp;</td>
		</tr>
		<%	}%>
		</table></td>
</tr>

<tr align=center height=20>
	<td class="<%=clas%>" align=right><%=po.priceKinds%> <%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","0")%>&nbsp;</td>	
</tr>

<%	}//for	최상위%>
	

<%	if( vecPo.size() < 1 ){	%>
<tr height=50 class="bgc4" align=center>
	<td colspan=15>PO 데이타가 존재하지 않습니다.</td>
</tr>
<%	}	%>


<%	if( vecSum != null ){	%>
<tr height=25 class="menu1" align=right>
	<td colspan=3 class="menu1">합계:&nbsp;</td>
	<td class="menu1">
		<%	for( int i=0 ; i<vecSum.size() ; i++ ){		
				PoSum psm = (PoSum)vecSum.get(i);		%>
				<div><%=psm.priceKinds%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
	<td colspan=11 class="menu1">&nbsp;</td>
</tr>
<%	}//if		%>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr height="28">
	<td class="bmenu">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="60%">&nbsp;<%=indicator%></td>
			<td width="40%" align=right>
				<input type="button" value="Excel출력" onclick="opWinOutExcel()" class="inputbox2">
				<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();">&nbsp;</td>
		</tr>
		</table></td>
	
</tr>
</table>

</form>
</BODY>
</HTML>


<SCRIPT LANGUAGE="JavaScript">
fullsize();
</SCRIPT>


<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
