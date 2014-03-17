<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="contract"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	//request
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));
	int reloadval	= KUtil.nchkToInt(request.getParameter("reloadval"));
	int seq_project	= KUtil.nchkToInt(request.getParameter("seq_project"));
	int seq_estimate= KUtil.nchkToInt(request.getParameter("seq_estimate"));
	
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	//생성자
	UserDAO uDAO = new UserDAO(db);
	EstimateDAO eDAO = new EstimateDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
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
function checkContractAddForm(){
	var frm = document.contractAddForm;
	
	if( !validate(frm) ){
		return;
	}
	fileAllSelect();
	frm.action = "DBW.jsp";
	frm.submit();
}
function validate(frm){
	if( frm._coNum.value=='2' ){
		if( !chkNo(frm.coNum,"계약번호") ) return false;
		if( frm.coNum.value.length < 5 ){
			alert("계약 번호를 년도 + 번호로 입력해 주십시요 Ex) 20051");
			return false;
		}
	}
	if( !nchk1(frm.project_name) ){
		alert("프로젝트 선택하여 주십시요");
		return false;
	}
	if( Number(filterNum(frm.conTotPrice.value)) < 0 ){
		alert("계약금액을 입력하여 주십시요");
		frm.conTotPrice.focus();
		return false;
	}else if( !nchk(frm.conDate,"계약일") ) return false;
	//else if( !nchk(frm.title,"제목") ) return false;

	return true;
}
function showProject(){
	var lft = (screen.availWidth-800)/2;
	var tp	= (screen.availHeight-400)/2;
	var pop = window.open("fm_index.jsp","client","width=800,height=400,top="+tp+",left="+lft);
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
		frm.deliDate.value = (d1.getYear()*10000)+( (d1.getMonth()+1)*100)+d1.getDate();
	}
	
}
function checkBoxCk( obj, id ){
	var frm = document.contractAddForm;
	if( obj.checked ) show1(id, "block");
	else show1(id, "none");
}
function chCoNum(){
	var frm = document.contractAddForm;
	frm.coNum.value = "";
	if( frm._coNum.value=='1' ){
		show1('id_num','none');
	}else{
		show1('id_num','block');
		frm.coNum.focus();
	}
}
function chPriceKinds(){
	var frm = document.contractAddForm;
	if( frm._priceKinds.value==0 ){
		frm.priceKinds.value = "";
		show1("id_priceKinds","block");
		frm.priceKinds.focus();
	}else{
		frm.priceKinds.value = frm._priceKinds.value;
		show1("id_priceKinds","none");
	}
}
</SCRIPT>

</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="1" border="0" width="700">
<form name="contractAddForm" method="post" onsubmit="return false;">
<input type="hidden" name="reload" value="<%=reload%>">
<input type="hidden" name="reloadval" value="<%=reloadval%>">
<input type="hidden" name="isTax" value="">
<input type="hidden" class="inputbox1" name="conTotPrice" value="0" size="14" maxlength="20" onkeyup="int2Com()">
<input type="hidden" class="inputbox" name="title" value="" size="50" maxlength="200">

<tr height=28>
	<td class="ti1">&nbsp;▶ 계약서 정보 입력</td>
</tr>
</table>


<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=25>
	<td class="bk1_1" align=right  width="120">계약 번호</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>&nbsp;
				<select name="_coNum" class="selbox1" onchange="chCoNum()">
					<option value="1">자동</option>
					<option value="2">직접입력</option>
				</select></td>
			<td id="id_num" style="display:none">
				<input type="text" name="coNum" value="" size="8" maxlength="8" class="inputbox1">
				ex)2005001</td>
		</tr>
		</table>
		</td>
</tr>

