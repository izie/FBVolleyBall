<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="estimate"/>
	<jsp:param name="col" value="W"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>

<%
	Database db = new Database();
try{
	ClientDAO cDAO		= new ClientDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	ProjectDAO pDAO		= new ProjectDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);

	//request
	int seq_project		= KUtil.nchkToInt(request.getParameter("seq_project"));
	int reload			= KUtil.nchkToInt(request.getParameter("reload"));
	int reloadval		= KUtil.nchkToInt(request.getParameter("reloadval"));
	int seq_client_temp	= KUtil.nchkToInt(request.getParameter("seq_client_temp"));

	Client cl1 = cDAO.selectOne(seq_client_temp);				%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="/common/inputstr.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
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
function showProject(seq_client){
	var lft = (screen.availWidth-550)/2;
	var tp = (screen.availHeight-500)/2;
	var pop = window.open("fm_index.jsp?seq_client=<%=seq_client_temp%>","project","width=550,height=500,top=0,left="+lft);
	pop.focus();
}
//insert table
function addRow(){
	var str = '';
	var form = document.estimateForm;
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
	var frm = document.estimateForm;
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
	var frm = document.estimateForm;
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
	var frm = document.estimateForm;
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
function int2Com(){
	var frm = document.estimateForm;
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
function estimateFormCheck(){
	var frm = document.estimateForm;
	frm.action = "DBW.jsp";
	if( !validate(frm) ){
		return;
	}
	frm.submit();
}
function validate(frm){
	var len = in_table01.rows.length;
	if( !nchk(frm.projName,"프로젝트") ) return false;
	else if( !dateCheck(frm.wDate, "견적일") ) return false;
	if( frm._estNum.value=="2" ){
		if( !chkNo(frm.estNum,"견적서 일련번호") ) return false;
		if( nchk1(frm.estNumIncre) ){
			if( !onlyNumber(frm.estNumIncre,"견적서 일련번호 증가치") ) return false;
			else if( Number(frm.estNumIncre.value) < 1 ){
				alert("견적서 일련번호 증가치는 1보다 큰 수를 입력해야 합니다."); 
				frm.estNumIncre.focus();
				return false;
			}
		}
	}
	
	if( !nchk(frm.title,"제목") ) return false;
	else if( !nchk1(frm.priceKinds) ){
		alert("통화를 입력하여 주십시요"); 
		return false;
	}else if( len < 1 ){
		alert("견적 품목을 입력해 주십시요");
		return false;
	}
	if( !nchk1(frm.estKind) ){
		alert("머릿말을 입력하여 주십시요"); 
		frm.estKind.focus();
		return false;
	}
	
	return true;
}
function chPayKinds(){
	var frm = document.estimateForm;
	if( frm._payKinds.value==0 ){
		frm.payKinds.value = "";
		frm.payKinds.style.display = "block";
		frm.payKinds.focus();
	}else{
		frm.payKinds.value = frm._payKinds.value;
		frm.payKinds.style.display = "none";
	}
}
function chEstNum(){
	var frm = document.estimateForm;
	if( frm._estNum.value=="2" ){
		show1("id_estNum","block");
		frm.estNum.focus();
	}else{
		show1("id_estNum","none");
	}
	frm.estNum.value="";
	frm.estNumIncre.value="";
}
function basicForm(){
	var lft = (screen.availWidth-500)/2;
	var tp	= (screen.availHeight-490)/2;
	var pop = window.open("frm_index.jsp","formView","width=500,height=490,top="+tp+",left="+lft);
	pop.focus();
}
function chPriceKinds(){
	var frm = document.estimateForm;
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
	var frm = document.estimateForm;
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
function viewClientUser(){
	var frm = document.estimateForm;
	var lft = (screen.availWidth-300)/2;
	var tp  = (screen.availHeight-500)/2;
	var pop = window.open("list_clientUser_pop.jsp?seq_client="+frm.seq_client.value,"clientUser","width=300,height=500,top="+tp+",left="+lft);
	pop.focus();
}
function goKorWrite(){
	var frm = document.estimateForm;
	frm.action = "write.jsp";
	frm.submit();
}
function chEstKind(){
	var frm = document.estimateForm;
	if( frm._estKind.value!="4" ){
		document.getElementById("id_estKind").style.display="none";
		if(frm._estKind.value == "1"){
			frm.estKind.value = "FK";
			document.getElementById("addr_HB").style.display="none";
			document.getElementById("addr_HE").style.display="none";
			document.getElementById("addr_FK").style.display="block";
		}else if(frm._estKind.value == "2"){
			document.getElementById("addr_HB").style.display="block";
			document.getElementById("addr_HE").style.display="none";
			document.getElementById("addr_FK").style.display="none";
			frm.estKind.value = "HB";
		}else if(frm._estKind.value == "3")	{
			document.getElementById("addr_HB").style.display="none";
			document.getElementById("addr_HE").style.display="block";
			document.getElementById("addr_FK").style.display="none";
			frm.estKind.value = "HE";
		}
	}else{
		document.getElementById("id_estKind").style.display="block";
		document.getElementById("addr_HB").style.display="none";
		document.getElementById("addr_HE").style.display="none";
		document.getElementById("addr_FK").style.display="block";
		frm.estKind.focus();
	}
	//frm.poKind.value="";
}
</SCRIPT>
</HEAD>

<BODY class="xnoscroll">



<table cellpadding="2" cellspacing="2" border="0" width="700" style="margin-left:10px;">

<form name="estimateForm" method="post" onsubmit="return false;">
<input type="hidden" name="reload" value="<%=reload%>">
<input type="hidden" name="reloadval" value="<%=reloadval%>">
<input type="hidden" name="language" value="ENG">
<input type="hidden" name="seq_clientUser" value="">
<input type="hidden" name="clientUser_name" value="">
<input type="hidden" name="seq_client_temp" value="<%=seq_client_temp%>">


<tr align=center height=35>
	<td colspan=2 style="line-height:280%"><h2><U>Quotation</U></h2></td>
</tr>
<tr>
	<td width="480">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td>견적서 머릿말: <select name="_estKind" class="selbox1" onchange="chEstKind();">
			<option value="1">FK</option>
			<option value="2">HB</option>
			<option value="3">HE</option>
			<option value="4">기타</option>
		</select></td>
		</tr>
		<tr>
			<td><table cellpadding="0" cellspacing="0" border="0" id="id_estKind" style="display:none">
		<tr>
			<td>머릿말 직접입력 :
				<input type="text" name="estKind"  value="FK" size="8" maxlength="8" class="inputbox1"></td>
		</tr>
		</table></td>
		</tr>
		<tr>
			<td>Project : <input type="hidden" name="seq_project" value="">
				  <input type="text" class="inputbox1" name="projName" value="" size="25" readonly>
				  <input type="button" value="프로젝트선택" onclick="showProject()" class="inputbox2"></td>
		</tr>
		<tr>
			<td>Customer : <input type="hidden" name="seq_client" value="<%=seq_client_temp%>">
				   <input type="text" class="inputbox1" name="client_name" value="<%=KUtil.nchk(cl1.bizName)%>" size="25" readonly></td>
		</tr>
		</table></td>
	<td align=right>
		<table cellpadding="0" cellspacing="0" border="0" width="200">
		<tr>
			<td>Date : 
				<input type="text" name="wDate" value="<%=KUtil.getDate("yyyyMMdd")%>" size="8" class="inputbox1">
				<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.estimateForm.wDate,'',calStr);showbox1(calStr,'block',-200,-80);" align=absmiddle style="cursor:hand"></td>
		</tr>
		<tr>
			<td>
				<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>Offer NO. :&nbsp;</td>
					<td><select name="_estNum" class="selbox1" onchange="chEstNum()">
							<option value="1">자동</option>
							<option value="2">직접입력</option>
							<option value="3">메일견적</option>
							<option value="4">구두견적</option>
						</select></td>
				</tr>
				<tr id="id_estNum" style="display:none">
					<td colspan=2>
						<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td>견적 NO. : <input type="text" name="estNum" value="" size="8" maxlength="8" class="inputbox1"> ex)2004001</td>
						</tr>
						<tr>
							<td>Revision: <input type="text" name="estNumIncre" size="2" maxlength="2" value="" class="inputbox"></td>
						</tr>
						</table></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2>&nbsp;</td>
</tr>
<tr>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>Currency :</td>
			<td style="padding:0 2 0 2">
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
<tr>
	<td>견적구분 : 
		<input type="checkbox" name="isUnit" value="개별견적"> 개별견적</td>
	<td align=right><span onclick="showItem('0')" style="cursor:hand">(+)</span> 
		<span onclick="delRow()" style="cursor:hand">(-)</span></td>
</tr>
<tr>
	<td colspan=2>
		<table cellpadding="0" cellspacing="1" border="0" width="100%">
		<tr align=center class="title_bg" height=28>
			<td width="10"><IMG SRC="/images/1x1.gif" BORDER="0" ALT=""></td>
			<td width="195">Commodity</td>
			<td width="195">Description</td>
			<td width="90">Q'ty</td>
			<td width="100">Unit Price</td>
			<td width="110">Amount</td>
		</tr>
		<tr>
			<td colspan=6 class="bgc1">Title : <input type="text" class="inputbox1" name="title" value="" style="width:600" maxlength=200></td>
		</tr>
		</table>
		
		<!-- insert table -->
		<table cellpadding="0" cellspacing="1" border="0" width="100%" name="in_table01" id="in_table01">
		</table>
		
		<table cellpadding="0" cellspacing="1" border="0" width="100%">
		<tr align=center height=30>
			<td width="490" class="title_bg">TOTAL</td>
            <td width="100"><textarea name="estComt" style="width:99%;height:99%"></textarea></td>
			<td width="110" class="title_bg">
				<input type="text" class="inputbox" name="viTotPrice" value="0" size="12" maxlength=20 onBlur="intToCom(this)"></td>
		</tr>
		</table></td>
</tr>
<tr height=25>
	<td colspan=2><input type="button" value="기본폼선택" onclick="basicForm();" class="inputbox2"></td>
</tr>
<tr align=center>
	<td colspan=2><textarea name="memo" style="width:700;height:200"></textarea></td>
</tr>
<tr align=center height=60>
	<td colspan=2>
		<input type="button" value="견적서 입력" onclick="estimateFormCheck()" class="inputbox2">
		<input type="button" value="닫기" onclick="top.self.close()" class="inputbox2"></td>
</tr>
</form>
</table>




<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>
<div style="position:absolute;left:1;top:1"><input type="button" class="inputbox2" value="한글견적폼으로이동" onclick="goKorWrite();"></div>
<iframe id="clientUser" width="0" height="0"></iframe>

</BODY>
</HTML>

<%	
	if( seq_project > 0 ){	
		Project pj		= pDAO.selectOne(seq_project);
		Client cl		= cDAO.selectOne(pj.seq_client);
		ClientUser cu	= cuDAO.selectOne(pj.seq_clientUser);		%>
		<form name="idxfrm">
		<textarea name="projName" style="display:none"><%=KUtil.nchk(pj.name)%></textarea>
		<textarea name="seq_project" style="display:none"><%=seq_project%></textarea>
		<textarea name="seq_client" style="display:none"><%=cl.seq>0?cl.seq+"":""%></textarea>
		<textarea name="client_name" style="display:none"><%=cl.seq>0?cDAO.getBizName(cl,"ENG"):""%></textarea>
		<textarea name="seq_clientUser" style="display:none"><%=cu.seq>0?cu.seq+"":""%></textarea>
		<textarea name="clientUser_name" style="display:none"><%=cu.seq>0?cu.userName:""%></textarea>
		</form>
<%	}//if	%>

<SCRIPT LANGUAGE="JavaScript">
editor_generate("memo");
<%	if( seq_project > 0 ){	
		Project pj = pDAO.selectOne(seq_project);
		Client cl = cDAO.selectOne(pj.seq_client);
		ClientUser cu = cuDAO.selectOne(pj.seq_clientUser);		%>

		var ofrm	= document.idxfrm;
		var frm		= document.estimateForm;
		frm.seq_project.value	= ofrm.seq_project.value;
		frm.projName.value		= ofrm.projName.value;
		frm.title.value			= ofrm.projName.value;
		frm.seq_client.value	= ofrm.seq_client.value;
		frm.client_name.value	= ofrm.client_name.value;
		//frm.seq_clientUser.value= ofrm.seq_clientUser.value;
		//frm.clientUser_name.value	= ofrm.clientUser_name.value;
<%	}%>

resize(770,700);
</SCRIPT>


<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
