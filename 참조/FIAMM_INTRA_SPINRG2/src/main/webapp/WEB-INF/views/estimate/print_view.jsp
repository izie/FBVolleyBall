<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<%@ include file="/inc/inc_per_r.jsp"%>
<%
	Database db = new Database();
try{ 
	int seq = KUtil.nchkToInt(request.getParameter("seq"));

	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	EstimateDAO emDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);

	Estimate em = emDAO.selectOne(seq);
	Vector vecEstItem = eiDAO.getList(seq);
%>


<HTML>
<HEAD>
<title>�Ǿ��ڸ���</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
function print_page(){
	IEPrint.left = 12;
	IEPrint.right = 10;
	IEPrint.top = 20;
	IEPrint.bottom = 10;
	IEPrint.header = "";
	IEPrint.footer = "";
	IEPrint.printbg = true;		// ���������� �޸� true, false�� �����Ѵ�.
	IEPrint.landscape = false;	// ���� ����� ���Ͻø� true�� ������ �˴ϴ�. ��������� false�Դϴ�.	
	IEPrint.paper = "A4";		// ���������Դϴ�.
	show1('noprint','none');
	IEPrint.Print();			// ���� ������ ���� ���� �����ϰ�, ����Ʈ���̾�α׸� ���ϴ�.
	show1('noprint','block');
}
function print_preview(){
	IEPrint.left = 12;
	IEPrint.right = 10;
	IEPrint.top = 20;
	IEPrint.bottom = 10;
	IEPrint.header = "";
	IEPrint.footer = "";
	IEPrint.printbg = true;		// ���������� �޸� true, false�� �����Ѵ�.
	IEPrint.landscape = false;	// ���� ����� ���Ͻø� true�� ������ �˴ϴ�. ��������� false�Դϴ�.	
	IEPrint.paper = "A4";		// ���������Դϴ�.
	show1('noprint','none');
	IEPrint.Preview();		// ���� ������ ���� ���� �����ϰ�, �̸����⸦�մϴ�.
	show1('noprint','block');
}
function goModify(){
	document.location = "mod.jsp?seq=<%=seq%>";
}
function goDelete(){
	if( confirm("�����Ͻðڽ��ϱ�?") ){
		document.location = "DBD.jsp?seq=<%=seq%>";
	}
}
//onbeforeprint="printSetup()" onafterprint="printSetup1()"
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0">

<table cellpadding="0" cellspacing="0" border="0" width="700">
<form name="estimateViewForm" method="post">
<input type="hidden" name="seq" value="<%=seq%>">
<tr align=center>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><IMG SRC="/images/logo_simple_color.gif" WIDTH="37" HEIGHT="35" BORDER="0" ALT="" align=absmiddle></td>
			<td valign=middle style="line-height:35px">&nbsp;<b><FONT SIZE="4">FIAM KOREA CO.,LTD.</FONT></b></td>
		</tr>
		</table></td>
</tr>
<tr height=5>
	<td colspan=2 class="bk_dot"><IMG SRC="/images/blank.gif" WIDTH="1" HEIGHT="1" BORDER="0" ALT=""></td>
</tr>
<tr>
	<td>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>#1001, Kuro 1st ACE Techno Tower,</td>
		</tr>
		<tr>
			<td>197-48, Kuro-Dong, Kuro-Ku,</td>
		</tr>
		<tr>
			<td>Seoul, Korea</td>
		</tr>
		</table></td>
	<td align=right>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>TEL : (82-2)857-8411 ~3</td>
		</tr>
		<tr>
			<td>FAX : (82-2)857-8414</td>
		</tr>
		<tr>
			<td>E-mail : fiamm@fiammkorea.co.kr</td>
		</tr>
		</table></td>
</tr>
<tr align=center height=40>
	<td colspan=2 style="line-height:40px"><B><FONT SIZE="6"><U style="font-family:'����'"≯&nbsp;&nbsp;��&nbsp;&nbsp;��</U></FONT></B></td>
