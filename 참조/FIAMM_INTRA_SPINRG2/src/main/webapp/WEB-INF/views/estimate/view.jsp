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
	
	if( KUtil.nchk(em.language).equals("ENG") ){
		KUtil.scriptMove(out,"eng_view.jsp?seq="+seq+"&reload="+reload);		return;
	}

	Vector vecEstItem = eiDAO.getList(seq);
	Client cl = cDAO.selectOne(em.seq_client);
	
	Company co = coDAO.getCompany(em.estKind);
%>


<HTML>
<HEAD>
<title>�Ǿ��ڸ���</title>


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
		alert("ActiveX Print ���α׷��� ��ġ�Ͻʽÿ�!");
		return;
	}
	
	
}
function goModify(){
	document.location = "mod.jsp?seq=<%=seq%>&reload=<%=reload%>";
}
function goDelete(){
	if( confirm("�����Ͻðڽ��ϱ�?") ){
		document.location = "DBD.jsp?seq=<%=seq%>&reload=<%=reload%>";
	}
}
//onbeforeprint="printSetup()" onafterprint="printSetup1()"
</script>
<style>
@media all{
	.s_000{
		font-weight:700;
		font-family:Arial, sans-serif;
		font-size:18px;
	}
	.s_001{
		font-size:11.0pt;
		font-weight:normal;
		font-family:����, serif;
	}
	.s_002{
		font-size:14.0pt;
		font-weight:700;
		font-style:normal;
		text-decoration:none;
		font-family:����, serif;
	}
	.s_003{
		font-size:11.0pt;

		font-weight:700;
		font-style:normal;
		font-family:Arial;
	}
	.s_004{
		font-size:10.0pt;
		font-weight:400;
		font-style:normal;
		text-decoration:none;
		font-family:����, serif;
	}
	.s_005{
		font-size:11.0pt;
		font-weight:400;
		font-style:normal;
		text-decoration:none;
		font-family:����, serif;
	}
	.s_006{
		font-size:12.0pt;
		font-weight:bold;
		font-style:normal;
		font-family:����;
	}
	.s_007{
		font-size:11.0pt;
		font-weight:400;
		font-style:normal;
		font-family:����;
	}
	.s_008{
		font-size:10.0pt;
		font-weight:400;
		font-style:normal;
		font-family:����;
	}
	.s_009{
		font-size:10.0pt;
		font-weight:400;
		font-style:normal;
		text-decoration:none;
		font-family:����, serif;
		letter-spacing:-1
	}
	
	.s_010 b{
		font-size:12.0pt;
		font-weight:bold;
		font-family:����, serif;
	}
}

</style>
</HEAD>

<BODY>

<table cellpadding="0" cellspacing="0" border="0" width="700">
<form name="estimateViewForm" method="post">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="reload" value="<%=reload%>">

<tr align=center>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><IMG SRC="/images/logo/<%=co.logo %>" BORDER="0" ALT="" align=absmiddle></td>
			<td valign=middle class="s_000">&nbsp;<%=co.name_eng %> CO.,LTD.</td>
		</tr>
		</table></td>
</tr>
<tr height=5>
	<td colspan=2 class="bk_dot"><IMG SRC="/images/blank.gif" WIDTH="1" HEIGHT="1" BORDER="0" ALT=""></td>
</tr>
<tr valign=top style="padding-top:5">
	<td>
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
	<td align=right>
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
<tr align=center height=45 valign=middle>
	<td colspan=2 style='line-height:32px;font-family:����;font-weight:bold;font-size:30px;text-decoration:underline;'>��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</td>
</tr>
<tr>
	<td valign=top>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td class="s_006">
				<span onclick="show('id_project')" style="cursor:hand">
					<%=cDAO.getBizName(cl,"KOR")%></span> 
				<font class="s_007">����</font></td>
		</tr>
		<tr style="display:none;" id="id_project">
			<td><font class=s_001>Project Name: <%=pDAO.selectOne(em.seq_project).name%></font></td>
		</tr>
		<!-- <tr <%=em.seq_clientUser<1?"style='display:none'":""%>>
			<td>�� �� ��: <%=KUtil.nchk(cuDAO.selectOne(em.seq_clientUser).userName)%></td>
		</tr> -->
		</table></td>
	<td align=right valign=top>
		<table cellpadding="0" cellspacing="0" border="0" width="180">
		<tr>
			<td class=s_001>
				DATE : <%=KUtil.dateMode(em.wDate,"yyyyMMdd","yyyy. MM. dd","&nbsp;")%><br>
				������ NO. : <%=emDAO.getEstNo(em)%></td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2>&nbsp;</td>
