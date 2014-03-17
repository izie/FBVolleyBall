<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="estimate"/>
	<jsp:param name="col" value="V"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>


<%
	Database db = new Database();
try{ 
	int seq = KUtil.nchkToInt(request.getParameter("seq"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));

	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	EstimateDAO emDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);
	CompanyDAO coDAO = new CompanyDAO(db);

	Estimate em = emDAO.selectOne(seq);
	Vector vecEstItem = eiDAO.getList(seq);
	Client cl = cDAO.selectOne(em.seq_client);
	
	Company co = coDAO.getCompany(em.estKind);
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script2.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/move.js"></SCRIPT>
<script language="javascript">
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
function goModify(){
	document.location = "eng_mod.jsp?seq=<%=seq%>&reload=<%=reload%>";
}
function goDelete(){
	if( confirm("삭제하시겠습니까?") ){
		document.location = "DBD.jsp?seq=<%=seq%>&reload=<%=reload%>";
	}
}
//onbeforeprint="printSetup()" onafterprint="printSetup1()"
</script>
<style>
@media all{
	.s_001{	
		font-weight:700;
		font-family:Arial, sans-serif;
		font-size:18px;
	}
	.s_002{
		font-weight:bold;
		font-size:16px;
	}
	.s_003{
		font-weight:bold;
		font-size:15px;
		text-decoration:underline;
	}
	.s_004{
		font-weight:normal;
		font-size:14px;
	}
	.s_005{
		font-weight:700;
		font-size:14px;
	}
	.s_006{
		font-weight:400;
		font-size:13px;
	}
	.s_007{
		font-weight:700;
		font-size:17px;
		font-family:Arial, sans-serif;
	}
}
</style>
</HEAD>

<BODY>

<table cellpadding="0" cellspacing="0" border="0" width="700" height="980">
<tr>
	<td valign=top>

	<table cellpadding="0" cellspacing="0" border="0" width="100%">

	<form name="estimateViewForm" method="post">
	<input type="hidden" name="seq" value="<%=seq%>">
	<input type="hidden" name="reload" value="<%=reload%>">

	<tr align=center>
		<td colspan=2>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><IMG SRC="/images/logo/<%=co.logo %>" BORDER="0" ALT="" align=absmiddle></td>
				<td valign=middle style="line-height:35px" class=s_001>&nbsp;<%=co.name_eng %> CO.,LTD.</td>
			</tr>
			</table></td>
	</tr>
	<tr height=5>
		<td colspan=2 class="bk_line"><IMG SRC="/images/blank.gif" WIDTH="1" HEIGHT="1" BORDER="0" ALT=""></td>
	</tr>
	<tr>
		<td valign=top style="padding-top:5px">
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="line-height:15px"><%=co.addr1_eng %></td>
			</tr>
			<tr>
				<td style="line-height:15px"><%=co.addr2_eng %></td>
			</tr>
			<tr>
				<td style="line-height:15px"><%=co.addr3_eng %></td>
			</tr>
			</table></td>
		<td align=right valign=top style="padding-top:5px">
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="line-height:15px">TEL : <%=co.tel %></td>
			</tr>
			<tr>
				<td style="line-height:15px">FAX : <%=co.fax %></td>
			</tr>
			<tr>
				<td style="line-height:15px">E-mail : <%=co.email %></td>
			</tr>
			</table></td>
	</tr>
	<tr height="40">
		<td colspan=2>&nbsp;</td>
	</tr>
	<tr>
		<td valign=top colspan=2>
			<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
			<tr>
				<td valign=top><table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td onclick="show('id_project')" style="cursor:hand;">
							<FONT class="s_002">Customer : <%=cDAO.getBizName(cl,"ENG")%></FONT></td>
					</tr>
					<tr style="display:none;" id="id_project">
						<td>
							<FONT class="s_003">Project : <%=pDAO.selectOne(em.seq_project).name%></FONT></td>
					</tr>
					</table></td>
				<td align=right style="padding-right:3" width="180">
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<tr>
						<td class="s_004">Date : <%=KUtil.dateMode(em.wDate,"yyyyMMdd","MMMM dd, yyyy", "en" ,"&nbsp;")%></td>
					</tr>
					<tr>
						<td class="s_004">Offer No. : <%=emDAO.getEstNo(em)%></td>
					</tr>
					</table></td>
			</tr>
			</table></td>
	</tr>

	<tr align=center height=55>
		<td colspan=2 style="line-height:40px"><B><U style="font-family:'굴림';font-size:23px;LETTER-SPACING:1">Quotation</U></B></td>
	</tr>
	<tr>
		<td colspan=2>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=2>&nbsp;We are pleased to offer you the undermentioned article(s) as per conditions and details described as follows :</td>
	</tr>
	<tr height=6>
		<td colspan=2></td>
	</tr>
	<!-- <tr>
		<td colspan=2><%=KUtil.nchk(em.isUnit).equals("개별견적")?"(개별견적)":""%></td>
	</tr> -->
	<tr height=28 id="id_title" style="display:none">
		<td colspan=2>&nbsp;<%=KUtil.nchk(em.title)%></td>
	</tr>
	<tr>
		<td colspan=2>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr align=center height=28 onclick="show('id_title')" style="cursor:hand" bgcolor="#F4F7F7">
				<td width="30" class="AllLineBold2"><FONT class="s_005">No</FONT></td>
				<td width="300" class="RTBLineBold2"><FONT class="s_005">Commodity & Description</FONT></td>
				<td width="70" class="RTBLineBold2"><FONT class="s_005">Unit</FONT></td>
				<td width="70" class="RTBLineBold2"><FONT class="s_005">Q'ty</FONT></td>
				<td width="110" class="RTBLineBold2"><FONT class="s_005">Unit price</FONT></td>
				<td width="120" class="RTBLineBold2"><FONT class="s_005">Amount</FONT></td>
			</tr>
		<%	long reTotPrice = 0;
			int height = 0;
			for( int i=0 ; i<vecEstItem.size() ; i++ ){	
				EstItem ei = (EstItem)vecEstItem.get(i);
					reTotPrice += ei.totPrice;
					int len = KUtil.nchk(ei.itemNameMemo).length();
					height += 25;
		%>
			<tr align=center height=25>
				<td class="LRBline3" align=center <%=len>0?"rowspan=2":""%>>
					<div class=s_006>&nbsp;<%=i+1+""%></div></td>
				<td class="RBLine" align=left>
					<div class=s_006>&nbsp;<%=KUtil.toTextMode(ei.itemName,"&nbsp;")%> <%=KUtil.toTextMode(ei.itemDim,"&nbsp;")%></div></td>
				<td class="RBLine" align=center>
					<div class=s_006><%=KUtil.nchk(ei.itemUnit)%></div></td>
				<td class="RBLine" align=center>
					<div class=s_006><%=KUtil.intToCom(ei.cnt)%>&nbsp;</div></td>
				<td class="RBLine" align=right>
					<div class=s_006><%=ei.unitPrice>0?NumUtil.numToFmt(ei.unitPrice,"###,###.##","0"):"&nbsp;"%>&nbsp;</div></td>
				<td class="RBLine" align=right>
					<div class=s_006><%=NumUtil.numToFmt(new Double(ei.totPrice),"###,###.##","0")%>&nbsp;</div></td>
			</tr>
		<%	if(len>0){	
				height += 25;			%>
			<tr height=25>
				<td colspan=5 class="RBLine2">
						<div class=s_006>&nbsp;<%=KUtil.toTextMode(ei.itemNameMemo)%></div>
					<%	if(KUtil.nchk(ei.itemDimMemo).length()>0){	%>
						<div class=s_006>&nbsp;<%=KUtil.toTextMode(ei.itemDimMemo)%></div>
					<%	}	%></td>
		<%	}	%>
			</tr>
		<%	}//for					%>
			
		<%	if( height < 100 ){	
				height = 150-height;		%>	
			<tr valign=top align=center height="<%=height%>">
				<td class="LRBline">&nbsp</td>
				<td class="RBLine">&nbsp;</td>
				<td class="RBLine">&nbsp;</td>
				<td class="RBLine">&nbsp</td>
				<td class="RBLine">&nbsp</td>
				<td class="RBLine">&nbsp</td>
			</tr>
		<%	}	%>
			<tr align=center height=28>
				<td class="LRBline">&nbsp;</td>
				<td class="RBline"><FONT CLASS=s_007>T O T A L</FONT></td>
				<td class="RBline">&nbsp;</td>
				<td class="RBline">&nbsp;</td>
				<td class="RBline"><%=KUtil.nchk(em.estComt).equals("")?"&nbsp;":KUtil.toTextMode(em.estComt)%></td>
				<td class="RBline" align=right>
					<div class=s_006><%=em.priceKinds%> <%=NumUtil.numToFmt(em.totPrice,"###,###.##","0")%>&nbsp;</div></td>
			</tr>
			</table></td>
	</tr>
	<tr height=25>
		<td colspan=2>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr height=10>
				<td colspan=2></td>
			</tr>
			<tr valign=top>
				<td colspan=2 style="padding:3 3 3 3"><%=KUtil.nchk(em.memo)%></td>
			</tr>
			</table></td>
	</tr>
	</table></td>