</tr>
<tr>
	<td valign=top>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><B onclick="show('id_project')" style="cursor:hand;font-weight:bold;font-size:16px;font-family:'����'"><%=KUtil.nchk(cDAO.selectOne(em.seq_client).bizName)%></B> ����</td>
		</tr>
		<tr style="display:block" id="id_project">
			<td><B style="font-weight:bold;">Project Name: <%=pDAO.selectOne(em.seq_project).name%></B></td>
		</tr>
		<tr <%=em.seq_clientUser<1?"style='display:none'":""%>>
			<td>ӽ �� � : <%=KUtil.nchk(cuDAO.selectOne(em.seq_clientUser).userName)%></td>
		</tr>
		</table></td>
	<td align=right valign=top>
		<table cellpadding="0" cellspacing="0" border="0" width="150">
		<tr>
			<td>DATE : <%=KUtil.toDateViewMode(em.wDate)%><br>
				������ NO. :
			<%=KUtil.cutIntDate(em.estYear,2,4,2)%><%=KUtil.formatDigit(em.estNum)%><%=em.estNumIncre>0?"-"+em.estNumIncre:""%></td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2>&nbsp;</td>
</tr>
<tr>
	<td valign=top>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>ҡ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� : ۡ��� <%=NumUtil.numToFmt(em.limitDate,"##.#","0")%> ����</td>
		</tr>
		<tr>
			<td>��Ԥ��� : <%=KUtil.nchk(em.place)%></td>
		</tr>
		<tr>
			<td>������� : <%=KUtil.nchk(em.payKinds)%></td>
		</tr>
		<tr>
			<td≯�� ����Ѣ�� : <%=KUtil.intToCom(em.edDate)%> ��</td>
		</tr>
		</table></td>
	<td align=right valign=top>
		<table cellpadding="0" cellspacing="0" border="0" width="200">
		<tr>
			<td style="line-height:20px"><B><FONT style="font-size: 17px;font-family:'����'">�Ǿ��ڸ� �ֽ�ȸ��</FONT></B></td>
		</tr>
		<tr>
			<td><B>FIAM KOREA CO.,LTD.</B></td>
		</tr>
		<tr>
			<td>�ּ� : ����� ���α� ���ε� 197-48</td>
		</tr>
		<tr>
			<td>TEL : (02)857-8411~3</td>
		</tr>
		<tr>
			<td>FAX : (02)857-8414</td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2>&nbsp;</td>
</tr>
<tr>
	<td colspan=2>�Ʒ��� ���� ̸���մϴ� <%=KUtil.nchk(em.isUnit).equals("��������")?"(��������)":""%></td>
</tr>
<tr <%=KUtil.nchk(em.isUnit).equals("��������")?"style='display:none'":""%>>
	<td colspan=2>��  ͪ : 
		�ϱ� <%=NumUtil.strToKor(em.totPrice,"")%> ����
		( <%=em.priceKinds%> <%=NumUtil.numToFmt(em.totPrice,"###,###.##","0")%> ) <%=KUtil.nchk(em.isUnit)%></td>
