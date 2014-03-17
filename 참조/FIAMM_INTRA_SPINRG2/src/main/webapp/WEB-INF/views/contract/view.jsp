<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="contract"/>
	<jsp:param name="col" value="V"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	//request
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));
	int reloadval	= KUtil.nchkToInt(request.getParameter("reloadval"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	
	//생성자
	ProjectDAO pDAO		= new ProjectDAO(db);
	UserDAO uDAO		= new UserDAO(db);
	ContractDAO ctDAO	= new ContractDAO(db);
	EstimateDAO emDAO	= new EstimateDAO(db);
	ClientDAO cDAO		= new ClientDAO(db);
	ClientUserDAO cuDAO	= new ClientUserDAO(db);

	Contract ct		= ctDAO.selectOne(seq);
	Project pj		= pDAO.selectOne(ct.seq_project);
	Estimate ei		= emDAO.selectOne(ct.seq_estimate);
	Client cl		= cDAO.selectOne(ct.seq_client);
	ClientUser cu	= cuDAO.selectOne(ct.seq_clientUser);

	if( ct.seq != seq ){
		KUtil.scriptAlertBack(out,"자료가 존재하지 않습니다.");
		return;
	}
%>

<jsp:include page="/inc/inc_loadingBar.jsp" flush="true"/>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
var retQry = "?nowPage=<%=nowPage%>&sk=<%=sk%>&st=<%=st%>";
function goList(){
	document.location = "list.jsp"+retQry;
	
}
function checkContractAddForm(){
	var frm = document.contractAddForm;
	if( !validate(frm) ){
		return;
	}
	fileAllSelect();
	frm.action = "DBM.jsp";
	frm.submit();	
}
function validate(frm){
	if( Number(filterNum(frm.conTotPrice.value)) < 0 ){
		alert("계약금액을 입력하여 주십시요");
		frm.conTotPrice.focus();
		return false;
	}else if( !nchk(frm.conDate,"계약일") ) return false;
	//else if( !nchk(frm.title,"제목") ) return false;
	return true;
}
function viewClientUser(){
	var lft = (screen.availWidth-300)/2;
	var tp	= (screen.availHeight-500)/2;
	var pop = window.open("list_clientUser_pop.jsp?seq_client=<%=cl.seq%>","clientUser","width=300,height=500,top="+tp+",left="+lft);
	pop.focus();
}
function int2Com(){
	if( !keyCheck() ) return;
	var frm = document.contractAddForm;	

	intToCom(frm.conTotPrice);
	intToCom(frm.supPrice);
	intToCom(frm.taxPrice);
	intToCom(frm.payMethod1);
	intToCom(frm.payMethod2);
	intToCom(frm.payMethod3);
}
function getNextDate(){
	var frm = document.contractAddForm;
	if( frm.conDate.value.length == 8 && onlyNumber1(frm.conDate) ){
		
		var d1 = new Date( frm.conDate.value.substring(4,6)+"-"+frm.conDate.value.substring(6,8)+"-"+frm.conDate.value.substring(0,4));
	
		d1.setTime( d1.getTime() + Math.floor( Number(document.estFrm.limit.value) * 30 * 24 * 60 * 60 * 1000 ) );
		frm.deliDate.value = (d1.getYear()*10000)+(d1.getMonth()*100)+d1.getDate();
	}
	
}
function checkBoxCk( obj, id ){
	var frm = document.contractAddForm;
	if( obj.checked ) show1(id, "block");
	else show1(id, "none");
}
function delContract(){
	var frm = document.contractAddForm;
	if( confirm("삭제하시겠습니까?") ){
		document.location = "DBD.jsp?seq=<%=seq%>&reload=<%=reload%>";
	}
}
function viewProject(seq){
	var frm = document.projectForm;
	var lft = (screen.availWidth-720)/2;
	var tp	= (screen.availHeight-400)/2;
	var pop = window.open("/main/project/view.jsp?seq="+seq,"viewProject","width=720,height=400,scrollbars=1,left="+lft+",top="+tp);
	pop.focus();
	
}
function viewEstimate(seq){
	var lt = (screen.availWidth-720)/2;
	var tp = (screen.availheight-700)/2;
	var pop = window.open("/main/estimate/mod.jsp?seq="+seq,"esti","width=720,height=700,top="+tp+",left="+lt+",scrollbars=1,resizable=1");
	pop.focus();
}
function goModForm(){
	var frm = document.contractAddForm;
	frm.action = "mod.jsp";
	frm.submit();
}
function print_preview(){
	var left_margin		= 40.0;
	var right_margin	= 1.0;
	var top_margin		= 30.0;
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
		show1('id_hid01','none');
		var templateSupported = factory.printing.IsTemplateSupported();
		if( templateSupported  ){
			factory.printing.Preview();
		}
		resize(710,685);
		show1('id_hid01','block');
	}else{
		alert("ActiveX Print 프로그램을 설치하십시요!");
		return;
	}
	
}
</SCRIPT>

</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="0" border="0" width="700">

<form name="contractAddForm" method="post" onsubmit="return false;">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="reload" value="<%=reload%>">
<input type="hidden" name="reloadval" value="<%=reloadval%>">
<input type="hidden" name="isTax" value="">
<input type="hidden" class="inputbox1" name="conTotPrice" value="0" size="14" maxlength="20" onkeyup="int2Com()">

<tr height=28>
	<td class="ti1">&nbsp;▶ 계약서 정보</td>
</tr>
</table>


<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=25>
	<td class="bk1_1" align=right  width="120">계약 번호</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=ctDAO.getContractNo(ct)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>프로젝트 / 견적서</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<A HREF="javascript:;" onclick="viewProject('<%=pj.seq%>');"><%=pj.name%></A> 
		/ <A HREF="javascript:;" onclick="viewEstimate('<%=ei.seq%>');"><%=emDAO.getEstNo(ei)%></A></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">업체 / 담당자</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=cl.bizName%> / <%=KUtil.nchk(cu.userName)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">계약금액</td>
	<td class="bk2_1" colspan=3>&nbsp;
		공급가액: <%=KUtil.nchk(ct.priceKinds)%> <%=NumUtil.numToFmt(ct.supPrice,"###,###.##","0")%>
		부가가치세: <%=KUtil.nchk(ct.priceKinds)%> <%=NumUtil.numToFmt(ct.taxPrice,"###,###.##","0")%></td>
</tr>

<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">결제방법</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				계약금: <%=KUtil.nchk(ct.priceKinds)%> <%=NumUtil.numToFmt(ct.payMethod1,"###,###.##","0")%>
				중도금: <%=KUtil.nchk(ct.priceKinds)%> <%=NumUtil.numToFmt(ct.payMethod2,"###,###.##","0")%>
				잔금: <%=KUtil.nchk(ct.priceKinds)%> <%=NumUtil.numToFmt(ct.payMethod3,"###,###.##","0")%></td>
		</tr>
		<tr>
			<td style="padding-left:7px"><%=KUtil.nchk(ct.payMethod,"&nbsp;")%></td>
		</tr>
		</table></td>
</tr>




<tr height=25>
	<td class="bk1_1" align=right  width="120">계약일</td>
	<td class="bk2_1" width="230">&nbsp;
		<%=KUtil.dateMode(ct.conDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
	<td class="bk1_1" align=right>하자보증 만료일</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.dateMode(ct.warrant,"yyyyMMdd","yy.MM.dd","&nbsp;")%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>계약납기</td>
	<td class="bk2_1">&nbsp;
		<%=KUtil.arrStrDateToStr(ct.deliDate,",&nbsp;&nbsp;&nbsp;","")%></td>
	<td class="bk1_1" align=right  width="120">요구납기</td>
	<td class="bk2_1" width="230">&nbsp;
		<%=KUtil.arrStrDateToStr(ct.demandDate,",&nbsp;&nbsp;&nbsp;","")%></td>
</tr>

<tr height=25>
	<td class="bk1_1" align=right  width="120">(거래처)계약번호</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=KUtil.nchk(ct.contractNum)%></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">선급금이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="prepayDeed" value="1" onclick="checkBoxCk(this, 'id_prepay')" <%=ct.prepayDeed==1?"checked":""%> disabled></td>
			<td id="id_prepay" style="display:<%=ct.prepayDeed==1?"block":"none"%>">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr>
					<td width="70">
						<%	if( NumUtil.numToFmt(ct.prepayPer,"###,###.##","0").equals("0") ){
								out.println("미지정");
							}else{
								out.println( NumUtil.numToFmt(ct.prepayPer,"###,###.##","0")+" %" );	
							}%></td>
					<td >기간: <%=KUtil.dateMode(ct.prepayStDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	if( ct.prepayEdDate > 0 ){	%>
							~ <%=KUtil.dateMode(ct.prepayEdDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	}//if	%></td>
					<td width="330">내용: <%=KUtil.nchk(ct.prepayContent)%></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>



<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">계약이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="conDeed" value="1" onclick="checkBoxCk(this, 'id_con')" <%=ct.conDeed==1?"checked":""%> disabled></td>
			<td id="id_con" style="display:<%=ct.conDeed==1?"block":"none"%>">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr>
					<td width="70">
						<%	if( NumUtil.numToFmt(ct.conPer,"###,###.##","0").equals("0") ){
								out.println("미지정");
							}else{
								out.println( NumUtil.numToFmt(ct.conPer,"###,###.##","0")+" %" );	
							}	%></td>
					<td >기간: <%=KUtil.dateMode(ct.conStDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	if( ct.conEdDate > 0 ){	%>
							~ <%=KUtil.dateMode(ct.conEdDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	}//if	%></td>
					<td width="330">내용: <%=KUtil.nchk(ct.conContent)%></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>



<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">하자이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="defectDeed" value="1" onclick="checkBoxCk(this, 'id_defect')" <%=ct.defectDeed==1?"checked":""%> disabled></td>
			<td id="id_defect" style="display:<%=ct.defectDeed==1?"block":"none"%>">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr>
					<td width="70">
						<%	if( NumUtil.numToFmt(ct.defectPer,"###,###.##","0").equals("0") ){
								out.println("미지정");
							}else{
								out.println( NumUtil.numToFmt(ct.defectPer,"###,###.##","0")+" %" );	
							}%></td>
					<td >기간: <%=KUtil.dateMode(ct.defectStDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	if( ct.defectEdDate > 0 ){	%>
							~ <%=KUtil.dateMode(ct.defectEdDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	}//if	%></td>
					<td width="330">내용: <%=KUtil.nchk(ct.defectContent)%></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">기타증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="etcDeed" value="1" onclick="checkBoxCk(this, 'id_etc')" <%=ct.etcDeed==1?"checked":""%> disabled></td>
			<td id="id_etc" style="display:<%=ct.etcDeed==1?"block":"none"%>">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr>
					<td width="70">
						<%	if( NumUtil.numToFmt(ct.etcPer,"###,###.##","0").equals("0") ){
								out.println("미지정");
							}else{
								out.println( NumUtil.numToFmt(ct.etcPer,"###,###.##","0")+" %" );	
							}%></td>
					<td >기간: <%=KUtil.dateMode(ct.etcStDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	if( ct.etcEdDate > 0 ){	%>
							~ <%=KUtil.dateMode(ct.etcEdDate,"yyyyMMdd","yy.MM.dd","&nbsp;")%>
						<%	}//if	%></td>
					<td width="330">내용: <%=KUtil.nchk(ct.etcContent)%></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">지체상금율</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="29">&nbsp;
				<input type="checkbox" name="delayDeed" value="1" onclick="checkBoxCk(this, 'id_delay')" <%=ct.delayDeed==1?"checked":""%> disabled></td>
			<td id="id_delay" style="display:<%=ct.delayDeed==1?"block":"none"%>">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr>
					<td width="70">
						<%	if( NumUtil.numToFmt(ct.delayPer,"###,###.#######","0").equals("0") ){
								out.println("미지정");
							}else{
								out.println( NumUtil.numToFmt(ct.delayPer,"###,###.#######","0")+" %" );	
							}%></td>
					<td>내용: <%=KUtil.nchk(ct.etcContent)%></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120">설치장소</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=KUtil.nchk(ct.place)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">내부 담당자</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=KUtil.nchk(uDAO.selectOne(ct.inUserId).userName)%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">첨부파일</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=FileCtl.fileViewLink(ct.fileName,"",ct.seq,"contract",",",1)%></td>
</tr>
<tr height=75>
	<td class="bk1_bg" align=right  width="120">기타사항</td>
	<td colspan=3 style="padding:5 5 5 9" valign=top>
		<%=KUtil.nchk(ct.memo)%></td>
</tr>
<tr height=2 class="bgc2">
	<td colspan=4 align=center></td>
</tr>
<tr height=28 class="bgc1" id="id_hid01">
	<td colspan=4 align=center>
		<input type="button" value="프린트" onclick="print_preview();" class="inputbox2">
		<input type="button" value="수정" class="inputbox2" onclick="goModForm()">
		<input type="button" value="삭제" class="inputbox2" onclick="delContract()">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>

</form>
</table>
</BODY>
</HTML>

<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>

<iframe id="clientUser" width="0" height="0"></iframe>
<iframe id="clientUser1" width="0" height="0"></iframe>



<script language="javascript1.2">
resize(710,685);
</script>

<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>


<OBJECT id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814"
	viewastext codebase="/printx/ScriptX.cab#Version=6,1,428,11">
</OBJECT>