<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="contract"/>
	<jsp:param name="col" value="M"/>
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
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);

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
function chPriceKinds(){
	var frm = document.contractAddForm;
	if( frm._priceKinds.value==0 ){
		frm.priceKinds.value = frm.priceKinds_temp.value;
		show1("id_priceKinds","block");
		frm.priceKinds.focus();
	}else{
		frm.priceKinds.value = frm._priceKinds.value;
		show1("id_priceKinds","none");
	}
}
function showEstimate(){
	var pop = window.open("pop_estimate_list.jsp?seq_project=<%=ct.seq_project%>","listEstimate","scrollbars=0,resizable=0");
}
</SCRIPT>

</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="700">

<form name="contractAddForm" method="post" onsubmit="return false;">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="reload" value="<%=reload%>">
<input type="hidden" name="reloadval" value="<%=reloadval%>">
<input type="hidden" name="isTax" value="">
<input type="hidden" class="inputbox1" name="conTotPrice" value="0" size="14" maxlength="20" onkeyup="int2Com()">
<input type="hidden" class="inputbox" name="title" value="<%=KUtil.nchk(ct.title)%>" size="50" maxlength="200">
<input type="hidden" name="seq_estimate" value="<%=ei.seq%>">
<tr height=28>
	<td class="ti1">&nbsp;▶ 계약서 정보 수정</td>
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
		/ 
		<%	if( ei.seq > 0 ){	%>
			<A HREF="javascript:;" onclick="viewEstimate('<%=ei.seq%>');"><%=emDAO.getEstNo(ei)%></A>
		<%	}else{			%>
			<input type="text" class="inputbox" name="estimate_name" value="" size="18" readonly>
			<input type="button" value="선택" onclick="showEstimate()" class="inputbox2">
		<%	}	%></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">업체 / 담당자</td>
	<td class="bk2_1" colspan=3>&nbsp;<%=cl.bizName%> / 
		<input type="text" class="inputbox" name="clientUser_name" value="<%=KUtil.nchk(cu.userName)%>" size="10" readonly>
		<input type="hidden" name="seq_clientUser" value="<%=cu.seq%>">
		<input type="button" value="담당자 선택" onclick="viewClientUser()" class="inputbox2"></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">계약금액</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" height="100%">
		<tr>
			<td>&nbsp;</td>
			<td>
				통화단위: 
				<select name="_priceKinds" class="selbox1" onchange="chPriceKinds()">
			<%	boolean flag = false;
				Vector vecPriceKinds = pkDAO.getList();
				for( int i=0 ; i<vecPriceKinds.size() ; i++ ){	
					String priceKinds  = (String)vecPriceKinds.get(i);	%>
					<option value="<%=priceKinds%>" <%if( ct.priceKinds.equals(priceKinds) ){out.println("selected"); flag = true;}%>><%=priceKinds%></option>
			<%	}//for	%>
					<option value="0" <%=flag?"":"selected"%>>직접입력</option>
				</select></td>
			<td id="id_priceKinds" style="display:<%=flag?"none":"block"%>;">
				<input type="text" name="priceKinds" value="<%=ct.priceKinds%>" class="inputbox1" size=5 maxlength="50"></td>
			<td>
				공급가액: <input type="text" class="inputbox1" name="supPrice" value="<%=NumUtil.numToFmt(ct.supPrice,"###,###.##","0")%>" size="14" maxlength="20" onkeyup="int2Com()">
				부가가치세: <input type="text" class="inputbox1" name="taxPrice" value="<%=NumUtil.numToFmt(ct.taxPrice,"###,###.##","0")%>" size="14" maxlength="20" onkeyup="int2Com()"></td>
		</tr>
		</table></td>
</tr>

