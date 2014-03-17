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
	
	//생성자
	PoDAO poDAO = new PoDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	ProjectDAO pjDAO = new ProjectDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	UserDAO uDAO = new UserDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);
	PoItemDAO piDAO = new PoItemDAO(db);
	CompanyDAO coDAO = new CompanyDAO(db);

	Po po = poDAO.selectOne(seq_po);
	
	if( po.language.equals("KOR") ){
		KUtil.scriptMove(out,"printPo_kor.jsp?seq_po="+seq_po);
	}

	Vector vecLink = lkDAO.selectOne(seq_po);
	Client cl = cDAO.selectOne(po.seq_client);
	String[] clientUser = cuDAO.getList(po.seq_clientUser);
	
	Company co = coDAO.getCompany(po.poKind);
	
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script2.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/move.js"></SCRIPT>
<script  language="javascript">
function print_preview(){
	var left_margin		= 12.0;
	var right_margin	= 1.0;
	var top_margin		= 10.0;
	var bottom_margin	= 1.0;
	if(factory.printing){
		/*if( factory.printing.GetMarginMeasure() > 1 ){	//1 = mm ; 2 == inch
			var left_margin		= 0.5;
			var right_margin	= 0.1;
			var top_margin		= 0.4;
			var bottom_margin	= 0.1; 
		}*/
		factory.printing.header		= "";
		factory.printing.footer		= "";
		factory.printing.portrait	= true;
		factory.printing.leftMargin		= left_margin;
		factory.printing.topMargin		= top_margin;
		factory.printing.rightMargin	= right_margin;
		factory.printing.bottomMargin	= bottom_margin;
		fullsize();
		show1('noprint','none');
		var templateSupported = factory.printing.IsTemplateSupported();
		if( templateSupported  ){
			factory.printing.Preview();
		}
		resize(730,730);
		show1('noprint','block');
	}else{
		alert("ActiveX Print 프로그램을 설치하십시요!");
		return;
	}
	
}
function modPoMove(){
	document.location = "mod.jsp?seq_po=<%=seq_po%>";
}
function cancelPo(){
	var pop = window.open("cancel_po.jsp?seq_po=<%=seq_po%>","cancelpo","scrollbars=0,resizable=0");
}
</script>
<style>
@media all{
	.s_001{
		font-size:12px;
		font-weight:700;
		font-family: Arial;
	}
	.s_002{
		font-size:14px;
		font-weight:bold;
		font-family: Arial;
	}
	.s_003{
		font-size:14px;
		font-weight:400;
		font-family: Arial;
	}
	.s_004{
		font-weight:700;
		font-size:14px;
		font-family: Arial;
	}
	.s_005{
		font-size:13px;
		font-weight:400;
	}
	.s_006{
		font-weight:700;
		font-size:14px;
	}
	
	.s_007{
		font-weight:700;
		font-family:Arial, sans-serif;
		font-size:18px;
	}
}
</style>
</HEAD>
<BODY>
<table cellpadding="0" cellspacing="0" border="0" width="700" height="960">
<tr>
	<td valign=top>

	<!------------------PO VIEW------------------------>
	<table cellpadding="0" cellspacing="0" border="0" width="700">
	<form name="poViewForm" method="post">
	<input type="hidden" name="seq_po" value="<%=seq_po%>">
	<tr height=25>
		<td valign=top width="350" style="padding:0 10 0 10;padding-top:10px;" class="s_007"><%if("HB".equals(po.poKind)){ %><IMG SRC="/images/logo/logo_hanbul_eng.png" BORDER="0" ALT=""><%}else{ %><IMG SRC="/images/logo/<%=co.logo %>" BORDER="0" ALT=""><%} %></td>
		<td valign=top style="padding-left:0" align=right>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td class="s_001"><%=co.addr1_eng %></td>
			</tr>
			<tr>
				<td class="s_001"><%=co.addr2_eng %>, <%=co.addr3_eng %></td>
			</tr>
			<tr>
				<td class="s_001">TEL : <%=co.tel %>    FAX :  <%=co.fax%></td>
			</tr>
			<tr>
				<td class="s_001">E-mail : <%=co.email%></td>
			</tr>
			</table></td>
	</tr>
	<tr height=2 bgcolor="#000000">
		<td colspan=2></td>
	</tr>
	<tr align=center height="50">
		<td colspan=2 style="line-height:50px;font-style:italic"><B><FONT SIZE="6">PURCHASE ORDER</FONT></B></td>
	</tr>
	<tr height=2 bgcolor="#000000">
		<td colspan=2></td>
	</tr>
	</table>


	<table cellpadding="0" cellspacing="0" border="0" width="700">
	<tr height=10>
		<td></td>
	</tr>
	<tr height=25>
		<td style="padding:0 0 0 5" width="450" valign=top>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="cursor:hand" onclick="show('id_pname')">
					<FONT class=s_002>To :</FONT>
					<FONT class=s_003><%=cDAO.getBizName(cl,"ENG")%></FONT></td>
			</tr>
			<tr id="id_pname">
				<td>
					<FONT class=s_002>Project Name :</FONT> 
					<FONT class=s_003><%=KUtil.nchk(po.title,"&nbsp;")%></FONT></td>
			</tr>
			<%	if( KUtil.nchk(clientUser[1]).length()>0 ){	%>
			<tr>
				<td><FONT class=s_002>Atten :</FONT> <FONT class=s_003><%=KUtil.nchk(clientUser[1])%></FONT></td>
			</tr>
			<%	}	%>
			<%	if( KUtil.nchk(po.endUser).length()>0 ){	%>
			<tr style="display:none">
				<td><FONT class=s_002>End - User :</FONT> <FONT class=s_003><%=po.endUser%></FONT></td>
			</tr>
			<%	}	%>
			</table></td>
		<td valign=top>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><FONT class=s_002>Date :</FONT> <FONT class=s_003><%=KUtil.chEngDate(po.wDate,"MMMM dd, yyyy")%></FONT></td>
			</tr>
			<tr>
				<td><FONT class=s_002>No :</FONT> <FONT class=s_003><%=po.poKind%><%=poDAO.getPoNo(po)%></FONT></td>
			</tr>
			</table></td>
	</tr>
	<tr height=10>
		<td></td>
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
	<tr height=20 valign=top>
		<td width=160><FONT class=s_002>TIME OF DELIVERY</FONT></td>
		<td width=10><FONT class=s_002>:</FONT></td>
		<td class=s_003><%=KUtil.toTextMode(po.timeDeli,"&nbsp;")%></td>
	</tr>
	<tr height=20 valign=top>
		<td width=160><FONT class=s_002>PLACE OF DELIVERY</FONT></td>
		<td width=10><FONT class=s_002>:</FONT></td>
		<td class=s_003><%=KUtil.toTextMode(po.termDeli)%>
		<%	if( KUtil.nchk(po.termDeliMemo).length() > 0 ){%>
			<%=KUtil.toTextMode(po.termDeliMemo)%>
		<%	}	%></td>
	</tr>
	<tr height=20 valign=top>
		<td width=160><FONT class=s_002>TERM OF PAYMENT</FONT></td>
		<td width=10><FONT class=s_002>:</FONT></td>
		<td class=s_003><%=KUtil.toTextMode(po.termPay)%>
		<%	if( KUtil.nchk(po.termPayMemo).length() > 0 ){%>
			<%=KUtil.toTextMode(po.termPayMemo)%>
		<%	}	%></td>
	</tr>
	<tr height=20 valign=top>
		<td width=160><FONT class=s_002>PACKING</FONT></td>
		<td width=10><FONT class=s_002>:</FONT></td>
		<td class=s_003><%=KUtil.toTextMode(po.packing,"&nbsp;")%></td>
	</tr>
	<tr height=20 valign=top>
		<td width=160><FONT class=s_002>REMARKS</FONT></td>
		<td width=10><FONT class=s_002>:</FONT></td>
		<td class=s_003><%=KUtil.toTextMode(po.remarks,"&nbsp;")%></td>
	</tr>
	<tr height=20>
		<td colspan=3>&nbsp;</td>
	</tr>
	</table>

	<!------------------품목------------------------>
	<table cellpadding="0" cellspacing="0" border="0" width="700">
	<tr align=center height=28 onclick="show('id_title')" style="cursor:hand" bgcolor="#f4f7f7">
		<td width="100" class="AllLineBold2"><FONT class=s_004>ITEM NO.</FONT></td>
		<td width="390" class="RTBLineBold2"><FONT class=s_004>DESCRIPTION</FONT></td>
		<td width="100" class="RTBLineBold2"><FONT class=s_004>Q'TY</FONT></td>
		<td width="110" class="RTBLineBold2"><FONT class=s_004>AMOUNT</FONT></td>
	</tr>
	<%	int height = 0;
		Vector vecPoItemList = piDAO.getList(po.seq);		
		for( int i=0 ; i<vecPoItemList.size() ; i++ ){	 
			PoItem pi = (PoItem)vecPoItemList.get(i);
			height += 25;			%>
	<tr align=center height=25>
		<td class="LRBline"><%=i+1%></td>
		<td class="RBLine" align=left>
			<div class=s_005>&nbsp;<%=KUtil.toTextMode(pi.itemName)%></div>
			
			<%	if( KUtil.nchk(pi.itemNameMemo).length() > 0 ){	
					height += 25;%>
			<div class=s_005>&nbsp;<%=KUtil.toTextMode(pi.itemNameMemo)%></div>
			<%	}	%>
			
			<%	if( KUtil.nchk(pi.itemDimMemo).length() > 0 ){	
					height += 25;%>
			<div class=s_005>&nbsp;<%=KUtil.toTextMode(pi.itemDimMemo)%></div>
			<%	}	%></td>
		<td class="RBLine">
			<FONT class=s_005><%=KUtil.intToCom(pi.cnt)%> <%=KUtil.nchk(pi.itemUnit)%></font></td>
		<td class="RBLine" align=right>
			<FONT class=s_005><%=po.priceKinds%> <%=NumUtil.numToFmt(pi.totPrice,"###,###.##","0")%>&nbsp;</FONT></td>
	</tr>
	<%	}//for	%>
	<%	if( height < 100 ){	
			height = 150-height;		%>
		<tr valign=top align=center height="<%=height%>">
			<td class="LRBline">&nbsp</td>
			<td class="RBLine">&nbsp;</td>
			<td class="RBLine">&nbsp</td>
			<td class="RBLine">&nbsp</td>
		</tr>
	<%	}//if	%>
	<tr bgcolor="#f4f7f7" height=28 align=center>
			<td colspan=2 class="LRBline"><FONT class=s_004>TOTAL</FONT></td>
			<td colspan=2 class="RBline" align=center>
				<FONT class=s_006><%=po.priceKinds%> <%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","0")%>&nbsp;</FONT></td>
	</tr>
	</table>
	<!-------------------- 품목 종료 ----------------->
	</td>
