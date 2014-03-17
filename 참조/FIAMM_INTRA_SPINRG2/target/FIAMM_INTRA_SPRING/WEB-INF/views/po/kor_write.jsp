<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%@ include file="/inc/inc_per_w.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 

	int reload		= KUtil.nchkToInt(request.getParameter("reload"));
	int	seq_project	= KUtil.nchkToInt(request.getParameter("seq_project"));
	int	seq_contract= KUtil.nchkToInt(request.getParameter("seq_contract"));

	ClientDAO cDAO = new ClientDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);
	UserDAO uDAO = new UserDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);	%>

<jsp:include page="/inc/inc_loadingBar.jsp" flush="true"/>

<HTML>
<HEAD>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function showProject(){
	var pop = window.open("inpro_index.jsp?seq_project=<%=seq_project%>","project","scrollbars=0");
	pop.focus();
}
function showClientUser(){
	var lft = (screen.availWidth-400)/2;
	var tp  = (screen.availHeight-380)/2;
	var pop = window.open("fm_index.jsp","client","width=400,height=380,top="+tp+",left="+lft);
	pop.focus();
}
function chEstimate(){
	var frm = document.poForm;
	if( frm.seq_estimate.selectedIndex > 0 ){
		var lft = (screen.availWidth-730)/2;
		var pop = window.open("view_estItem.jsp?seq="+frm.seq_estimate.value+"&rowIndex="+rowIndex,"esti","width=720,height=300,top=0,left="+lft+",scrollbars=1");
		pop.focus();
	}
}
//insert table
function addRow(){
	var str = '';
	var form = document.poForm;
	if(in_table01.rows.length > 14){ 
		alert("15개까지 추가가 가능합니다.");
		return false;
	}
	var oRow = in_table01.insertRow();

	var oCell0 = oRow.insertCell();
	var oCell1 = oRow.insertCell();
	oCell0.innerHTML = "<IMG SRC='/images/icon_close.gif' BORDER='0' style='cursor:hand' onclick='delRow1()'>";
	oCell0.width = 10;
	oCell1.innerHTML = estStr(in_table01.rows.length);
	
}
function delRow(){
	var frm = document.poForm;
	var len = in_table01.rows.length;
	if( len < 1 ){
		return;
	}else{
		in_table01.deleteRow(len-1);
	}
	calc();
}
function delRow1(){
	var obj = event.srcElement;
	//alert(obj.parentNode.parentNode.rowIndex);
	in_table01.deleteRow(obj.parentNode.parentNode.rowIndex);
	calc();
}

