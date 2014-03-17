<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="po"/>
	<jsp:param name="col" value="M"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();
try{ 
	int seq_po		= KUtil.nchkToInt(request.getParameter("seq_po"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));

	//생성자
	PoDAO poDAO				= new PoDAO(db);
	LinkDAO lkDAO			= new LinkDAO(db);
	ProjectDAO pjDAO		= new ProjectDAO(db);
	ContractDAO ctDAO		= new ContractDAO(db);
	ClientDAO cDAO			= new ClientDAO(db);
	ClientUserDAO cuDAO		= new ClientUserDAO(db);
	UserDAO uDAO			= new UserDAO(db);
	ItemDAO iDAO			= new ItemDAO(db);
	PoItemDAO piDAO			= new PoItemDAO(db);
	PriceKindsDAO pkDAO		= new PriceKindsDAO(db);

	//품목 분류가 되었는지 검사
	PassItemLnkDAO pilDAO= new PassItemLnkDAO(db);
	int pil_cnt = pilDAO.getCntPo(seq_po);
	

	Po po				= poDAO.selectOne(seq_po);
	Client cl			= cDAO.selectOne(po.seq_client);
	String[] clientUser	= cuDAO.getList(po.seq_clientUser);
	Vector vecLink		= lkDAO.getList(seq_po);
	
	boolean flag = false;
%>

<jsp:include page="/inc/inc_loadingBar.jsp" flush="true"/>



<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
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
	frm.viTotPrice.value = tot;
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
	frm.viTotPrice.value = tot;
	int2Com();
}
function calc2(){
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
	intToCom(frm.viTotPrice);
}
function showProject(){
	var lft = (screen.availWidth-800)/2;
	var tp  = (screen.availHeight-500)/2;
	var pop = window.open("inpro_index.jsp","project","width=800,height=500,top="+tp+",left="+lft);
	pop.focus();
}
function showClientUser(){
	var lft = (screen.availWidth-410)/2;
	var tp	= (screen.availHeight-380)/2;
	var pop = window.open("fm_index.jsp","client","width=400,height=380,top="+tp+",left="+lft);
	pop.focus();
}
function initRowCnt(){
	for( var i=rowIndex ; i>0 ; i-- ){
		delRow();
	}
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
function openWinPo(){
	var frm = document.poForm;
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-500)/2;
	var pop = window.open("mod_item.jsp?seq_po=<%=seq_po%>","opWin","scrollbars=1,width=720,height=500,top="+tp+",left="+lft);
	pop.focus();
}
function poFormCheck(){
	var frm = document.poForm;
	if( !validate(frm) ){
		return;
	}
	fileAllSelect();
	frm.target = "clientUser";
	frm.action = "DBM.jsp";
	frm.submit();
}
function poRevision(){
	var frm = document.poForm;
	if( !validate(frm) ){
		return;
	}
	fileAllSelect();
	frm.target = "clientUser";
	frm.action = "DBRW.jsp";
	frm.submit();

}
function poRNew(){
	var frm = document.poForm;
	if( !validate(frm) ){
		return;
	}
	fileAllSelect();
	frm.target = "clientUser";
	frm.action = "DBRNW.jsp";
	frm.submit();

}
function validate(frm){
	var len = in_table01.rows.length;
	if( !nchk(frm.title,"제목") ) return false;
	else if( !nchk(frm.client_name,"발주업체") ) return false;
	else if( len < 1 ){
		alert("PO 품목을 입력해 주십시요");
		return false;
	}
	return true;
}
function initItem(){
	document.frames['itemList'].location="mod_item_init.jsp?seq_po=<%=seq_po%>";
}
function rowIndexAdd(idx){
	var frm = document.poForm;
	rowIndex=idx;
	frm.rowCount.value = idx;
}
function delItem(idx){
	var seq_poitem = eval("document.poForm.seq_poitem"+idx).value;
	if( confirm("삭제하시겠습니까?") ){
		document.frames['clientUser'].location = "item_DBD.jsp?seq_poitem="+seq_poitem;	
	}
}
function popTextArea(obj){
	var lft = (screen.availWidth-550)/2;
	var tp  = (screen.availHeight-200)/2;
	var pop = window.open("pop_textarea.jsp?obj="+obj,"popTextArea","top="+tp+",left="+lft+",width=550,height=200");
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
function chItemUnit(obj){
	var frm = document.poForm;
	var len = in_table01.rows.length;
	for( var i=0 ; i<len ; i++ ){
		if( len == 1 ){
			if( obj.value==0 ){
				frm.itemUnit.value = "";
				frm.itemUnit.style.display = "block";
				frm.itemUnit.focus();
			}else{
				frm.itemUnit.value = frm._itemUnit.value;
				frm.itemUnit.style.display = "none";
			}
		}else{
			if( obj == frm._itemUnit[i] ){
				if( obj.value==0 ){
					frm.itemUnit[i].value = "";
					frm.itemUnit[i].style.display = "block";
					frm.itemUnit[i].focus();
				}else{
					frm.itemUnit[i].value = frm._itemUnit[i].value;
					frm.itemUnit[i].style.display = "none";
				}
			}			
		}
	}
}
function go_print_preview(w){
	var frm = document.poForm;
	if( w=='e' ){
		document.location = "printPo.jsp?seq_po=<%=seq_po%>&reload=<%=reload%>";
	}else{
		document.location = "printPo_kor.jsp?seq_po=<%=seq_po%>&reload=<%=reload%>";
	}
}
function poDel(){
	if( confirm("삭제하시겠습니까?") ){
		document.location = "DBD.jsp?seq_po=<%=seq_po%>&reload=<%=reload%>";
	}
}
function delLink(seq_link){
	if( confirm("관련 프로젝트 링크를 삭제하시겠습니까?") ){
		document.frames['clientUser'].location = "link_DBD.jsp?seq_link="+seq_link;	
	}
}
function chTermDeli(){
	var frm = document.poForm;
	if( frm._termDeli.value=='0' ){
		frm.termDeli.value="";
		frm.termDeli.style.display = "block";
	}else{
		frm.termDeli.value = frm._termDeli.value;
		frm.termDeli.style.display = "none";
	}
}
function chTermPay(){
	var frm = document.poForm;
	if( frm._termPay.value=='0' ){
		frm.termPay.value="";
		frm.termPay.style.display = "block";
	}else{
		frm.termPay.value = frm._termPay.value;
		frm.termPay.style.display = "none";
	}
}
function basicForm(){
	var pop = window.open("bf_index.jsp","bFormView","scrollbars=0");
	pop.focus();
}
function viewProject(seq){
	var pop = window.open("/main/project/view.jsp?seq="+seq,"viewProject","scrollbars=0");
	pop.focus();
	
}
function viewContract(seq){
	var pop = window.open("/main/contract/mod.jsp?seq="+seq,"viewContract","scrollbars=0");
	pop.focus();
	
}
function repage(){
	
	document.location.href = "mod.jsp?seq_po=<%=seq_po%>";
}
function modSeq_pnc(){
	var frm = document.poForm;
	if( confirm("수정하시겠습니까?") ){
		frm.target = "clientUser";
		frm.action = "link_DBM.jsp";
		frm.submit();
	}	
}
function chPoKind(){
	var frm = document.poForm;

	
	if( frm._poKind.value!="3" ){
		document.getElementById("id_poKind").style.display="none";
		if(frm._poKind.value == "1")			frm.poKind.value = "FK";
		else if(frm._poKind.value == "2")		frm.poKind.value = "HB";
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

<input type="hidden" name="defaultRowCount" value="0">
<input type="hidden" name="rowCount" value="0">
<input type="hidden" name="seq_po" value="<%=seq_po%>">
<input type="hidden" name="reload" value="<%=reload%>">
<input type="hidden" name="language" value="<%=po.language%>">


<tr height=28>
	<td colspan=4 class="ti1">▶ PO 수정</td>
</tr>
</table>

<!------------------PO------------------------>
<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height=28>
	<td><input type="button" value="관련 프로젝트 / 계약서 선택" onclick="showProject()" class="inputbox2">
		<input type="button" value="관련 프로젝트 / 계약서 수정" onclick="modSeq_pnc()" class="inputbox2"></td>
</tr>
<tr>
	<td><table cellpadding="0" cellspacing="0" border="0" width="580" style="border: 1px solid #FF0000;">
		<%	for( int i=0 ; i<vecLink.size() ; i++ ){	
			dao.Link lk = (dao.Link)vecLink.get(i);
			Project pj	= pjDAO.selectOne(lk.seq_project);	
			Contract ct = ctDAO.selectOne(lk.seq_contract);%>
		<tr>
			<td>&nbsp;
				○ <A HREF="javascript:;" onclick="viewProject(<%=pj.seq%>)"><%=KUtil.nchk(pj.name)%></A> 
				<%	if( ct.seq>0 ){	%>
				  / <A HREF="javascript:;" onclick="viewContract(<%=ct.seq%>)"><%=ctDAO.getContractNo(ct)%></A>
				<%	}	%>
				<input type="hidden" name="seq_pnc_" value="<%=pj.seq+"@"+ct.seq%>">
				<A HREF="javascript:delLink('<%=lk.seq%>')"><FONT COLOR="#A6A6FF">[삭제]</FONT></A></td>
		</tr>
		<%	}//for	%>
		<tr>
			<td><table cellpadding="0" cellspacing="1" border="0" width="580" id="inputTbPro">
				</table></td>
		</tr>
		</table></td>
</tr>
</table>

<br>



<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height=20>
	<td class="bk1_1" align=right>PO Title :</td>
	<td class="bk2_1">&nbsp;
		<input type="text" class="inputbox1" name="title" value="<%=po.title%>" style="width:92%" maxlength="200" ></td>
	<td class="bk1_1" align=right>Date :</td>
	<td class="bk2_1">&nbsp;
	<input type="text" name="wDate" value="<%=po.wDate>0?po.wDate+"":""%>" size="10" class="inputbox1">
		<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.poForm.wDate,'',calStr);showbox1(calStr,'block',-210,-80);" align=absmiddle style="cursor:hand"></td>
</tr>

<tr height=20>
	<td width="120" class="bk1_1" align=right>
		To :</td>
	<td class="bk2_1" width="230">&nbsp;
		<input type="text" class="inputbox1" name="client_name" value="<%=cl.bizName%>" size="15" readonly>
		<input type="hidden" name="seq_client" value="<%=cl.seq%>">
		<input type="button" value="업체/담당" onclick="showClientUser()" class="inputbox2"></td>
	<td width="120" class="bk1_1" align=right>
		Atten :</td>
	<td class="bk2_1" width="230">&nbsp;
		<textarea name="clientUser_name" style="height:20;width:200" readonly><%=KUtil.nchk(clientUser[1])%></textarea>
		<input type="hidden" name="seq_clientUser" value="<%=KUtil.nchk(clientUser[0])%>"></td>
</tr>
<tr height="20">
<td class="bk1_1" align=right>PO 머릿말:</td>
<td class="bk2_1" >&nbsp;
		<select name="_poKind" class="selbox1" onchange="chPoKind();">
			<option value="1" <%if("FK".equals(po.poKind)){ %>selected<%} %>>FK</option>
			<option value="2" <%if("HB".equals(po.poKind)){ %>selected<%} %>>HB</option>
			<option value="3" <%if(!"HB".equals(po.poKind) && !"FK".equals(po.poKind)){ %>selected<%} %>>기타</option>
		</select></td>
<td colspan=2 class="bk2_1">
		<table cellpadding="0" cellspacing="0" border="0" id="id_poKind" <%if("HB".equals(po.poKind) || "FK".equals(po.poKind)){ %>style="display:none"<%} %>>
		<tr>
			<td width="120" class="bk1_1" align=right><B>머릿말 직접입력 :</B></td>
			<td class="bk2_1">&nbsp;
				<input type="text" name="poKind"  value="<%if(!"HB".equals(po.poKind) && !"FK".equals(po.poKind)){ out.write(po.poKind); } %>" size="8" maxlength="8" class="inputbox1"></td>
		</tr>
		</table></td>		
</tr>
<tr height=20>
	<td class="bk1_1" align=right>PO NO. :</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<%=poDAO.getPoNo(po)%></td>
</tr>

<tr height=20>
	<td class="bk1_1" align=right>End-User :</td>
	<td class="bk2_1" colspan=3>&nbsp;
		<input type="text" name="endUser" value="<%=KUtil.nchk(po.endUser)%>" size="20" class="inputbox"></td>
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
	<td colspan=3><input type="button" value="기본폼선택" class="inputbox2" onclick="basicForm()"></td>
</tr>
<tr height=25 valign=top>
	<td width="160"><A HREF="javascript:popTextArea('timeDeli')"><B>TIME OF DELIVERY</B></A></td>
	<td width=10><B>:</B></td>
	<td><textarea name="timeDeli" style="width:530;height:20" wrap="VIRTUAL"><%=KUtil.nchk(po.timeDeli)%></textarea></td>
</tr>
<tr height=25 valign=top>
	<td><A HREF="javascript:popTextArea('termDeli')"><B>PLACE OF DELIVERY</B></A></td>
	<td width=10><B>:</B></td>
	<td><table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td width="100">
				<%	po.termDeli = KUtil.nchk(po.termDeli);	%>
				<select name="termDeli" class="selbox">
					<option value="">▒▒선택▒▒</option>
					<option value="Ex-work" <%if( po.termDeli.equals("Ex-work") ){out.println("selected"); flag=true;}%>>Ex-work</option>
					<option value="FOB" <%=po.termDeli.equals("FOB")?"selected":""%>>FOB</option>
					<option value="CIF" <%=po.termDeli.equals("CIF")?"selected":""%>>CIF</option>
					<option value="CPT" <%=po.termDeli.equals("CPT")?"selected":""%>>CPT</option>
				</select></td>
			<td><textarea name="termDeliMemo" style="width:100%;height:20;"><%=KUtil.nchk(po.termDeliMemo)%></textarea></td>
		</tr>
		</table></td>
</tr>
<tr height=25 valign=top>
	<td><A HREF="javascript:popTextArea('termPay')"><B>TERM OF PAYMENT</B></A></td>
	<td width=10><B>:</B></td>
	<td><table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td width="100">
				<%	po.termPay = KUtil.nchk(po.termPay);	%>
				<select name="termPay" class="selbox">
					<option value="">▒▒선택▒▒</option>
					<option value="By L/C" <%=po.termPay.equals("By L/C")?"selected":""%>>By L/C</option>
					<option value="By T/T" <%=po.termPay.equals("By T/T")?"selected":""%>>By T/T</option>
					<option value="By FOC" <%=po.termPay.equals("By FOC")?"selected":""%>>By FOC</option>
					<option value="By L/C,T/T" <%=po.termPay.equals("By L/C,T/T")?"selected":""%>>By L/C,T/T</option>
				</select></td>
			<td><textarea name="termPayMemo" style="width:100%;height:20;"><%=KUtil.nchk(po.termPayMemo)%></textarea></td>
		</tr>
		</table></td>
</tr>
<tr height=25 valign=top>
	<td><A HREF="javascript:popTextArea('packing')"><B>PACKING</B></A></td>
	<td width=10><B>:</B></td>
	<td><textarea name="packing" style="width:530;height:20" wrap="VIRTUAL"><%=KUtil.nchk(po.packing)%></textarea></td>
</tr>
<tr height=25 valign=top>
	<td><A HREF="javascript:popTextArea('remarks')"><B>REMARKS</B></A></td>
	<td width=10><B>:</B></td>
	<td><textarea name="remarks" style="width:530;height:20" wrap="VIRTUAL"><%=KUtil.nchk(po.remarks)%></textarea></td>
</tr>
</table>




<!------------------품목------------------------>
<table cellpadding="0" cellspacing="0" border="0" width="700" style="border: 1px solid #FF0000;">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="700">
	<tr height=25>
		<td><input type="hidden" name="isModItem" value="1">
			<!-- 관련 프록젝트 및 품목수정 (상단의 <FONT COLOR="#FF0000">관련 프로젝트</FONT>나 아래 <FONT COLOR="#FF0000">품목이 수정</FONT>되었을 경우 <FONT COLOR="#FF0000">체크</FONT>해 주십시요) --></td>
		<td align=right>
			<a href="javascript:showItem('0')"><FONT COLOR="#CC0000">(+)</FONT></a> 
			<a href="javascript:delRow()"><FONT COLOR="#CC0000">(-)</FONT></a></td>
	</tr>
	</table>

	<table cellpadding="0" cellspacing="1" border="0" width="700">
	<tr class="title_bg" height=25>
		<td colspan=5>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>&nbsp;<B>Currency :</B> </td>
				<td>
					<select name="_priceKinds" class="selbox1" onchange="chPriceKinds()">
				<%	flag = false;
					Vector vecPriceKinds = pkDAO.getList();
					for( int i=0 ; i<vecPriceKinds.size() ; i++ ){	
						String priceKinds  = (String)vecPriceKinds.get(i);	%>
						<option value="<%=priceKinds%>" <%if( priceKinds.equals(po.priceKinds) ){ out.println("selected"); flag = true;}%>><%=priceKinds%></option>
				<%	}//for	%>
						<option value="0" <%=flag?"":"selected"%>>직접입력</option>
					</select></td>
				<td id="id_priceKinds" style="display:<%=flag?"none":"block"%>;padding:0 2 0 2">
					<input type="text" name="priceKinds" value="<%=po.priceKinds%>" class="inputbox1" size=5 maxlength="50"></td>
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
	<table cellpadding="0" cellspacing="1" border="0" width="700" name="in_table01" id="in_table01">
	</table>
	<!-- total -->
	<table cellpadding="0" cellspacing="1" border="0" width="700">
	<tr align=center height=25>
		<td width="591" class="title_bg">TOTAL</td>
		<td width="110" class="title_bg">
			<input type="text" name="viTotPrice" value="" size="12" maxlength=20 class="inputbox" onblur="intToCom(this)"></td>
	</tr>
	</table></td>
</tr>
</table>
<!----------품목 종료------------>

<br>



<table cellpadding="0" cellspacing="1" border="0" width="700">
<tr height=20>
	<td align=right class="bk1_1" width="100"><B>첨부파일 :</B></td>
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
			<td valign=top style="padding-left:5"><%=FileCtl.fileViewLink(po.fileName,"",po.seq,"po",",",1)%></td>
		</tr>
		</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr height=2 class="bgc2">
	<td></td>
</tr>
<tr align=center height=28 class="bgc1">
	<td>
	<%	if( pil_cnt == 0 ){	%>
		<input type="submit" value="PO 수정" onclick="poFormCheck()" class="inputbox2"> 
		<input type="submit" value="PO 삭제" onclick="poDel()" class="inputbox2">
	<%	}	%>
		<input type="button" value="PO New" onclick="poRNew()" class="inputbox2">
		<input type="button" value="PO Revision" onclick="poRevision()" class="inputbox2">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</form>
</tr>
</table>






<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>

<iframe name="clientUser" id="clientUser" width="0" height="0" frameborder=0></iframe>
<iframe name="itemList" id="itemList" width="0" height="0" frameborder=0></iframe>

</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
initItem();
resize(740, 700);
</SCRIPT>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
