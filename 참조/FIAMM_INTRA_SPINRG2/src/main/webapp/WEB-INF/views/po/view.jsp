<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="V"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	//request
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));
	
	//»ý¼ºÀÚ
	PoDAO poDAO = new PoDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	ProjectDAO pjDAO = new ProjectDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	UserDAO uDAO = new UserDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);
	PoItemDAO piDAO = new PoItemDAO(db);

	Po po = poDAO.selectOne(seq_po);
	Vector vecLink = lkDAO.selectOne(seq_po);
	Client cl = cDAO.selectOne(po.seq_client);
	ClientUser cu = cuDAO.selectOne(po.seq_clientUser);
%>

<jsp:include page="/inc/inc_loadingBar.jsp" flush="true"/>

<HTML>
<HEAD>

<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function goList(){
	var frm = document.poViewForm;
	frm.action = "list.jsp";
	frm.submit();
}
function goMod(){
	var frm = document.poViewForm;
	frm.action = "mod.jsp";
	frm.submit();
}
function goDel(){
	var frm = document.poViewForm;
	if( !confirm("»èÁ¦ÇÏ½Ã°Ú½À´Ï±î?") ){
		return;
	}
	frm.action = "DBD.jsp";
	frm.submit();
}
function goPrint(seq_po){
	document.location = "printPo.jsp?seq_po="+seq_po;
}
function passView(){
	var lft = (screen.availWidth-720)/2
	var pop = window.open("/main/pass/view_index.jsp?seq_po=<%=seq_po%>","passView","top=0,scrollbars=1,height=600,width=720,left="+lft);
	pop.focus();
}
function lcView(){
	var lft = (screen.availWidth-720)/2
	var pop = window.open("/main/lc/view.jsp?seq_po=<%=seq_po%>","passView","top=0,scrollbars=1,height=200,width=720,left="+lft);
	pop.focus();
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">


<!------------------PO VIEW------------------------>
<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="poViewForm" method="post">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="sk" value="<%=sk%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="reload" value="<%=reload%>">

<tr height=20>
	<td colspan=2></td>
</tr>

</table>




<table cellpadding="0" cellspacing="0" border="0" width="700">

<tr height=25>
	<td style="padding:0 0 0 5" width="450" valign=top>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><B>To :</B> <%=cl.bizName%></td>
		</tr>
		<%	if( KUtil.nchk(cu.userName).length()>0 ){	%>
		<tr>
			<td><B>Atten :</B> <%=KUtil.nchk(cu.userName)%></td>
		</tr>
		<%	}	%>
		<%	if( KUtil.nchk(po.endUser).length()>0 ){	%>
		<tr>
			<td><B>End - User :</B> <%=po.endUser%></td>
		</tr>
		<%	}	%>
		</table></td>
	<td valign=top>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><B>Date :</B> <%=KUtil.chEngDate(po.wDate,"MMMM dd, yyyy")%></td>
		</tr>
		<tr>
			<td><B>No :</B> HB<%=KUtil.cutIntDate(po.poYear,2,4,2)%><%=KUtil.formatDigit(po.poNum)%><%=po.poNumIncre>0?"-"+po.poNumIncre:""%></td>
		</tr>
		</table></td>
</tr>
<tr height=1 bgcolor="#000000">
	<td colspan=2></td>
</tr>
<tr height=1>
	<td colspan=2></td>
</tr>
<tr height=1 bgcolor="#000000">
	<td colspan=2></td>
</tr>
<tr height=7>
	<td></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height=25 valign=top>
	<td width=160><B>TIME OF DELIVERY</B></td>
	<td width=10><B>:</B></td>
	<td><%=KUtil.toTextMode(po.timeDeli,"&nbsp;")%></td>
</tr>
<tr height=25 valign=top>
	<td><B>TERMS OF DELIVERY</B></td>
	<td width=10><B>:</B></td>
	<td><%=KUtil.toTextMode(po.termDeli,"&nbsp;")%></td>
</tr>
<tr height=25 valign=top>
	<td><B>TERM OF PAYMENT</B></td>
	<td width=10><B>:</B></td>
	<td><%=KUtil.toTextMode(po.termPay,"&nbsp;")%></td>
</tr>
<tr height=25 valign=top>
	<td><B>PACKING</B></td>
	<td width=10><B>:</B></td>
	<td><%=KUtil.toTextMode(po.packing,"&nbsp;")%></td>
</tr>
<tr height=25 valign=top>
	<td><B>REMARKS</B></td>
	<td width=10><B>:</B></td>
	<td><%=KUtil.toTextMode(po.remarks,"&nbsp;")%></td>
</tr>
</table>



<!------------------Ç°¸ñ------------------------>
<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr class="title_bg" height=25>
	<td colspan=5>&nbsp;
		<B>PO ÐÝäþ :</B> <%=po.priceKinds%> <%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","0")%></td>
</tr>
<tr align=center class="title_bg" height=25>
	<td width="200">ù¡ Ù£</td>
	<td width="200">Ð® Ì«</td>
	<td width="90">â¦ Õá</td>
	<td width="100">Ó¤ Ê¤</td>
	<td width="110">ÐÝ äþ</td>
</tr>
<tr height=25>
	<td colspan=5 class="r_bg">&nbsp;<%=po.title%></td>
</tr>
</table>
<!-- insert Å×ÀÌºí -->
<table cellpadding="0" cellspacing="1" border="0" width="700" name="insertTable" id="insertTable">
<%	double reTotPrice = 0;
	Vector vecPoItemList = piDAO.getList(po.seq);		
	for( int i=0 ; i<vecPoItemList.size() ; i++ ){	 
		PoItem pi = (PoItem)vecPoItemList.get(i);
		reTotPrice += pi.totPrice;
%>
<tr align=center class="r_bg" height=25>
	<td width="200">
		<div><%=pi.itemName%></div>
		<%	if( KUtil.nchk(pi.itemNameMemo).length() > 0 ){	%>
		<div><%=KUtil.toTextMode(pi.itemNameMemo)%></div>
		<%	}	%></td>
	<td width="200">
		<div><%=pi.itemDim%></div>
		<%	if( KUtil.nchk(pi.itemDimMemo).length() > 0 ){	%>
		<div><%=KUtil.toTextMode(pi.itemDimMemo)%></div>
		<%	}	%></td>
	<td width="90"><%=KUtil.intToCom(pi.cnt)%></td>
	<td width="100"><%=po.priceKinds%> <%=NumUtil.numToFmt(pi.unitPrice,"###,###.##","0")%></td>
	<td width="110"><%=po.priceKinds%> <%=NumUtil.numToFmt(pi.totPrice,"###,###.##","0")%></td>
</tr>
<%	}//for	%>
</table>


<!-- total -->
<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr align=center height=25>
	<td width="200" class="title_bg">ÍêÐåÊ¤äþ</td>
	<td width="390" class="r_bg">&nbsp;</td>
	<td width="110" class="title_bg"><%=po.priceKinds%> <%=NumUtil.numToFmt(reTotPrice,"###,###.##","0")%></td>
</tr>
<tr align=center height=25>
	<td class="title_bg">Ý¾Ê¥Ê¤ö·áª</td>
	<td class="r_bg">&nbsp;</td>
	<td class="title_bg" <%=po.taxPrice<1?"":"align=right"%>>
		<%	if( po.taxPrice<1 ){
			out.print("Ü¬&nbsp;&nbsp;&nbsp;&nbsp;Ô²");
		}else{
			out.print(po.priceKinds); out.print(NumUtil.numToFmt(po.taxPrice,"###,###.##","0")); out.print("&nbsp;");
		}%></td>
</tr>
<tr align=center height=25>
	<td class="title_bg">ùê Íª</td>
	<td class="r_bg">&nbsp;</td>
	<td class="title_bg"><%=po.priceKinds%> <%=NumUtil.numToFmt(reTotPrice+po.taxPrice,"###,###.##","0")%></td>
</tr>
</table>
<!-------------------- Ç°¸ñ Á¾·á ----------------->


<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=25>
	<td colspan=4 class="ti1"> ¢º ºÎ°¡Á¤º¸</td>
</tr>
<tr height=25>
	<td colspan=4 class="bgc1"><B>PO Title :</B> <%=po.title%></td>
</tr>
<tr height=25>
	<td colspan=4>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="border: 1px solid #408080;">
	<tr>
		<td class="bk2_1"><B>PO °ü·Ã ÇÁ·ÎÁ§Æ® ¹× °ßÀû¼­</B></td>
	</tr>
	<tr>
		<td style="padding:0 0 0 25">
			<%	for( int i=0 ; i<vecLink.size() ; i++ ){	
					Link lk = (Link)vecLink.get(i);
					Project pj = pjDAO.selectOne(lk.seq_project);
					Contract ct = ctDAO.selectOne(lk.seq_contract);	%>
				<%=i>0?"<br>":""%> ¡Þ <%=pj.name%> / <%=ct.title%>
			<%	}//for	%></td>
	</tr>
	</table></td>
</tr>

<tr height=25>
	<td class="bk1_1" width="100" align=right><B>PO ´ã´çÀÚ :</B></td>
	<td class="bk2_1" width="250"><%=KUtil.nchk(uDAO.getUserName(po.poUserId))%></td>
	<td class="bk1_1" width="100" align=right><B>³³Ç° ¿¹Á¤ÀÏ :</B></td>
	<td class="bk2_1" width="250"><%=KUtil.toDateViewMode(po.setupGuessDate)%>&nbsp;</td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right><B>PO ±¸ºÐ :</B></td>
	<td class="bk2_1"><%=po.inOut%></td>
	<td class="bk1_1" align=right><B>ÅëÈ­±¸ºÐ :</B></td>
	<td class="bk2_1"><%=po.priceKinds%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right><B>PO ½ÅÃ»ÀÏ :</B></td>
	<td class="bk2_1"><%=KUtil.toDateViewMode(po.poDate)%></td>
	<td class="bk1_1" align=right><B>ÇÏÀÚº¸Áõ±â°£ :</B></td>
	<td class="bk2_1"><%=KUtil.toDateViewMode(po.warrant)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right><B>°áÁ¦Á¶°Ç :</B></td>
	<td class="bk2_1"><%=KUtil.nchk(po.payRes)%></td>
	<td class="bk1_1" align=right><B>PO È®ÀÎ¿©ºÎ :</B></td>
	<td class="bk2_1"><%=KUtil.nchk(po.isPo)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right><B>Shipper :</B></td>
	<td class="bk2_1"><%=KUtil.nchk(po.shipperName)%></td>
	<td class="bk1_1" align=right><B>Forwarder :</B></td>
	<td class="bk2_1"><%=KUtil.nchk(po.forwarder)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right><B>Term Á¶°Ç :</B></td>
	<td class="bk2_1"><%=KUtil.nchk(po.termRes)%></td>
	<td class="bk1_1" align=right><B>BL ¹øÈ£ :</B></td>
	<td class="bk2_1"><%=KUtil.nchk(po.blNum)%></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height=25>
	<td class="bk1_1" align=right><B>Ã·ºÎÆÄÀÏ</B></td>
	<td class="bk2_1"><%=KUtil.fileViewLink(po.fileName)%>&nbsp;</td>
</tr>
<tr height=50 valign=top>
	<td class="bk1_bg" align=right width="100"><B>±âÅ¸ »çÇ×</B></td>
	<td style="padding:5 5 5 5"><%=KUtil.nchk(po.setupDim,"&nbsp;")%></td>
</tr>
</table>

<br>




<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=2 class="bgc2">
	<td></td>
</tr>
<tr align=center height=25 class="bgc1">
	<td><input type="button" value="POÀÎ¼â" onclick="goPrint('<%=po.seq%>')">
		<input type="button" value="Åë°üÁ¤º¸" onclick="passView()">
		<input type="button" value="L/CÁ¤º¸" onclick="lcView()">
		<input type="button" value="¸®½ºÆ®" onclick="goList()">
		<input type="button" value="¼öÁ¤" onclick="goMod()">
		<input type="button" value="»èÁ¦" onclick="goDel()">
		</td>
</tr>
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