</tr>
<tr>
	<td valign=top>
		<table cellpadding="0" cellspacing="0" border="0">
		<%	if( em.limitDate > 0 && em.limitDateOptFlag < 1 ){	%>
		<tr>
			<td class=s_001>
				��&nbsp;&nbsp;&nbsp;&nbsp;�� : 
                ������ <%=NumUtil.numToFmt(em.limitDate,"##.#","0")%> <%=KUtil.nchk(em.limitDateOpt)%></td>
		</tr>
		<%	} 
            if ( em.limitDateOptFlag > 0 ){    %>
        <tr>
			<td class=s_001>
				��&nbsp;&nbsp;&nbsp;&nbsp;�� : 
                <%=KUtil.nchk(em.limitDateOpt)%></td>
		</tr>
        <%  }
			if( KUtil.nchk(em.place).length() > 0 ){	%>
		<tr>
			<td class=s_001>�ε���� : <%=KUtil.nchk(em.place)%></td>
		</tr>
		<%	}//if	%>
		<tr>
			<td class=s_001>�������� : <%=KUtil.nchk(em.payKinds)%></td>
		</tr>
		<tr>
			<td class=s_001>���� ��ȿ�Ⱓ : <%=KUtil.intToCom(em.edDate)%> ��</td>
		</tr>
		</table></td>
	<td align=right valign=top>
		<table cellpadding="0" cellspacing="0" border="0" width="210">
		<tr align=left>
			<td class=s_002><%=co.name_kor %> �ֽ�ȸ��</td>
		</tr>
		<tr>
			<td class=s_003><%=co.name_eng %> CO.,LTD.</td>
		</tr>
		<tr>
			<td class=s_004><%=co.addr3_kor %> <%=co.addr2_kor %></td>
		</tr>
		<tr>
			<td class=s_005>TEL : <%=co.tel_kor %></td>
		</tr>
		<tr>
			<td class=s_005>FAX : <%=co.fax_kor %></td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2>&nbsp;</td>
</tr>
<tr>
	<td colspan=2 class=s_001>�Ʒ��� ���� �����մϴ� <%=KUtil.nchk(em.isUnit).equals("��������")?"(��������)":""%></td>
</tr>
<tr <%=KUtil.nchk(em.isUnit).equals("��������")?"style='display:none'":""%>>
	<td colspan=2 class=s_010><B>��  �� :</B>
		<%	if( em.priceKinds.equals("\\") ){	%>
		<B>�ϱ� <%=NumUtil.strToKor(em.totPrice,"")%> ����</B>
		<%	}	%>
		<B>( <%=em.priceKinds%> <%=NumUtil.numToFmt(em.totPrice,"###,###.##","0")%> )</B> <%=KUtil.nchk(em.isUnit)%></td>