</tr>

<tr height=160>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="700" valign=bottom>
	<tr align=center height="40">
		<td width="350"><font style="font-size: 15px;font-family:'바탕';font-weight: bolder;"><%=co.name_eng %></font></td>
		<td width="350"><font style="font-size: 15px;font-family:'바탕';font-weight: bolder;">SUPPLIER'S<br>ACKNOWLEDGEMENT</Font></td>
	</tr>
	<tr height="110">
		<td align=center>
			<div style="position:absolute;left:290;z-index:1" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" ondblclick="this.style.display='none';">
				<table cellpadding="0" cellspacing="0" border="0" >
				<tr height="80" valign=middle>
					<td align=right><IMG SRC="/images/logo/<%=co.dojang %>" BORDER="0" ALT=""></td>
				</tr>
				</table></div>
			<div style="z-index:0" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" ondblclick="this.style.display='none';" id="id_jitin"><IMG SRC="/images/logo/<%=co.jikin_eng %>"  BORDER="0" ALT="" align=absmiddle></div></td>
		<td>&nbsp;</td>
	</tr>
	<tr valign=bottom>
		<td style="padding:0 20 0 20"><hr></td>
		<td style="padding:0 20 0 20"><hr></td>
	</tr>
	</table></td>
</tr>
</form>
</table>

