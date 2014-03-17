<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="commission"/>
	<jsp:param name="col" value="L"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	CommissionDAO cmDAO			= new CommissionDAO(db);
	Commission_linkDAO cmlDAO	= new Commission_linkDAO(db);
	ClientDAO cDAO				= new ClientDAO(db);
	PriceKindsDAO pkDAO			= new PriceKindsDAO(db);


	//request
	int prn			= KUtil.nchkToInt(request.getParameter("prn"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	String oby		= KUtil.nchk(request.getParameter("oby"),"conDate DESC,seq DESC");
	int pageSize	= KUtil.nchkToInt(request.getParameter("pageSize"),10);
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	if( sStDate < 1 && sEdDate < 1 ){	//기본 데이타 2년 지정
		int nowDate	= KUtil.getIntDate("yyyyMMdd");	
		sStDate		= KUtil.getNextDate( nowDate, -365*2);
		//sEdDate		= nowDate;
	}
	String priceKinds		= KUtil.nchk(request.getParameter("priceKinds"));
	String priceKindsCol	= KUtil.nchk(request.getParameter("priceKindsCol"));
	int seq_client_in		= KUtil.nchkToInt(request.getParameter("seq_client_in"));
	int seq_client_out		= KUtil.nchkToInt(request.getParameter("seq_client_out"));
	String schKinds			= KUtil.nchk(request.getParameter("schKinds"),"conDate");
	
	int totCnt = cmDAO.getTotal(sk, st, seq_client_in, seq_client_out, sStDate, sEdDate, priceKinds, priceKindsCol, schKinds);
	if( prn == 1 ) pageSize = totCnt; //프린트시
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 5, totCnt, nowPage);	
	String indicator = paging.getIndi();
	
	Vector vecSum[] = null;
	if( priceKinds.length() > 0 ){
		vecSum = cmDAO.getSum(sk, st, seq_client_in, seq_client_out, sStDate, sEdDate, priceKinds, priceKindsCol, schKinds);
	}
	Vector vecList = cmDAO.getList(start, pageSize, sk, st, seq_client_in, seq_client_out, sStDate, sEdDate, priceKinds, priceKindsCol, schKinds, oby);
	int num = pageSize*nowPage - (pageSize-1);

%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/list_print.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></script>
<SCRIPT LANGUAGE="JavaScript">
function addComm(){
	var frm = document.commissionForm;
	var pop = window.open("write.jsp","commision_add","scrollbars=1,resizable=1");
	pop.focus();
}
function repage(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.submit();
}
function selectClient(){
	var frm = document.commissionForm;
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
function obyWork(flg){
	var frm = document.commissionForm;
	if( flg=='1' ){
		if( frm.oby.value.indexOf("conDate DESC") > -1 )
			frm.oby.value = "conDate,seq DESC";
		else 
			frm.oby.value = "conDate DESC,seq DESC";
	}else if( flg=='2' ){
		if( frm.oby.value.indexOf("invoDate DESC, seq DESC") > -1 )
			frm.oby.value = "invoDate, seq DESC";
		else
			frm.oby.value = "invoDate DESC, seq DESC";
	}else if( flg=='3' ){
		if( frm.oby.value.indexOf("payDate DESC, seq DESC") > -1 )
			frm.oby.value = "payDate, seq DESC";
		else
			frm.oby.value = "payDate DESC, seq DESC";
	}else if( flg=='4' ){
		if( frm.oby.value.indexOf("client_name") < 0 )
			frm.oby.value = "client_name, seq DESC";
		else{
			if( frm.oby.value.indexOf("client_name DESC") > -1 )
				frm.oby.value = "client_name, seq DESC";
			else
				frm.oby.value = "client_name DESC, seq DESC";
		}
	}

	frm.action = "list.jsp";
	frm.submit();
}
function chPageSize(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.nowPage.value =1;
	frm.submit();
}
var tempj = null;
var tempi = null
function viewProject(i, seq_project, j){
	document.frames['ifm_'+i].location = "/main/project/one_inte_view.jsp?seq_project="+seq_project+"&id="+i;
	if( tempi == i ){
		if( tempj == j ){
			if( eval('id_'+i).style.display=="none" ){
				eval('id_'+i).style.display = "block";
			}else{
				eval('id_'+i).style.display = "none";
			}
		}
	}else{
		try{ eval('id_'+tempi).style.display = "none"; }catch(e){}
		eval('id_'+i).style.display = "block";
	}
	tempi = i;
	tempj = j;
}
function viewPo(seq_po){
	var lft = (screen.availWidth-720)/2;
	var tp	= (screen.availHeight-600)/2;
	var pop = window.open("/main/po/printPo.jsp?seq_po="+seq_po,"viewPo","width=720,height=600,scrollbars=1,resizable=1,left="+lft+",top="+tp);
	pop.focus();
}
function viewCom(seq){
	var pop = window.open("view.jsp?seq="+seq,"modCommiss","scrollbars=1,resizable=0");
	pop.focus();
}
function viewClient(seq){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/client/view.jsp?seq="+seq,"viClient","top="+tp+",left="+lft+",scrollbars=1,width=720,height=660");
	pop.focus();
}
function move(pge){
	var frm = document.commissionForm;
	frm.nowPage.value = pge;
	frm.action = document.location.pathname;
	frm.submit();
}
function showboxOnly(object,work,left,top,wid,hgt){
	var w = document.body.clientWidth;
    var h = document.body.clientHeight;
	if ( (w-Number(wid)) - ( Number(event.clientX) + Number(document.body.scrollLeft) ) < 10 ){
		left = left-Number(wid);
	}
    if ( (h-Number(hgt)) - ( Number(event.clientY) + Number(document.body.scrollTop) ) < 10 ){
		top = top-Number(hgt);
	}
	var obj = eval(object);    
    obj.style.display=work;
	obj.style.pixelLeft = Number(event.clientX) + Number(document.body.scrollLeft) + Number(left);
	obj.style.pixelTop = Number(event.clientY) + Number(document.body.scrollTop) + parseInt(top);
}
</SCRIPT>
</HEAD>

<BODY <%=prn != 1 ?"class='body1'":""%>>
<table cellpadding="0" cellspacing="1" border="0" width="100%">
<form name="commissionForm" method="post" onsubmit="return selectClient()">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="seq" value="">
<input type="hidden" name="oby" value="<%=oby%>">
<tr>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">Commission List</FONT></B></td>
</tr>
<tr>
	<td class="ti1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="150">&nbsp;▶ 전체: <%=totCnt%> 건</td>
			<td	align=right>
				<select name="seq_client_in" onchange="selectClient()" class="selbox">
					<option value="">▒▒전체 거래처▒▒</option>
			<%	Vector vecClient = cDAO.getClient("매출");
				for( int i=0 ; i<vecClient.size() ; i++ ){	
					Client cl  = (Client)vecClient.get(i);	%>
					<option value="<%=cl.seq%>" <%=cl.seq==seq_client_in?"selected":""%>><%=cl.bizName%></option>
			<%	}//for	%>
				</select>

				<select name="seq_client_out" onchange="selectClient()" class="selbox">
					<option value="">▒▒제조사검색▒▒</option>
			<%	Vector vecClient1 = cDAO.getClient("매입");
				for( int i=0 ; i<vecClient1.size() ; i++ ){	
					Client cl  = (Client)vecClient1.get(i);	%>
					<option value="<%=cl.seq%>" <%=cl.seq==seq_client_out?"selected":""%>><%=cl.bizName%></option>
			<%	}//for	%>
				</select>

				<select name="sk" class="selbox">
					<option value="pono" <%=sk.equals("pono")?"selected":""%>>PONO</option>
					<option value="project_name" <%=sk.equals("project_name")?"selected":""%>>프로젝트명</option>
				</select>
				<input type="text" name="st" value="<%=st%>" size=15 maxlength=20 class="inputbox">&nbsp;</td>
			<td rowspan=2 width="50"><input type="submit" value="검색" class="inputbox2" style="height:40"></td>
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
				<FONT class="schDuring">
				<select name="priceKinds" class="selbox">
					<option value="">▒통화단위▒</option>
					<option value="ALL" <%=priceKinds.equals("ALL")?"selected":""%>>전체통화</option>
			<%	Vector vecPrice = pkDAO.getList();
				for( int i=0 ; i<vecPrice.size() ; i++ ){	
					String _priceKinds  = (String)vecPrice.get(i);	%>
					<option value="<%=_priceKinds%>" <%=_priceKinds.equals(priceKinds)?"selected":""%>><%=_priceKinds%></option>
			<%	}//for	%>
				</select>
				<select name="priceKindsCol" class="selbox">
					<option value="totPriceKinds" <%=priceKindsCol.equals("totPriceKinds")?"selected":""%>>Tot Amount</option>
					<option value="comPriceKinds" <%=priceKindsCol.equals("comPriceKinds")?"selected":""%>>Com Amount</option>
				</select></FONT>
				&nbsp;
				<FONT class="schDuring">기간검색:
				<input type="text" name="sStDate" value="<%=sStDate>0?sStDate+"":""%>" class="inputbox" size=8 maxlength=8> 
				~ 
				<input type="text" name="sEdDate" value="<%=sEdDate>0?sEdDate+"":""%>" class="inputbox" size=8 maxlength=8>
				<select name="schKinds" class="selbox">
					<option value="conDate" <%=schKinds.equals("conDate")?"selected":""%>>계약일</option>
					<option value="invoDate" <%=schKinds.equals("invoDate")?"selected":""%>>Invoice Date</option>
					<option value="payDate" <%=schKinds.equals("payDate")?"selected":""%>>수금일</option>
				</select></FONT>&nbsp;</td>
		</tr>
		</table></td>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" class="line-table_A2" width="100%">
<tr align=center height=28>
	<th width=50><A style="cursor:hand" onclick="obyWork('1')">계약일</A></th>
	<th width=70><A style="cursor:hand" onclick="obyWork('4')">거래처</A></th>
	<th colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" class="nontable">
		<tr align=center>
			<th width=60>제조사</th>
            <td width=1 bgcolor="#CECDCB"></td>
			<th width=60>PO NO.</th>
            <td width=1 bgcolor="#CECDCB"></td>
			<th>Project</th>
		</tr>
		</table></th>
	
	<th width=110>Total<BR>Amount</th>
		
	<th width=110>Commission</th>

	<th width=40>Rate(%)</th>

	<th width=50><A style="cursor:hand" onclick="obyWork('2')">Invoice<BR>Date</A></th>
	
	<th width=25>Invo</th>

	<th width=50><A style="cursor:hand" onclick="obyWork('3')">수금일</a></th>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" class="table_A2" width="100%">
<%	for( int i=0 ; i<vecList.size() ; i++ ){	
		Commission cm = (Commission)vecList.get(i);	
		String cls = i%2==0?"tdm2":"tdm2_1";
		Vector vecCml = cmlDAO.getList(cm.seq);		
		int comlen = KUtil.nchk(cm.memo).length();	%>

<tr align=center height=25>
	<td width=50 class="<%=cls%>">
		
		<A HREF="javascript:viewCom('<%=cm.seq%>')" <%	if( comlen > 0 ){	%> onmouseover="showboxOnly(id_m<%=i%>,'block',5,0,150,100)" onmouseout="showboxOnly(id_m<%=i%>,'none',0,0,150,100)" <%	}	%>>
		<%=KUtil.dateMode(cm.conDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></A></td>
<%	if( comlen > 0 ){	%>
		<div id="id_m<%=i%>" style="display:none;background-color:lightyellow;border:1 solid #C0C0C0;position:absolute;width:150;height:100;text-align:left">
			<%=KUtil.nchk(cm.memo)%></div>
	<%	}	%>
	<td width=70 class="<%=cls%>">
        <%	if( KUtil.nchk(cm.client_name).length() > 0 ){
                out.print( "<A HREF='javascript:viewClient("+cm.seq_client+")'>"+KUtil.nchk(cm.client_name)+"</A>" );
            }else{
                out.print("&nbsp;");
            }	%></td>
	<td colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="nontable">
	<%	for( int j=0 ; j<vecCml.size() ; j++ ){	
		Commission_link cml = (Commission_link)vecCml.get(j);		%>
		<tr align=center height=25>
			<td width=60 class="<%=cls%>"><%=KUtil.nchk(cml.client_name,"&nbsp;")%></td>
            <td width=1 bgcolor="#CECDCB"></td>
			<td width=60 class="<%=cls%>">
				<A HREF="javascript:viewPo('<%=cml.seq_po%>')"><%=KUtil.nchk(cml.pono,"&nbsp;")%></A></td>
            <td width=1 bgcolor="#CECDCB"></td>
			<td class="<%=cls%>">
				<A HREF="javascript:viewProject('<%=i%>','<%=cml.seq_project%>','<%=j%>')">
					<%=KUtil.nchk(cml.project_name,"&nbsp;")%></A></td>
		</tr>
        <%  if (vecCml.size() > 0 && j+1 != vecCml.size()) { %>
        <tr>
        	<td bgcolor="#CECDCB" colspan=7 style="height:1"><IMG SRC="/images/1x1.gif" WIDTH="1" HEIGHT="1" BORDER="0" ALT=""></td>
        </tr>
        <%  }//if   %>
	<%	}//for	%>
		</table></td>
	
	<td width=110 class="<%=cls%>" align=right>
		<%=KUtil.nchk(cm.totPriceKinds)%> <%=NumUtil.numToFmt(cm.totPrice,"###,###.##","0")%>&nbsp;</td>
		
	<td width=110 class="<%=cls%>" align=right>
		<%=KUtil.nchk(cm.comPriceKinds)%> <%=NumUtil.numToFmt(cm.comPrice,"###,###.##","0")%>&nbsp;</td>

	<td width=40 class="<%=cls%>"><%=cm.rate==0?"-":NumUtil.numToFmt(cm.rate,"###,###.##","0")%></td>

	<td width=50 class="<%=cls%>"><%=KUtil.dateMode(cm.invoDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	
	<td width=25 class="<%=cls%>">
		<%	if( KUtil.nchk(cm.afile).length() > 0 ){	%>
					<A HREF="javascript:;" onclick="filesCreateLink(-150,0,<%=i%>)">
						<IMG SRC="/images/icon/disk.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A>
					<textarea name="filesLink<%=i%>" style="display:none">
						<%=FileCtl.fileViewLink(cm.afile,"",cm.seq,"commission","<br>",0)%></textarea>
		<%		}else{
					out.println("&nbsp;");
				}	%></td>

	<td width=50 class="<%=cls%>"><%=KUtil.dateMode(cm.payDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
</tr>
<tr style="display:none;" id="id_<%=i%>" height="50">
	<td colspan=15 style="border:1 solid #FF0000"><iframe name="ifm_<%=i%>" id="ifm_<%=i%>" width="100%" height="200" frameborder="0"></iframe></td>
</tr>
<%	}//for	%>

<%	if( vecSum != null ){		%>
<tr align=right height=25>
	<td class=menu1 colspan=4>합계</td>
	
	<td class=menu1>
		<%	for( int i=0 ; i<vecSum[0].size() ; i++ ){	
				PoSum psm = (PoSum)vecSum[0].get(i);	%>
			<div><%=KUtil.nchk(psm.priceKinds)%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
	<td class=menu1>
		<%	for( int i=0 ; i<vecSum[1].size() ; i++ ){	
				PoSum psm = (PoSum)vecSum[1].get(i);	%>
			<div><%=KUtil.nchk(psm.priceKinds)%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</div>
		<%	}	%></td>
	<td class=menu1 colspan=4>&nbsp;</td>
</tr>
<%	}	%>


<%	if( vecList.size() < 1 ){	%>
<tr align=center height=60 class="r_bg">
	<td colspan=15>데이타가 존재하지 않습니다.</td>
</tr>
<%	}	%>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr align=center>
	<td colspan=15 class="bmenu">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td><%=indicator%></td>
			<td align=right>
				<input type="button" onclick="addComm()" value="추가" class="inputbox2"></td>
		</tr>
		</table></td>
</tr>
</form>
</table>







<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>

<iframe id="clientUser" width="0" height="0"></iframe>

</BODY>
</HTML>

<jsp:include page="/inc/inc_print.jsp" flush="true"/>


<%
	if( prn == 1 ){
		KUtil.scriptOut(out, "list_print_preview(1)");
	}
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
