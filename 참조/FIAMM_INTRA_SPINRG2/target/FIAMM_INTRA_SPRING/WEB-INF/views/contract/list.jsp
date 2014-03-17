<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="contract"/>
	<jsp:param name="col" value="L"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%

	Database db = new Database();

try{ 


	//request
	int prn			= KUtil.nchkToInt(request.getParameter("prn"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	String oby		= KUtil.nchk(request.getParameter("oby"),"coYear DESC,coNum DESC, seq DESC");
	int pageSize	= KUtil.nchkToInt(request.getParameter("pageSize"),20);
	
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"),"conDate");
	if( sStDate < 1 && sEdDate < 1 ){	//기본 데이타 2년 지정
		int nowDate	= KUtil.getIntDate("yyyyMMdd");	
		sStDate		= KUtil.getNextDate( nowDate, -365*2);
		//sEdDate		= nowDate;
	}
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));

	//생성자
	ContractDAO ctDAO	= new ContractDAO(db);
	ClientDAO cDAO		= new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	UserDAO uDAO		= new UserDAO(db);
	ProjectDAO pDAO		= new ProjectDAO(db);
	LinkDAO lkDAO		= new LinkDAO(db);
	PoDAO poDAO			= new PoDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);

	int totCnt = ctDAO.getTotal(sk, st, seq_client, sStDate, sEdDate, schKinds, priceKinds);
	if( prn == 1 ) pageSize = totCnt; //프린트시
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil();
	paging.setPageSize(pageSize);
	paging.setBlockSize(10);
	paging.setRowCount(totCnt);
	paging.setCurrentPage(nowPage);
	
	String indicator = paging.getIndi();
	
	Vector vecSum = null;
	if( priceKinds.length() > 0 ){
		vecSum = ctDAO.getSum(sk, st, seq_client, sStDate, sEdDate, schKinds, priceKinds);
	}
	Vector vecList = ctDAO.getList(start, pageSize, sk, st, seq_client, oby, sStDate, sEdDate, schKinds, priceKinds);
	int num = pageSize*nowPage - (pageSize-1);

	
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></script>
<SCRIPT LANGUAGE="JavaScript" src="/common/list_print.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function move(pge){
	var frm = document.contractListForm;
	frm.nowPage.value = pge;
	frm.action = "list.jsp";
	frm.submit();
}
function detailView(seq){
	var frm = document.contractListForm;
	var pop = window.open("view.jsp?seq="+seq,"viContract","scrollbars=auto");
	pop.focus();
}
function chkSearch(){
	var frm = document.contractListForm;
	frm.nowPage.value = 1;
	frm.action = "list.jsp";
	frm.submit();
}
function goWrite(){
	var frm = document.contractListForm;
	var pop = window.open("write.jsp","inContract","scrollbars=1");
	pop.focus();
}
function selectClient(){
	var frm = document.contractListForm;
	frm.nowPage.value = 1;
	frm.action = "list.jsp";
	frm.submit();
}
function viewClient(seq){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/client/view.jsp?seq="+seq,"viClient","top="+tp+",left="+lft+",scrollbars=1,width=720,height=660");
	pop.focus();
}
function goSelect(seq_po){
	var lft = (screen.availWidth-720)/2;
	var tp	= (screen.availHeight-600)/2;
	var pop = window.open("/main/po/printPo.jsp?seq_po="+seq_po,"viewPo","width=720,height=600,scrollbars=1,resizable=1,left="+lft+",top="+tp);
	pop.focus();
}
function obyWork(flg){
	var frm = document.contractListForm;
	if( flg=='s' ){
		if( frm.oby.value.indexOf("coYear DESC") > -1 )
			frm.oby.value = "coYear,coNum, seq DESC";
		else 
			frm.oby.value = "coYear DESC,coNum DESC, seq DESC";
	}else{
		if( frm.oby.value.indexOf("conDate DESC, seq DESC") > -1 )
			frm.oby.value = "conDate, seq DESC";
		else
			frm.oby.value = "conDate DESC, seq DESC";
	}
	frm.action = "list.jsp";
	frm.submit();
}
function repage(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.submit();
}
function chPageSize(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.nowPage.value =1;
	frm.submit();
}
function viewProject(i, seq_project){
	//var pop = window.open("/main/project/one_inte_view.jsp?seq_project="+seq_project,"viProj","scrollbars=0");
	document.frames['ifm_'+i].location = "/main/project/one_inte_view.jsp?seq_project="+seq_project+"&id="+i;
	show2('id_'+i);
}
function popPrint(){
	var frm = document.forms[0];
	var w = screen.availWidth;
	var h = screen.availHeight;
	var pop = window.open("","listprint","width=100,height=100,top=0,left=0,scrollbars=yes");
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
<table cellpadding="0" cellspacing="1" border="0" width="100%">
<form name="contractListForm" method="post" onsubmit="return chkSearch();">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="seq" value="">
<input type="hidden" name="oby" value="<%=oby%>">
<tr>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">계약 리스트</FONT></B></td>
</tr>
<tr>
	<td class="ti1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td width="150">&nbsp;▶ 전체: <%=totCnt%> 건</td>
			<% if(prn != 1){ %>
			<td	align=right>
				<select name="seq_client" onchange="selectClient()" class="selbox">
					<option value="">▒▒전체 업체▒▒</option>
			<%	Vector vecClient = cDAO.getClient("매출");
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

				<select name="sk" class="selbox">
					<option value="title" <%=sk.equals("title")?"selected":""%>>제목</option>
					<option value="userId" <%=sk.equals("userId")?"selected":""%>>작성자아이디</option>
				</select>
				<input type="text" name="st" value="<%=st%>" size=15 maxlength=20 class="inputbox">&nbsp;</td>
			<td rowspan=2 width="50"><input type="submit" value="검색" style="height:40"></td>
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
					<option value="conDate" <%=schKinds.equals("conDate")?"selected":""%>>시작일</option>
				</select></FONT>&nbsp;</td>
				<% } %>
		</tr>
		</table></td>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="100%" class="line-table_A2">
	<col width="9%"></col>
	<col width="8%"></col>
	<col width="14%"></col>
	<col width="12%"></col>
	<col width="10%"></col>
	<col width="4%"></col>
	<col width="43%"></col>
<tr align=center height=28>
	<th><A style="cursor:hand" onclick="obyWork('s')">번호</A></th>
	
	<th><A style="cursor:hand" onclick="obyWork('d')">계약일</A></th>
	
	<th>계약업체</th>

	<th>계약금액</th>
	
	<th>Po No.</th>
		
	<th>파일</th>

	<th>프로젝트</th>
</tr>

<%	for( int i=0 ; i<vecList.size() ; i++ ){	
		Contract ct = (Contract)vecList.get(i);		
		Client cl = cDAO.selectOne(ct.seq_client);		
		Vector vecLink = lkDAO.getList(0, ct.seq, 0);			
		String cls = i%2==0?"databg_line":"";			
		Project pj = pDAO.selectOne(ct.seq_project);			%>
<tr align=center height=25>
	<td class="<%=cls%>"><A HREF="javascript:detailView('<%=ct.seq%>')">
		<%=ctDAO.getContractNo(ct)%></A></td>
	
	<td class="<%=cls%>"><%=KUtil.dateMode(ct.conDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	
	<td class="<%=cls%>" align=left>&nbsp;<A HREF="javascript:viewClient('<%=cl.seq%>')"><%=cl.bizName%></A></td>
		
	<td class="<%=cls%>" align=right><%=ct.priceKinds%> <%=NumUtil.numToFmt(ct.supPrice,"###,###.##","0")%>&nbsp;</td>
	
	<td class="<%=cls%>" align=center>
	<%	int lcnt =0;
		for( int j=0 ; j<vecLink.size() ; j++ ){	
			Link lk = (Link)vecLink.get(j);	
			Po po = poDAO.selectOne(lk.seq_po);		
			if( po.seq > 0 ){		%>
				<div>&nbsp;<A HREF="javascript:goSelect('<%=po.seq%>')"><%=poDAO.getPoNo(po)%></A></div>
	<%			lcnt++;
			}//if
		}//for j	
		if( lcnt ==0 ) out.print("<div>&nbsp;N/A</div>");%>
		</td>
		
	<td class="<%=cls%>">
		<%	if( KUtil.nchk(ct.fileName).length() > 0 ){	%>
					<A HREF="javascript:;" onclick="filesCreateLink(-10,0,<%=i%>)">
						<IMG SRC="/images/icon/disk.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A>
					<textarea name="filesLink<%=i%>" style="display:none">
						<%=FileCtl.fileViewLink(ct.fileName,"",ct.seq,"contract","<br>",0)%></textarea>
		<%		}else{
					out.println("&nbsp;");
				}	%></td>

	<td class="<%=cls%>" align=left>&nbsp;<A HREF="javascript:viewProject(<%=i%>,'<%=pj.seq%>')"><%=KUtil.nchk(pj.name)%></A></td>
</tr>

<tr style="display:none;" id="id_<%=i%>" height="50">
	<td colspan=15><iframe name="ifm_<%=i%>" id="ifm_<%=i%>" width="100%" height="200" frameborder="0"></iframe></td>
</tr>
<%		num++;
	}//for	%>

<%	if( vecList.size() < 1 ){	%>
<tr align=center height=60 class="r_bg">
	<td colspan=15>데이타가 존재하지 않습니다.</td>
</tr>
<%	}	%>

<%	if( vecSum != null ){				%>
<tr>
	<td class=menu1 colspan=3 align=right>합계:&nbsp;</td>
	<td class=menu1 align=right>
<%		for( int i=0 ; i<vecSum.size() ; i++ ){		
			PoSum psm = (PoSum)vecSum.get(i);		%>
		<div><%=psm.priceKinds%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
<%		}//for		%></td>
	<td class=menu1 colspan=3>&nbsp;</td>
</tr>
<%	}				%>
</table>
<% if(prn != 1) { %>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr align=center>
	<td colspan=15 class="bmenu">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td><%=indicator%></td>
			<td align=right>
				<input type="button" value="계약서 입력" onclick="goWrite()"></td>
		</tr>
		</table></td>
</tr>

</table>
<% } %>
</form>
</BODY>
</HTML>


<jsp:include page="/inc/inc_print.jsp" flush="true"/>


<%
	if( prn == 1 ){
		KUtil.scriptOut(out, "list_print_preview()");
	}
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
