
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
	var frm = document.poViewForm;
	frm.action = "kor_mod.jsp?seq_po=<%=seq_po%>";
	frm.submit();
}
function cancelPo(){
	var pop = window.open("cancel_po.jsp?seq_po=<%=seq_po%>","cancelpo","scrollbars=0,resizable=0");
}
</script>
<style>
@media all{
	.s_000{
		font-weight:700;
		font-family:Arial, sans-serif;
		font-size:18px;
	}
	.s_001{
		font-weight:normal;
		font-family:바탕,굴림, sans-serif;
		font-size:14px;
	}
	.s_002{
		cursor:hand;
		font-size:15px; 
		font-weight: bold;
		font-family:바탕,굴림, sans-serif;
	}
	.s_003{
		font-size:13px;
		font-family:바탕, serif;
	}
	.s_004{
		font-size:15.4px; 
		font-weight: bold;
		font-family:바탕,굴림, sans-serif;
	}
}
</style>
</HEAD>
<BODY>
<table cellpadding="0" cellspacing="0" border="0" width="700" height="960">
<tr>
	<td valign=top>

	<!------------------PO VIEW------------------------>
	<table cellpadding="0" cellspacing="1" border="0" width="700">
	<form name="poViewForm" method="post">
	<input type="hidden" name="seq_po" value="<%=seq_po%>">
	<tr height=25 align=center>
		<td valign=top colspan=2>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><IMG SRC="/images/logo/<%=co.logo %>"  BORDER="0" ALT="" align=absmiddle></td>
				<td valign=middle class="s_000">&nbsp;<%=co.name_eng %> CO.,LTD.</td>
			</tr>
			</table></td>
	</tr>
	<tr height=10>
		<td colspan=2></td>
	</tr>
	<tr height=2 bgcolor="#000000">
		<td colspan=2></td>
	</tr>
	<tr height=5>
		<td colspan=2></td>
	</tr>
	<tr valign=top>
		<td>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="line-height:15px"><%=co.addr1_kor %></td>
			</tr>
			<tr>
				<td style="line-height:15px"><%=co.addr3_kor %> <%=co.addr2_kor %></td>
			</tr>
			<tr>
				<td style="line-height:15px"></td>
			</tr>
			</table></td>
		<td align=right>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="line-height:15px">TEL : <%=co.tel_kor %></td>
			</tr>
			<tr>
				<td style="line-height:15px">FAX : <%=co.fax_kor %></td>
			</tr>
			<tr>
				<td style="line-height:15px">E-mail : <%=co.email %></td>
			</tr>
			</table></td>
	</tr>
	<tr height=15>
		<td colspan=2></td>
	</tr>
	<tr align=center>
		<td colspan=2 style="line-height:35px;text-decoration: underline;">
			<FONT style="font-size:32px;font-family:돋움,굴림,바탕;font-weight:bolder;">
			발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서</FONT></td>
	</tr>
	</table>


	<table cellpadding="0" cellspacing="0" border="0" width="700">
	<tr height=15>
		<td colspan=2></td>
	</tr>
	<tr height=25>
		<td style="padding:0 0 0 5" width="450" valign=top>&nbsp;</td>
		<td valign=top style="padding-left:35">
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td class=s_001>Date : <%=KUtil.chEngDate(po.wDate,"MMMM dd, yyyy")%></td>
			</tr>
			<tr>
				<td class=s_001>PO No. : HB<%=poDAO.getPoNo(po)%></td>
			</tr>
			</table></td>
	</tr>
	<tr height=25>
		<td style="padding:0 0 0 5" width="450" valign=top>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td onclick="show('id_pname')" class=s_002>
					TO : <%=cDAO.getBizName(cl,"KOR")%>
				<%	if( KUtil.nchk(clientUser[1]).length() > 0 ){
						out.print( " / "+KUtil.nchk(clientUser[1])+"님." );
					}else{
						out.print("귀중");
					}%></td>
			</tr>
			</table></td>
		<td valign=top>&nbsp;</td>
	</tr>
	<tr height=10>
		<td></td>
	</tr>
	</table>

	<table cellpadding="0" cellspacing="0" border="0" width="700">
	<tr height=20 valign=top>
		<td width=80 class="s_003">납 기</td>
		<td width=10 class="s_003">:</td>
		<td class="s_003"><%=KUtil.toTextMode(po.timeDeli,"&nbsp;")%></td>
	</tr>
	<tr height=20 valign=top>
		<td class="s_003">결 제 조 건</td>
		<td class="s_003">:</td>
		<td class="s_003"><%=KUtil.toTextMode(po.termPayMemo,"&nbsp;")%></td>
	</tr>
	<tr height=20 valign=top>
		<td class="s_003">납 품 조 건</td>
		<td class="s_003">:</td>
		<td class="s_003"><%=KUtil.toTextMode(po.termDeliMemo,"&nbsp;")%></td>
	</tr>
	<tr height=20>
		<td colspan=3>&nbsp;</td>
	</tr>
	</table>

	<!------------------품목------------------------>
	<table cellpadding="0" cellspacing="0" border="0" width="700">
	
	<tr height=28>
		<td colspan=5 class=s_002>
			PO 금액 : 일금 <%=NumUtil.strToKor(po.poTotPrice,"")%> 원정
			 (<%=po.priceKinds%> <%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","0")%>) </td>
	</tr>

	<tr align=center height=28  style="cursor:hand" bgcolor="#f4F7f7">
		<td width="40" class="AllLineBold2"><FONT class=s_004>No</FONT></td>
		<td width="440" class="RTBLineBold2"><FONT class=s_004>품&nbsp;&nbsp;&nbsp;&nbsp;명</FONT></td>
		<td width="80" class="RTBLineBold2"><FONT class=s_004>규&nbsp;&nbsp;&nbsp;&nbsp;격</FONT></td>
		<!-- <td width="110" class="RTBLineBold2"><B>UNIT PRICE</B></td> -->
		<td width="140" class="RTBLineBold2"><FONT class=s_004>금&nbsp;&nbsp;&nbsp;&nbsp;액</FONT></td>
	</tr>
	<%	int height = 0;
		double reTotPrice = 0;
		Vector vecPoItemList = piDAO.getList(po.seq);		
		for( int i=0 ; i<vecPoItemList.size() ; i++ ){	 
				PoItem pi = (PoItem)vecPoItemList.get(i);
				reTotPrice += pi.totPrice;
				height += 25;				
				int len = KUtil.nchk(pi.itemNameMemo).length();	%>
		<tr align=center height=25>
			<td class="LRBline3" <%=len>0?"rowspan=2":""%>>
				<div class=s_003><%=i+1%></div></td>
			<td class="RBLine" align=left>
				<div class=s_003>&nbsp;<%=KUtil.toTextMode(pi.itemName)%></div></td>
			<td class="RBLine">
				<div class=s_003><%=KUtil.intToCom(pi.cnt)%> <%=KUtil.nchk(pi.itemUnit)%></div></td>
			<td class="RBLine" align=right>
				<div class=s_003><%=po.priceKinds%> <%=NumUtil.numToFmt(pi.totPrice,"###,###.##","0")%>&nbsp;</div></td>
		</tr>
		<%	if(len>0){	
				height += 25;			%>
			<tr height=25>
				<td colspan=5 class="RBLine2">
						<div class=s_003>&nbsp;<%=KUtil.toTextMode(pi.itemNameMemo)%></div>
					<%	if(KUtil.nchk(pi.itemDimMemo).length()>0){	%>
						<div class=s_003>&nbsp;<%=KUtil.toTextMode(pi.itemDimMemo)%></div>
					<%	}	%></td>
		<%	}	%>
		<%	}//for	%>
	<%	if( height < 100 ){	
			height = 150-height;		%>
		<tr valign=top align=center height="<%=height%>">
			<td class="LRBline">&nbsp</td>
			<td class="RBLine"><FONT  class="s_003">- 이 하 여 백 -</FONT></td>
			<td class="RBLine">&nbsp</td>
			<td class="RBLine">&nbsp</td>
		</tr>
	<%	}//if	%>


		<tr align=center height=28 bgcolor="#F4F7F7">
			<td class="LRBline" colspan=3>
				<FONT class=s_003>공&nbsp;급&nbsp;가&nbsp;액</FONT></td>
			<td class="RBline" align=right>
				<FONT class="s_003"><%=po.priceKinds%> <%=NumUtil.numToFmt(reTotPrice,"###,###.##","0")%></FONT>&nbsp;</td>
		</tr>
		<tr align=center height=28 bgcolor="#F4F7F7">
			<td class="LRBline" colspan=3>
				<FONT class=s_003>부가가치세</FONT></td>
			<td class="RBline" <%=po.taxPrice>0?"align=right":""%> style="font-size:11.0pt;">
				<FONT class="s_003">
			<%	if( po.isTax == 1 ){
					out.print("별&nbsp;&nbsp;&nbsp;&nbsp;도");
				}else{
					out.print(po.priceKinds); out.print(NumUtil.numToFmt(po.taxPrice,"###,###.##","0"));
					out.print("&nbsp;");
				}%></FONT></td>
		</tr>
		<tr align=center height=28 bgcolor="#F4F7F7">
			<td class="LRBline" colspan=3>
				<FONT class=s_003>합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계</FONT></td>
			<td class="RBline" align=right>
				<FONT class="s_003"><%=po.priceKinds%> <%=NumUtil.numToFmt(reTotPrice+po.taxPrice,"###,###.##","0")%></FONT>&nbsp;</td>
		</tr>
		</table>
	<!-------------------- 품목 종료 ----------------->
	</td>
</tr>

<tr height=160>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="700" valign=bottom>
	<tr align=center height="40">
		<td width="350"><font style="font-size: 15px;font-family:'바탕';font-weight: bolder;"><%=co.name_eng %> CO.,LTD</font></td>
		<td width="350"><font style="font-size: 15px;font-family:'바탕';font-weight: bolder;">SUPPLIER'S<br>ACKNOWLEDGEMENT</Font></td>
	</tr>
	<tr height="110">
		<td align=center>
			<div style="position:absolute;left:280;z-index:1" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" ondblclick="this.style.display='none';">
				<table cellpadding="0" cellspacing="0" border="0" >
				<tr height="80" valign=bottom>
					<td align=right><IMG SRC="/images/logo/<%=co.dojang %>" BORDER="0" ALT=""></td>
				</tr>
				</table></div>
			<div style="z-index:0" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" ondblclick="this.style.display='none';" id="id_jitin"><IMG SRC="/images/logo/<%=co.jikin_kor %>"  BORDER="0" ALT="" align=absmiddle></div></td>
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
<tr align=center>
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