<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">결제방법</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				계약금: <input type="text" class="inputbox" name="payMethod1" value="<%=NumUtil.numToFmt(ct.payMethod1,"###,###.##","0")%>" size="14" maxlength="20" onkeyup="int2Com()">
				중도금: <input type="text" class="inputbox" name="payMethod2" value="<%=NumUtil.numToFmt(ct.payMethod2,"###,###.##","0")%>" size="14" maxlength="20" onkeyup="int2Com()">
				잔금: <input type="text" class="inputbox" name="payMethod3" value="<%=NumUtil.numToFmt(ct.payMethod3,"###,###.##","0")%>" size="14" maxlength="20" onkeyup="int2Com()"></td>
		</tr>
		<tr>
			<td>&nbsp;
				<textarea name="payMethod" style="width:90%;height:20"><%=KUtil.nchk(ct.payMethod)%></textarea></td>
		</tr>
		</table></td>
</tr>




<tr height=25>
	<td class="bk1_1" align=right  width="120">계약일</td>
	<td class="bk2_1" width="230">&nbsp;
		<input type="text" class="inputbox1" name="conDate" value="<%=ct.conDate>0?ct.conDate+"":""%>" size="10" readonly>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.conDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand"></td>
	<td class="bk1_1" align=right>하자보증 만료일</td>
	<td class="bk2_1">&nbsp;
		<input type="text" class="inputbox" name="warrant" value="<%=ct.warrant>0?ct.warrant+"":""%>" size="10" readonly>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.warrant,'',calStr);showbox1(calStr,'block',-150,0);" align=absmiddle style="cursor:hand"></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right>계약납기</td>
	<td class="bk2_1">&nbsp;
		<textarea name="deliDate" style="width:100;height:40"><%=KUtil.nchk(ct.deliDate)%></textarea>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.deliDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand"></td>
	<td class="bk1_1" align=right  width="120">요구납기</td>
	<td class="bk2_1" width="230">&nbsp;
		<textarea name="demandDate" style="width:100;height:40"><%=KUtil.nchk(ct.demandDate)%></textarea>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.demandDate,'',calStr);showbox1(calStr,'block',-150,0);" align=absmiddle style="cursor:hand"></td>
</tr>

<tr height=25>
	<td class="bk1_1" align=right  width="120">(거래처)계약번호</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" name="contractNum" value="<%=KUtil.nchk(ct.contractNum)%>" size="35" maxlength="200" class="inputbox"></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">선급금이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="prepayDeed" value="1" onclick="checkBoxCk(this, 'id_prepay')" <%=ct.prepayDeed==1?"checked":""%>></td>
			<td id="id_prepay" style="display:<%=ct.prepayDeed==1?"block":"none"%>">
				<input type="text" name="prepayPer" value="<%=NumUtil.numToFmt(ct.prepayPer,"###,###.##","0")%>" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="prepayStDate" value="<%=ct.prepayStDate>0?ct.prepayStDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.prepayStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="prepayEdDate" value="<%=ct.prepayEdDate>0?ct.prepayEdDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.prepayEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="prepayContent" style="width:250;height:20" class="inputbox"><%=KUtil.nchk(ct.prepayContent)%></textarea></td>
		</tr>
		</table></td>
</tr>



<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">계약이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="conDeed" value="1" onclick="checkBoxCk(this, 'id_con')" <%=ct.conDeed==1?"checked":""%>></td>
			<td id="id_con" style="display:<%=ct.conDeed==1?"block":"none"%>">
				<input type="text" name="conPer" value="<%=NumUtil.numToFmt(ct.conPer,"###,###.##","0")%>" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="conStDate" value="<%=ct.conStDate>0?ct.conStDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.conStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="conEdDate" value="<%=ct.conEdDate>0?ct.conEdDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.conEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="conContent" style="width:250;height:20" class="inputbox"><%=KUtil.nchk(ct.conContent)%></textarea></td>
		</tr>
		</table></td>
</tr>