function calc(){
	if( !keyCheck() ) return;
	var frm = document.poForm;
	var len = in_table01.rows.length;
	var tot = 0;
	if( len == 1 ){		
		if( frm.itemCnt.value=="" )
			frm.itemCnt.value = 0;
		if( frm.itemPrice.value=="" )
			frm.itemPrice.value = 0;	
		var rowTotPrice = 0;
		if( Number( filterNum(frm.itemPrice.value) ) > 0 ){
			frm.totPrice.value =  
				Number( filterNum(frm.itemCnt.value) ) * Number( filterNum(frm.itemPrice.value) );
		}
		tot += Number( filterNum(frm.totPrice.value) );
	}else if( len > 0 ){
		for( var i=0 ; i<len ; i++ ){
			if( frm.itemCnt[i].value=="" ){
				frm.itemCnt[i].value = 0;
			}
			if( frm.itemPrice[i].value=="" ){
				frm.itemPrice[i].value = 0;	
			}
			var rowTotPrice = 0;
			if( Number( filterNum(frm.itemPrice[i].value) ) > 0 ){
				frm.totPrice[i].value =  
					Number( filterNum(frm.itemCnt[i].value) ) * Number( filterNum(frm.itemPrice[i].value) );
			}
			tot += Number( filterNum(frm.totPrice[i].value) );
		}
	}
	frm.totPrices.value = tot;

	if( frm.isTax.checked ){
		frm.taxPrice.value = 0;
	}else{
		frm.taxPrice.value = Number(tot*0.1);
	}
	frm.poTotPrice1.value = tot + Number( filterNum(frm.taxPrice.value));
	frm.viTotPrice.value = tot + Number( filterNum(frm.taxPrice.value));
	int2Com();
}
function calc1(){
	if( !keyCheck() ) return;
	var frm = document.poForm;
	var len = in_table01.rows.length;
	var tot = 0;
	if( len == 1 ){		
		if( frm.itemCnt.value=="" )
			frm.itemCnt.value = 0;
		if( frm.itemPrice.value=="" )
			frm.itemPrice.value = 0;	
		var rowTotPrice = 0;
		if( Number( filterNum(frm.itemPrice.value) ) > 0 ){
			frm.totPrice.value =  
				Number( filterNum(frm.itemCnt.value) ) * Number( filterNum(frm.itemPrice.value) );
		}
		tot += Number( filterNum(frm.totPrice.value) );
	}else if( len > 0 ){
		for( var i=0 ; i<len ; i++ ){
			if( frm.itemCnt[i].value=="" ){
				frm.itemCnt[i].value = 0;
			}
			if( frm.itemPrice[i].value=="" ){
				frm.itemPrice[i].value = 0;	
			}
			var rowTotPrice = 0;
			if( Number( filterNum(frm.itemPrice[i].value) ) > 0 ){
				frm.totPrice[i].value =  
					Number( filterNum(frm.itemCnt[i].value) ) * Number( filterNum(frm.itemPrice[i].value) );
			}
			tot += Number( filterNum(frm.totPrice[i].value) );
		}
	}
	frm.totPrices.value = tot;

	if( frm.isTax.checked ){
		frm.taxPrice.value = 0;
	}
	frm.poTotPrice1.value = tot + Number( filterNum(frm.taxPrice.value));
	frm.viTotPrice.value = tot + Number( filterNum(frm.taxPrice.value));
	int2Com();
}
function int2Com(){
	var frm = document.poForm;
	var len = in_table01.rows.length;
	for( var i=0 ; i<len ; i++ ){
		if( len == 1 ){
			intToCom(frm.itemCnt);
			intToCom(frm.itemPrice);
			intToCom(frm.totPrice);
		}else{
			intToCom(frm.itemCnt[i]);
			intToCom(frm.itemPrice[i]);
			intToCom(frm.totPrice[i]);
		}
	}
	intToCom(frm.totPrices);
	intToCom(frm.taxPrice);
	intToCom(frm.poTotPrice1);
	intToCom(frm.viTotPrice);
}
function calc2(){
	var frm = document.poForm;
	frm.poTotPrice1.value = Number( filterNum(frm.totPrices.value) ) + Number( filterNum(frm.taxPrices.value) );
	frm.viTotPrice.value = Number( filterNum(frm.totPrices.value) ) + Number( filterNum(frm.totPrices.value) );
	int2Com();
}
function showItem(idx){
	var tp = (screen.availHeight-600)/2;
	var lft = (screen.availWidth-600)/2;
	var len = -1;
	if( idx != '0' ){
		var obj = event.srcElement;
		len = obj.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
	}
	var pop = window.open("item.jsp?idx="+len,"item","width=600,height=600,top="+tp+",left="+lft);
	pop.focus();
}
function poFormCheck(){
	var frm = document.poForm;
	if( !validate(frm) ){
		return;
	}
	fileAllSelect();
	frm.target = "clientUser";
	frm.action = "DBW.jsp";
	frm.submit();
}
function validate(frm){
	var len = in_table01.rows.length;
	if( !nchk(frm.title,"제목") ) return false;
	else if( !nchk(frm.client_name,"PO업체") ) return false;
	else if( !nchk1(frm.priceKinds) ){
		alert("통화를 입력하여 주십시요"); 
		return false;
	}else if( len < 1 ){
		alert("PO 품목을 입력해 주십시요");
		return false;
	}else if( !nchk1(frm.poKind) ){
		alert("머릿말을 입력하여 주십시요"); 
		return false;
	}

	if( frm._poNum.value=="2" ){
		if( !chkNo(frm.poNum,"PO 일련번호") ) return false;
	}
	return true;
}
function popTextArea(obj){
	var lft = (screen.availWidth-550)/2;
	var tp  = (screen.availHeight-200)/2;
	var pop = window.open("pop_textarea.jsp?obj="+obj,"popTextArea","top="+tp+",left="+lft+",width=550,height=200");
}
function chPoNum(){
	var frm = document.poForm;
	if( frm._poNum.value=="1" ){
		show1("id_poNum","none");
	}else{
		show1("id_poNum","block");
		frm.poNum.focus();
	}
	frm.poNum.value="";
}
function chPriceKinds(){
	var frm = document.poForm;
	if( frm._priceKinds.value==0 ){
		frm.priceKinds.value = "";
		show1("id_priceKinds","block");
		frm.priceKinds.focus();
	}else{
		frm.priceKinds.value = frm._priceKinds.value;
		show1("id_priceKinds","none");
	}
}
function chItemUnit(ridx){
	var frm = document.poForm;
	if( eval("document.poForm._itemUnit"+ridx).value==0 ){
		eval("document.poForm.itemUnit"+ridx).value = "";
		eval("document.poForm.itemUnit"+ridx).style.display = "block";
		eval("document.poForm.itemUnit"+ridx).focus();
	}else{
		eval("document.poForm.itemUnit"+ridx).value = eval("document.poForm._itemUnit"+ridx).value;
		eval("document.poForm.itemUnit"+ridx).style.display = "none";
	}
}
function basicForm(lan){
	var pop = window.open("bf_index.jsp?language="+lan,"bFormView","scrollbars=0");
	pop.focus();
}
function viewProject(seq_project){
	var pop = window.open("/main/project/view.jsp?seq="+seq_project,"projectView","scrollbars=0");
	pop.focus();
}
function viewContract(seq_contract){
	var pop = window.open("/main/contract/mod.jsp?seq="+seq_contract,"contractView","scrollbars=0");
	pop.focus();
}
function goEngForm(){
	document.location = "write.jsp?reload=<%=reload%>&seq_project=<%=seq_project%>&seq_contract=<%=seq_contract%>";
}