<tr height=25>
	<td class="bk1_1" align=right  width="120">프로젝트 / 견적서</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" class="inputbox1" name="project_name"  value="" size="18" readonly>
		<input type="hidden" name="seq_project" value="">
		<input type="text" class="inputbox" name="estimate_name" value="" size="18" readonly>
		<input type="hidden" name="seq_estimate" value="">
		<input type="button" value="선택" onclick="showProject()" class="inputbox2"></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">업체 / 담당자</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" class="inputbox" name="client_name" value="" size="15" readonly>
		<input type="hidden" name="seq_client" value="">
		<input type="text" class="inputbox" name="clientUser_name" value="" size="10" readonly>
		<input type="hidden" name="seq_clientUser" value=""></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">계약금액</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0"height="100%">
		<tr>
			<td>&nbsp;</td>
			<td>통화단위: 
				<select name="_priceKinds" class="selbox1" onchange="chPriceKinds()">
			<%	Vector vecPriceKinds = pkDAO.getList();
				for( int i=0 ; i<vecPriceKinds.size() ; i++ ){	
					String priceKinds  = (String)vecPriceKinds.get(i);	%>
					<option value="<%=priceKinds%>"><%=priceKinds%></option>
			<%	}//for	%>
					<option value="0">직접입력</option>
				</select></td>
			<td id="id_priceKinds" style="display:none">
				<input type="text" name="priceKinds" value="\" class="inputbox1" size=5 maxlength="50" ></td>
			<td>
				공급가액: <input type="text" class="inputbox1" name="supPrice" value="0" size="14" maxlength="20" onkeyup="int2Com()">
				부가가치세: <input type="text" class="inputbox1" name="taxPrice" value="0" size="14" maxlength="20" onkeyup="int2Com()"></td>
		</tr>
		</table></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">결제방법</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				계약금: <input type="text" class="inputbox" name="payMethod1" value="0" size="14" maxlength="20" onkeyup="int2Com()">
				중도금: <input type="text" class="inputbox" name="payMethod2" value="0" size="14" maxlength="20" onkeyup="int2Com()">
				잔금: <input type="text" class="inputbox" name="payMethod3" value="0" size="14" maxlength="20" onkeyup="int2Com()"></td>
		</tr>
		<tr>
			<td>&nbsp;
				<textarea name="payMethod" style="width:90%;height:20"></textarea></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120">계약일</td>
	<td class="bk2_1" width="230">&nbsp;
		<input type="text" class="inputbox1" name="conDate" value="<%=KUtil.getIntDate("yyyyMMdd")%>" size="10" maxlength=8>
		<!-- onkeyup="getNextDate()" -->
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.conDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand"></td>
	<td class="bk1_1" align=right  width="120">하자보증 만료일</td>
	<td class="bk2_1">&nbsp;
		<input type="text" class="inputbox" name="warrant" value="" size="10" maxlength=8>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.warrant,'',calStr);showbox1(calStr,'block',-150,0);" align=absmiddle style="cursor:hand"></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">계약납기</td>
	<td class="bk2_1">&nbsp;
		<textarea name="deliDate" style="width:100;height:40"></textarea>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.deliDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand"></td>
	<td class="bk1_1" align=right  width="120">요구납기</td>
	<td class="bk2_1" width="230">&nbsp;
		<textarea name="demandDate" style="width:100;height:40"></textarea>
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.contractAddForm.demandDate,'',calStr);showbox1(calStr,'block',-150,0);" align=absmiddle style="cursor:hand"></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120">(거래처)계약번호</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" name="contractNum" value="" size="35" maxlength="200" class="inputbox"></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">선급금이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="prepayDeed" value="1" onclick="checkBoxCk(this, 'id_prepay')"></td>
			<td id="id_prepay" style="display:none">
				<input type="text" name="prepayPer" value="" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="prepayStDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.prepayStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="prepayEdDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.prepayEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="prepayContent" style="width:250;height:20" class="inputbox"></textarea></td>
		</tr>
		</table></td>
</tr>



<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">계약이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="conDeed" value="1" onclick="checkBoxCk(this, 'id_con')"></td>
			<td id="id_con" style="display:none">
				<input type="text" name="conPer" value="" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="conStDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.conStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="conEdDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.conEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="conContent" style="width:250;height:20" class="inputbox"></textarea></td>
		</tr>
		</table></td>
</tr>



<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">하자이행증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="defectDeed" value="1" onclick="checkBoxCk(this, 'id_defect')"></td>
			<td id="id_defect" style="display:none">
				<input type="text" name="defectPer" value="" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="defectStDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.defectStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="defectEdDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.defectEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="defectContent" style="width:250;height:20" class="inputbox"></textarea></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">기타증권</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;
				<input type="checkbox" name="etcDeed" value="1" onclick="checkBoxCk(this, 'id_etc')"></td>
			<td id="id_etc" style="display:none">
				<input type="text" name="etcPer" value="" size=3 maxlength=6 class="inputbox"> %
				기간: <input type="text" name="etcStDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.etcStDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">~ 
				<input type="text" name="etcEdDate" value="" size=8 maxlength=8 class="inputbox">
				<IMG SRC="/images/icon/calendar.gif" BORDER="0" onclick="show_cal(document.contractAddForm.etcEdDate,'',calStr);showbox1(calStr,'block',70,0);" align=absmiddle style="cursor:hand">
				내용: <textarea name="etcContent" style="width:250;height:20" class="inputbox"></textarea></td>
		</tr>
		</table></td>
</tr>


<tr height=25>
	<td class="bk1_1" align=right  width="120" bgcolor="#f7f7f7">지체상금율</td>
	<td class="bk2_1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td width="29">&nbsp;
				<input type="checkbox" name="delayDeed" value="1" onclick="checkBoxCk(this, 'id_delay')"></td>
			<td id="id_delay" style="display:none">
				<input type="text" name="delayPer" value="" size=7 maxlength=10 class="inputbox"> %
				내용: <textarea name="delayContent" style="width:250;height:20" class="inputbox"></textarea></td>
		</tr>
		</table></td>
</tr>



<tr height=25>
	<td class="bk1_1" align=right  width="120">설치장소</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" class="inputbox" name="place" value="" size="50" maxlength="200"></td>