<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">하자이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="defectDeed" value="1" onclick="checkBoxCk(this, 'id_defect')" <%=ct.defectDeed==1?"checked":""%>></td>
			<td id="id_defect" style="display:<%=ct.defectDeed==1?"block":"none"%>">
				<input type="text" name="defectPer" value="<%=NumUtil.numToFmt(ct.defectPer,"###,###.##","0")%>" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="defectStDate" value="<%=ct.defectStDate>0?ct.defectStDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.defectStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="defectEdDate" value="<%=ct.defectEdDate>0?ct.defectEdDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.defectEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="defectContent" style="width:250;height:20" class="inputbox"><%=KUtil.nchk(ct.defectContent)%></textarea></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">기타증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="etcDeed" value="1" onclick="checkBoxCk(this, 'id_etc')" <%=ct.etcDeed==1?"checked":""%>></td>
			<td id="id_etc" style="display:<%=ct.etcDeed==1?"block":"none"%>">
				<input type="text" name="etcPer" value="<%=NumUtil.numToFmt(ct.etcPer,"###,###.##","0")%>" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="etcStDate" value="<%=ct.etcStDate>0?ct.etcStDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.etcStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="etcEdDate" value="<%=ct.etcEdDate>0?ct.etcEdDate+"":""%>" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.etcEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="etcContent" style="width:250;height:20" class="inputbox"><%=KUtil.nchk(ct.etcContent)%></textarea></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">지체상금율</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="29">&nbsp;
				<input type="checkbox" name="delayDeed" value="1" onclick="checkBoxCk(this, 'id_delay')" <%=ct.delayDeed==1?"checked":""%>></td>
			<td id="id_delay" style="display:<%=ct.delayDeed==1?"block":"none"%>">
				<input type="text" name="delayPer" value="<%=NumUtil.numToFmt(ct.delayPer,"###,###.######","0")%>" size=7 maxlength=10 class="inputbox"> %
				내용: <textarea name="delayContent" style="width:250;height:20" class="inputbox"><%=KUtil.nchk(ct.delayContent)%></textarea></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120">설치장소</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" class="inputbox" name="place" value="<%=KUtil.nchk(ct.place)%>" size="40" maxlength="200"></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">내부 담당자</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<select name="userId" class="selbox">
			<option value="">▒▒내부담당자▒▒</option>
	<%	Vector vecUser = uDAO.getUserList();
		for( int i=0 ; i<vecUser.size() ; i++ ){	
			User ur  = (User)vecUser.get(i);	%>
			<option value="<%=ur.userId%>" <%=ur.userId.equals(ct.inUserId)?"selected":""%>><%=ur.userName%></option>
	<%	}//for	%>
		</select></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">첨부파일</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" height="100%">
		<tr>
			<td style="padding-left:5">
				<select class="selbox" name="attFiles" MULTIPLE style="width:150px" size="3">
				</select></td>
			<td style="padding-left:5">
				<table cellpadding="0" cellspacing="0" border="0" height="100%">
				<tr>
					<td><input type="button" onclick="fileAttach()" value="파일추가" class="inputbox2"></td>
				</tr>
				<tr>
					<td><input type="button" onclick="fileDelete()" value="선택삭제" class="inputbox2"></td>
				</tr>
				</table></td>
			<td valign=top style="padding-left:5"><%=FileCtl.fileViewLink(ct.fileName,"",ct.seq,"contract",",",1)%></td>
		</tr>
		</table></td>
</tr>
<tr height=25>
	<td class="bk1_bg" align=right  width="120">기타사항</td>
	<td colspan=3>
		<textarea name="memo" style="width:580;height:80"><%=KUtil.nchk(ct.memo)%></textarea></td>
</tr>
<tr height=2 class="bgc2">
	<td colspan=4 align=center></td>
</tr>
<tr height=28 class="bgc1">
	<td colspan=4 align=center>
		<input type="button" value="수정" class="inputbox2" onclick="checkContractAddForm()">
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
editor_generate('memo');
resize(710,675);
</script>

<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