<%	if( po.eff != -1 ){	%>
<table cellpadding="0" cellspacing="0" border="0" width="700" id="noprint" style="display:block">
<tr align=center height=50 valign=bottom>
	<td colspan=2>
		<input type="button" value="프린트" onclick="print_preview();" class="inputbox2">
		<input type="button" value="수정" onclick="modPoMove();" class="inputbox2">
		<input type="button" value="PO취소" onclick="cancelPo();" class="inputbox2">
		<input type="button" value="닫기" onclick="self.close()" class="inputbox2"></td>
</tr>
</table>
<%	}	%>
</BODY>
</HTML>



<%	if( po.eff == -1 ){	%>
		<div style="position:absolute;left:140;top:100;z-index:0" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );">
			<table cellpadding="0" cellspacing="0" border="0" width="393" height="107">
			<tr>
				<td><IMG SRC="/images/cancel.gif" BORDER="0" ALT=""></td>
			</tr>
			<tr align=center>
				<td bgcolor="#990000"><font color=#ffffff>MEMO</font></td>
			</tr>
			<tr height="50">
				<td style="border:1 solid #CC0000" bgcolor="lightyellow">
					<%=KUtil.nchk(po.eventMsg)%></td>
			</tr>
			</table></div>
<%	}
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>

<SCRIPT LANGUAGE="JavaScript">
resize(740,700);
</SCRIPT>

<OBJECT id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814"
	viewastext codebase="/printx/ScriptX.cab#Version=6,1,428,11">
</OBJECT>