</tr>
<tr height=25>
	<td class="bk1_1" align=right  width="120">내부 담당자</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<select name="userId" class="selbox">
			<option value="">▒▒내부담당자▒▒</option>
	<%	Vector vecUser = uDAO.getUserList();
		for( int i=0 ; i<vecUser.size() ; i++ ){	
			User ur  = (User)vecUser.get(i);	%>
			<option value="<%=ur.userId%>"><%=ur.userName%></option>
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
		</tr>
		</table></td>
</tr>
<tr height=25>
	<td class="bk1_bg" align=right  width="120" valign=top>기타사항</td>
	<td colspan=3>
		<textarea name="memo" style="width:580;height:80"></textarea></td>
</tr>
<tr height=2>
	<td colspan=4 align=center class="bgc2"></td>
</tr>
<tr height=28>
	<td colspan=4 align=center class="bgc1">
		<input type="button" value="입력" class="inputbox2" onclick="checkContractAddForm();">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>

</form>
</table>
</BODY>
</HTML>

<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>



<%	Estimate ei = eDAO.selectOne(seq_estimate);		%>
		<form name="estFrm">
		<textarea name="seq_estimate" style="display:none"><%=ei.seq%></textarea>
		<textarea name="title" style="display:none"><%=KUtil.nchk(ei.title)%></textarea>
		<textarea name="totPrice" style="display:none"><%=ei.totPrice%></textarea>
		<textarea name="priceKinds" style="display:none"><%=KUtil.nchk(ei.priceKinds)%></textarea>
		<textarea name="taxPrice" style="display:none"><%=ei.taxPrice%></textarea>
		<input type="hidden" name="isTax" value="<%=ei.isTax%>">
		<input type="hidden" name="limit" value="<%=ei.limitDate%>">
		<input type="hidden" name="language" value="<%=ei.language%>">
		</form>

<%	if( seq_project > 0 ){	
		ProjectDAO pDAO = new ProjectDAO(db);
		ClientDAO cDAO = new ClientDAO(db);
		ClientUserDAO cuDAO = new ClientUserDAO(db);

		Project pj = pDAO.selectOne(seq_project);
		Client cl = cDAO.selectOne(pj.seq_client);
		ClientUser cu = cuDAO.selectOne(pj.seq_clientUser);		%>
		<form name="idxfrm">
		<textarea name="projName" style="display:none"><%=KUtil.nchk(pj.name)%></textarea>
		<textarea name="seq_project" style="display:none"><%=seq_project%></textarea>
		<textarea name="seq_client" style="display:none"><%=cl.seq>0?cl.seq+"":""%></textarea>
		<textarea name="client_name" style="display:none"><%=cl.seq>0?cDAO.getBizName(cl,"KOR"):""%></textarea>
		<textarea name="seq_clientUser" style="display:none"><%=cu.seq>0?cu.seq+"":""%></textarea>
		<textarea name="clientUser_name" style="display:none"><%=cu.seq>0?cu.userName:"미지정"%></textarea>
		</form>
<%	}	%>

<script language="javascript1.2">
editor_generate('memo');

<%	if( seq_project > 0 ){	%>
	var ofrm = document.idxfrm;
	var frm = document.contractAddForm;
	frm.seq_project.value	= ofrm.seq_project.value;
	frm.project_name.value	= ofrm.projName.value;
	frm.title.value	= ofrm.projName.value;
	frm.seq_client.value	= ofrm.seq_client.value;
	frm.client_name.value	= ofrm.client_name.value;
	frm.seq_clientUser.value= ofrm.seq_clientUser.value;
	frm.clientUser_name.value	= ofrm.clientUser_name.value;
<%	}%>
<%	if( seq_estimate > 0 ){		%>
	frm.seq_estimate.value	= document.estFrm.seq_estimate.value;
	frm.estimate_name.value = document.estFrm.title.value;
	frm.isTax.value = document.estFrm.isTax.value;
	frm.conTotPrice.value = document.estFrm.totPrice.value;
	if( document.estFrm.isTax.value == '1' ){	//부가세 별도
		frm.supPrice.value	= Number(document.estFrm.totPrice.value);
		frm.taxPrice.value	= Number(document.estFrm.totPrice.value) * 0.1;
	}else{	//부가세 포함가
		if( frm.language.value=='ENG' ){
			frm.supPrice.value	= Number(document.estFrm.totPrice.value);
			frm.taxPrice.value	= 0;
		}else{
			frm.supPrice.value	= Number( Number(document.estFrm.totPrice.value) - Number(document.estFrm.taxPrice.value)  );
			frm.taxPrice.value	= Number(document.estFrm.taxPrice.value);
		}
	}
	
	frm.priceKinds.value	= document.estFrm.priceKinds.value;
	var flag=false;
	for( var i=0 ; i<frm._priceKinds.length ; i++ ){
		if(frm._priceKinds.options[i].value == document.estFrm.priceKinds.value){
			frm._priceKinds.options[i].selected = true;
			flag = true;
		}
	}
	if( !flag ){
		for( var i=0 ; i<frm._priceKinds.length ; i++ ){
			if(frm._priceKinds.options[i].value == '0'){
				frm._priceKinds.options[i].selected = true;
			}
		}
		show1("id_priceKinds","block");
	}

	//frm.deliDate.value		= document.estFrm.deliDate.value;;
<%	}%>
	int2Com();
	//getNextDate();
	resize(730,675);
</script>

<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