</tr>
<tr>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="300">
		<tr align=center height=28 onclick="show('id_title')" style="cursor:hand">
			<td width="200" class="AllLineBold2"><B>��&nbsp;&nbsp;&nbsp;&nbsp;٣</B></td>
			<td width="200" class="RTBLineBold2"><B>Ю&nbsp;&nbsp;&nbsp;&nbsp;̫</B></td>
			<td width="90" class="RTBLineBold2"><B>�&nbsp;&nbsp;&nbsp;&nbsp;��</B></td>
			<td width="100" class="RTBLineBold2"><B>Ӥ&nbsp;&nbsp;&nbsp;&nbsp;ʤ</B></td>
			<td width="110" class="RTBLineBold2"><B>��&nbsp;&nbsp;&nbsp;&nbsp;��</B></td>
		</tr>
		<tr height=28 id="id_title">
			<td colspan=5 class="LRBline">&nbsp;<%=KUtil.nchk(em.title)%></td>
		</tr>
	<%	long reTotPrice = 0;
		for( int i=0 ; i<vecEstItem.size() ; i++ ){	
			EstItem ei = (EstItem)vecEstItem.get(i);
				reTotPrice += ei.totPrice;
	%>
		<tr align=center height=25>
			<td class="LRBLine1">
				<div><%=KUtil.nchk(ei.itemName,"&nbsp;")%></div></td>
			<td class="RBLine1">
				<div><%=KUtil.nchk(ei.itemDim,"&nbsp;")%></div></td>
			<td class="RBLine1"><%=KUtil.intToCom(ei.cnt)%> <%=KUtil.nchk(ei.itemUnit)%></td>
			<td class="RBLine1" align=right>
				<%=ei.unitPrice>0?em.priceKinds+" "+NumUtil.numToFmt(ei.unitPrice,"###,###.##","0"):"&nbsp;"%>&nbsp;</td>
			<td class="RBLine1" align=right>
				<%=em.priceKinds%> <%=NumUtil.numToFmt(new Double(ei.totPrice),"###,###.##","0")%>&nbsp;</td>
		</tr>
		<tr align=center height=20>
			<td colspan=5 class="LRBLine1">
				<%	if(KUtil.nchk(ei.itemNameMemo).length()>0){	%>
					<div><%=KUtil.toTextMode(ei.itemNameMemo)%></div>
				<%	}	%>
				<%	if(KUtil.nchk(ei.itemDimMemo).length()>0){	%>
					<div><%=KUtil.toTextMode(ei.itemDimMemo)%></div>
				<%	}	%></td>
		</tr>
	<%	}//for					%>
		<tr valign=top align=center>
			<td class="LRBline">&nbsp</td>
			<td class="RBLine">- �� �� �� �� -</td>
			<td class="RBLine">&nbsp</td>
			<td class="RBLine">&nbsp</td>
			<td class="RBLine">&nbsp</td>
		</tr>
		
		<tr align=center height=25>
			<td class="LRBline"><B>��&nbsp;��&nbsp;ʤ&nbsp;��</B></td>
			<td class="RBline" rowspan=3>&nbsp;</td>
			<td class="RBline" rowspan=3>&nbsp;</td>
			<td class="RBline" rowspan=3>&nbsp;</td>
			<td class="RBline" align=right>
				<%=em.priceKinds%> <%=NumUtil.numToFmt(new Double(reTotPrice),"###,###.##","0")%>&nbsp;</td>
		</tr>
		<tr align=center height=25>
			<td class="LRBline"><B>ݾʥʤ���</B></td>
			<td class="RBline" <%=em.taxPrice>0?"align=right":""%>>
				<%	if( em.taxPrice<1 ){
					out.print("ܬ&nbsp;&nbsp;&nbsp;&nbsp;Բ");
				}else{
					out.print(em.priceKinds); out.print(NumUtil.numToFmt(em.taxPrice,"###,###.##","0"));
				}%></td>
		</tr>
		<tr align=center height=25>
			<td class="LRBline"><B>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ͪ</B></td>
			<td class="RBline" align=right>
				<%=em.priceKinds%> <%=NumUtil.numToFmt(reTotPrice+em.taxPrice,"###,###.##","0")%>&nbsp;</td>
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
			<td width="80">�� �������� : </td>
			<td><%=KUtil.nchk(em.memo)%></td>
		</tr>
		</table></td>
</tr>
<tr align=center id="noprint" style="display:block">
	<td colspan=2>
		<input type="button" value="â�ݱ�" onclick="self.close();">
		<input type="button" value="����Ʈ" onclick="print_page();">
		<input type="button" value="�̸�����" onclick="print_preview();">
		<input type="button" value="����" onclick="goModify()">
		<input type="button" value="����" onclick="goDelete()"></td>
</tr>
</form>
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


<SCRIPT LANGUAGE="JavaScript">
moveTo(0,0);
resizeTo(screen.availWidth,screen.availHeight);
</SCRIPT>

<OBJECT ID="IEPrint" WIDTH="1" HEIGHT="1" CLASSID="CLSID:F290B058-CB26-460E-B3D4-8F36AEEDBE44" 
codebase="/IEPrint.cab#version=1,0,1,1">