function chPoKind(){
	var frm = document.poForm;
	if( frm._poKind.value!="4" ){
		document.getElementById("id_poKind").style.display="none";
		if(frm._poKind.value == "1")			frm.poKind.value = "FK";
		else if(frm._poKind.value == "2")		frm.poKind.value = "HB";
		else if(frm._poKind.value == "3")		frm.poKind.value = "HE";
	}else{
		document.getElementById("id_poKind").style.display="block";
		frm.poKind.focus();
	}
	//frm.poKind.value="";
}
</SCRIPT>
</HEAD>

<BODY>



<table cellpadding="0" cellspacing="0" border="0" width="700">
<form name="poForm" method="post" onsubmit="return false;">
<input type="hidden" name="reload" value="<%=reload%>">
<input type="hidden" name="language" value="KOR">
<input type="hidden" name="packing" value="">
<input type="hidden" name="remarks" value="">


<tr height=28>
	<td colspan=4 class="ti1">▶ PO 추가 
		<input type="button" value="영문PO폼 이동" onclick="goEngForm()" class="inputbox2"></td>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height=28>
	<td><input type="button" value="관련 프로젝트 / 계약서" onclick="showProject()" class="inputbox2"></td>
</tr>
<tr>
	<td><table cellpadding="0" cellspacing="1" border="0" width="100%" id="inputTbPro" class="tableoutLine">
		</table></td>
</tr>
</table>

<br>


<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height="20">
<td class="bk1_1" align=right>PO 머릿말:</td>
<td class="bk2_1" >&nbsp;
		<select name="_poKind" class="selbox1" onchange="chPoKind();">
			<option value="1">FK</option>
			<option value="2">HB</option>
			<option value="3">HE</option>
			<option value="4">기타</option>
		</select></td>