</tr>
<tr valign=top>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr align=center height=28 onclick="show('id_title')" style="cursor:hand" bgcolor="#F4F7F7">
			<td width="40" class="AllLineBold2"><font class=s_005>NO</FONT></td>
			<td width="190" class="RTBLineBold2"><font class=s_005>ǰ&nbsp;&nbsp;&nbsp;&nbsp;��</FONT></td>
			<td width="190" class="RTBLineBold2"><font class=s_005>��&nbsp;&nbsp;&nbsp;&nbsp;��</FONT></td>
			<td width="80" class="RTBLineBold2"><font class=s_005>��&nbsp;&nbsp;&nbsp;&nbsp;��</FONT></td>
			<td width="80" class="RTBLineBold2"><font class=s_005>��&nbsp;&nbsp;&nbsp;&nbsp;��</FONT></td>
			<td width="100" class="RTBLineBold2"><font class=s_005>��&nbsp;&nbsp;&nbsp;&nbsp;��</FONT></td>
		</tr>
		<tr height=28 id="id_title">
			<td colspan=6 class="LRBline"><FONT class="s_001">&nbsp;<%=KUtil.nchk(em.title)%></FONT></td>
		</tr>

	<%	double reTotPrice = 0;
		int height = 0;
		for( int i=0 ; i<vecEstItem.size() ; i++ ){	
			EstItem ei = (EstItem)vecEstItem.get(i);
				reTotPrice += ei.totPrice;
				int len = KUtil.nchk(ei.itemNameMemo).length();
				height += 25;
	%>
		<tr align=center height=25>
			<td class="LRBline3" <%=len>0?"rowspan=2":""%>><%=i+1%></td>
			<td class="RBLine" align=left>
				<div class="s_004">&nbsp;<%=KUtil.toTextMode(ei.itemName,"&nbsp;")%></div></td>
			<td class="RBLine" align=left>
				<div class="s_004">&nbsp;<%=KUtil.toTextMode(ei.itemDim,"&nbsp;")%></div></td>
			<td class="RBLine">
				<FONT  class="s_009"><%=KUtil.intToCom(ei.cnt)%> <%=KUtil.nchk(ei.itemUnit)%></FONT></td>
			<td class="RBLine" align=right>
				<FONT  class="s_009"><%=ei.unitPrice>0?em.priceKinds+" "+NumUtil.numToFmt(ei.unitPrice,"###,###.##","0"):"&nbsp;"%>&nbsp;</FONT></td>
			<td class="RBLine" align=right>
				<FONT  class="s_009"><%=em.priceKinds%> <%=NumUtil.numToFmt(new Double(ei.totPrice),"###,###.##","0")%>&nbsp;</FONT></td>
		</tr>
	<%	if(len>0){	
				height += 25;	%>
		<tr height=25>
			<td colspan=5 class="RBLine2">
					<div>&nbsp;<%=KUtil.toTextMode(ei.itemNameMemo)%></div>
				<%	if(KUtil.nchk(ei.itemDimMemo).length()>0){	%>
					<div>&nbsp;<%=KUtil.toTextMode(ei.itemDimMemo)%></div>
				<%	}	%></td>
	<%	}	%>
		</tr>
	<%	}//for					%>

	<%	if( height < 100 ){	
			height = 150-height;		%>
		<tr valign=top align=center height="<%=height%>">
			<td class="LRBline">&nbsp</td>
			<td class="RBLine">&nbsp</td>
			<td class="RBLine"><FONT  class="s_004">- �� �� �� �� -</FONT></td>
			<td class="RBLine">&nbsp</td>
			<td class="RBLine">&nbsp</td>
			<td class="RBLine">&nbsp</td>
		</tr>
	<%	}//if	%>
		
		<tr align=center height=28 bgcolor="#F4F7F7">
			<td class="LRBline" colspan=2><FONT class=s_005>��&nbsp;��&nbsp;��&nbsp;��</FONT></td>
			<td class="RBline" rowspan=3>&nbsp;</td>
			<td class="RBline" rowspan=3>&nbsp;</td>
			<td class="RBline" rowspan=3>&nbsp;</td>
			<td class="RBline" align=right>
			<%	if( KUtil.nchk(em.isUnit).equals("��������") ){	%>
				��������&nbsp;
			<%	}else{	%>
				<FONT class="s_009"><%=em.priceKinds%> <%=NumUtil.numToFmt(reTotPrice,"###,###.##","0")%></FONT>&nbsp;
			<%	}	%></td>
		</tr>
		<tr align=center height=28 bgcolor="#F4F7F7">
			<td class="LRBline" colspan=2><FONT class=s_005>�ΰ���ġ��</FONT></td>
			<td class="RBline" <%=em.taxPrice>0?"align=right":""%> style="font-size:11.0pt;">
				<FONT class="s_009">
			<%	if( em.isTax == 1 ){
					out.print("��&nbsp;&nbsp;&nbsp;&nbsp;��");
				}else{
					out.print(em.priceKinds); out.print(NumUtil.numToFmt(em.taxPrice,"###,###.##","0"));
					out.print("&nbsp;");
				}%></FONT></td>
		</tr>
		<tr align=center height=28 bgcolor="#F4F7F7">
			<td class="LRBline" colspan=2><FONT class=s_005>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</FONT></td>
			<td class="RBline" align=right>
				<%	if( KUtil.nchk(em.isUnit).equals("��������") ){	%>
						��������&nbsp;
				<%	}else{	%>
						<FONT class="s_009"><%=em.priceKinds%> <%=NumUtil.numToFmt(reTotPrice+em.taxPrice,"###,###.##","0")%></FONT>&nbsp;
				<%	}		%></td>
		</tr>
		</table></td>
</tr>
<tr height=25>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr height=10>
			<td colspan=2></td>
		</tr>
		<tr valign=top style="padding:3 0 0 0">
			<td width="90" class=s_005>�� Ư�̻��� : </td>
			<td class=s_005><%=KUtil.nchk(em.memo)%></td>
		</tr>
		</table></td>
</tr>
<tr height="70" valign=bottom align=center id="noprint" style="display:block">
	<td colspan=2>
		<input type="button" value="����Ʈ" onclick="print_preview();" class="inputbox2">
		<input type="button" value="����" onclick="goModify()" class="inputbox2">
		<input type="button" value="�ݱ�" onclick="self.close()" class="inputbox2"></td>
</tr>
</form>
</table>
<!-- ���� -->
<div style="position:absolute;top:267;left:632" onMouseDown="holdMoveLayer( this );" onMouseUp="releaseMoveLayer( this );" ondblclick="this.style.display='none';">
<table cellpadding="0" cellspacing="0" border="0">
<tr>
	<td><IMG SRC="/images/logo/<%=co.dojang %>" BORDER="0" ALT="" align=absmiddle></td>
</tr>
</table></div>

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
resize(740,700);
</SCRIPT>

<!-- MeadCo ScriptX -->
<object id=factory style="display:none"
  classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814"
  codebase="/printx/smsx.cab#Version=6,6,440,26">
</object>