</tr>


<tr height=20>
	<td colspan=2>&nbsp;</td>
</tr>
<tr height=200>
	<td valign=top>
	<table cellpadding="0" cellspacing="0" border="0" width="700">
	<tr height=20>
		<td colspan=2>We are looking forward to your valued order for the above offer; yours faithfully</td>
	</tr>
	<tr align=center height="20">
		<td width="350"><font style="font-size:17px;line-width:17px;font-family:'굴림';font-weight: bolder;">ACCEPTED BY</font></td>
		<td width="350"><font style="font-size:17px;line-width:17px;font-family:'굴림';font-weight: bolder;"><%=co.name_eng %> CO.,LTD.</Font></td>
	</tr>
	<tr height="110">
		<td align=center>&nbsp;</td>
		<td align=center><div style="top:850;left:400;" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" ondblclick="this.style.display='none';"><IMG SRC="/images/logo/<%=co.jikin_eng %>" WIDTH="250" BORDER="0" ALT=""></div></td>
	</tr>
	<tr valign=bottom>
		<td style="padding:0 20 0 20"><hr></td>
		<td style="padding:0 20 0 20"><hr></td>
	</tr>
	</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700" height="50">
<tr height="70" valign=bottom align=center id="noprint" style="display:block">
	<td colspan=2>
		<input type="button" value="프린트" onclick="print_preview();" class="inputbox2">
		<input type="button" value="수정" onclick="goModify()" class="inputbox2">
		<input type="button" value="닫기" onclick="self.close()" class="inputbox2"></td>
</tr>
</form>
</table>
<!-- 도장 -->
<div style="position:absolute;top:850;left:640" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" ondblclick="this.style.display='none';"><IMG SRC="/images/logo/<%=co.dojang %>" BORDER="0" ALT=""></div>

</BODY>
</HTML>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
<SCRIPT LANGUAGE="JavaScript">
resize(750,700);
</SCRIPT>
<!-- MeadCo ScriptX -->
<object id=factory style="display:none"
  classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814"
  codebase="/printx/smsx.cab#Version=6,6,440,26">
</object>