<td colspan=2 class="bk2_1">
		<table cellpadding="0" cellspacing="0" border="0" id="id_poKind" style="display:none">
		<tr>
			<td width="120" class="bk1_1" align=right><B>머릿말 직접입력 :</B></td>
			<td class="bk2_1">&nbsp;
				<input type="text" name="poKind"  value="" size="8" maxlength="8" class="inputbox1"></td>
		</tr>
		</table></td>		
		
		
</tr>
<tr height=20>
	<td class="bk1_1" align=right>PO 제목 :</td>
	<td class="bk2_1">&nbsp;
		<input type="text" class="inputbox1" name="title" value="" style="width:92%" maxlength="200" ></td>
	<td class="bk1_1" align=right>Date :</td>
	<td class="bk2_1">&nbsp;
	<input type="text" name="wDate" value="<%=KUtil.getDate("yyyyMMdd")%>" size="10" class="inputbox1">
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.poForm.wDate,'',calStr);showbox1(calStr,'block',-210,-80);" align=absmiddle style="cursor:hand"></td>
</tr>
<tr height=20>
	<td width="120" class="bk1_1" align=right>
		To :</td>
	<td class="bk2_1" width="230">&nbsp;
		<input type="text" class="inputbox1" name="client_name" value="" size="15" readonly>
		<input type="hidden" name="seq_client" value="">
		<input type="button" value="업체/담당" onclick="showClientUser()" class="inputbox2"></td>
	<td width="120" class="bk1_1" align=right>
		Atten :</td>
	<td class="bk2_1" width="230">&nbsp;
		<textarea name="clientUser_name" style="height:20;width:200" readonly></textarea>
		<input type="hidden" name="seq_clientUser" value=""></td>
</tr>

<tr height=20>
	<td class="bk1_1" align=right>PO NO. :</td>
	<td class="bk2_1">&nbsp;
		<select name="_poNum" class="selbox1" onchange="chPoNum()">
			<option value="1">자동</option>
			<option value="2">직접입력</option>
		</select></td>
	<td colspan=2 class="bk2_1">
		<table cellpadding="0" cellspacing="0" border="0" id="id_poNum" style="display:none">
		<tr>
			<td width="120" class="bk1_1" align=right><B>PO NO. :</B></td>
			<td class="bk2_1">&nbsp;
				<input type="text" name="poNum" value="" size="8" maxlength="8" class="inputbox1"></td>
		</tr>
		</table></td>
</tr>

<tr height=20>
	<td class="bk1_1" align=right>End-User :</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" name="endUser" value="" size="20" class="inputbox"></td>
</tr>
<tr height=7>
	<td colspan=4></td>
</tr>
<tr height=1 bgcolor="#000000">
	<td colspan=4></td>
</tr>
<tr height=1>
	<td colspan=4></td>
</tr>
<tr height=1 bgcolor="#000000">
	<td colspan=4></td>
</tr>
<tr height=7>
	<td></td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr>
	<td colspan=3><input type="button" value="기본폼선택" class="inputbox2" onclick="basicForm('KOR')"></td>
</tr>
<tr height=20 valign=top>
	<td width="100"><A HREF="javascript:popTextArea('timeDeli')"><B id="id_tod">납 기</B></A></td>
	<td width=10><B>:</B></td>
	<td><textarea name="timeDeli" style="width:100%;height:20" wrap="VIRTUAL"></textarea></td>
</tr>
<tr height=20 valign=top>
	<td><A HREF="javascript:popTextArea('termPayMemo')"><B id="id_top">결재조건</B></A></td>
	<td width=10><B>:</B></td>
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td><textarea name="termPayMemo" style="width:100%;height:20;display:block" wrap="VIRTUAL"></textarea></td>
		</tr>
		</table></td>
</tr>
<tr height=20 valign=top>
	<td><A HREF="javascript:popTextArea('termDeliMemo')"><B id="id_pod">납품조건</B></A></td>
	<td width=10><B>:</B></td>
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td><textarea name="termDeliMemo" style="width:100%;height:20;display:block" wrap="VIRTUAL"></textarea></td>
		</tr>
		</table></td>
</tr>
</table>



<!------------------품목------------------------>
<table cellpadding="0" cellspacing="0" border="0" width="700" style="border: 1px solid #FF0000;">
<tr>
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="700">
		<tr>
			<td align=right>
				<a href="javascript:" onclick="showItem('0')"><FONT COLOR="#CC0000">(+)</FONT></a> 
				<a href="javascript:" onclick="delRow()"><FONT COLOR="#CC0000">(-)</FONT></a></td>
		</tr>
		</table>

		<table cellpadding="0" cellspacing="1" border="0" width="700">
		<tr class="title_bg_1" height=25>
			<td colspan=5>
				<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>&nbsp;<B>PO 金額 :</B> </td>
					<td><input type="text" class="inputbox" name="viTotPrice" value="0" size="12" maxlength=20 onblur="intToCom(this);"></td>
					<td>
						<select name="_priceKinds" class="selbox1" onchange="chPriceKinds()">
					<%	Vector vecPriceKinds = pkDAO.getList();
						for( int i=0 ; i<vecPriceKinds.size() ; i++ ){	
							String priceKinds  = (String)vecPriceKinds.get(i);	%>
							<option value="<%=priceKinds%>"><%=priceKinds%></option>
					<%	}//for	%>
							<option value="0">직접입력</option>
						</select></td>
					<td id="id_priceKinds" style="display:none;padding:0 2 0 2">
						<input type="text" name="priceKinds" value="\" class="inputbox1" size=5 maxlength="50"></td>
				</tr>
				</table></td>
		</tr>
		<tr align=center class="title_bg" height=25>
			<td width="200">品 名</td>
			<td width="200">規 格</td>
			<td width="90">數 量</td>
			<td width="100">單 價</td>
			<td width="110">金 額</td>
		</tr>
		</table>
		<!-- insert 테이블 -->
		<table cellpadding="0" cellspacing="1" border="0" width="700" name="in_table01" id="in_table01" >
		</table>
		<!-- total -->
		<table cellpadding="0" cellspacing="1" border="0" width="700">
		<tr align=center height=25>
			<td width="200" class="title_bg">供給價額</td>
			<td width="390" class="r_bg">&nbsp;</td>
			<td width="110" class="title_bg"><input type="text" class="inputbox" name="totPrices" value="0" size="12" maxlength=20 readonly></td>
		</tr>
		<tr align=center height=25>
			<td class="title_bg">附加價値稅</td>
			<td class="r_bg" align=left>&nbsp;
				<input type="checkbox" name="isTax" value="1" onclick="calc()" checked> 부가세 별도</td>
			<td class="title_bg"><input type="text" class="inputbox" name="taxPrice" value="0" size="12" maxlength=20 onBlur="calc1()"></td>
		</tr>
		<tr align=center height=25>
			<td class="title_bg">合 計</td>
			<td class="r_bg">&nbsp;</td>
			<td class="title_bg"><input type="text" class="inputbox" name="poTotPrice1" value="0" size="12" maxlength=20 readonly></td>
		</tr>
		</table></td>
</tr>
</table>
<!-- 품목 종료 -->

<br>

<!-- 부가정보 -->
<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=20>
	<td width="100" align=right class="bk1_1"><B>기타첨부파일</B></td>
	<td class="bk2_1">
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
<tr align=center height=30>
	<td colspan=2 class="bmenu">
		<input type="button" value="PO 입력" onclick="poFormCheck()" class="inputbox2">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</form>
</table>






<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>

<iframe name="clientUser" id="clientUser" width="0" height="0"></iframe>
<iframe name="itemList" id="itemList" width="0" height="0"></iframe>

</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
resize(730, 700);
</SCRIPT>

<%
	if( seq_project > 0 ){
		KUtil.scriptOut(out,"document.frames['itemList'].location='write_item_init.jsp?seq_project="+seq_project+"&seq_contract="+seq_contract+"';");
	}
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
