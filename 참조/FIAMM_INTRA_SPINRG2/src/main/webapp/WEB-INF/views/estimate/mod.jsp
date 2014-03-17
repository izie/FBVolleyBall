<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>

<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="estimate"/>
	<jsp:param name="col" value="M"/>
</jsp:include>
<%@ include file="/inc/inc_sessionStopCheck.jsp"%>
<%
	Database db = new Database();

try{ 
	
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int reload		= KUtil.nchkToInt(request.getParameter("reload"));

	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);
	EstimateDAO emDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	ItemDAO iDAO	= new ItemDAO(db);
	PriceKindsDAO pkDAO = new PriceKindsDAO(db);
	Estimate em = emDAO.selectOne(seq);
	ContractDAO ctDAO = new ContractDAO(db);
	
	//견적서가 관련된 계약서 문서 건수
	int cnt_con = ctDAO.getCntInEstimate(seq);

	boolean flag = false;
%>


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
function viewClientUser(){
	var lft = (screen.availWidth-300)/2;
	var pop = window.open("list_clientUser_pop.jsp?seq_client=<%=em.seq_client%>","clientUser","width=300,height=500,top=0,left="+lft);
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
	frm.totPrices.value = tot;

	if( frm.isTax.checked ){
		frm.taxPrice.value = 0;
	}else{
		frm.taxPrice.value = Number(tot*0.1);
	}
	frm.allPrice.value = tot + Number( filterNum(frm.taxPrice.value));
	frm.viTotPrice.value = tot + Number( filterNum(frm.taxPrice.value));
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
	frm.totPrices.value = tot;

	if( frm.isTax.checked ){
		frm.taxPrice.value = 0;
	}
	frm.allPrice.value = tot + Number( filterNum(frm.taxPrice.value) );
	frm.viTotPrice.value = tot + Number( filterNum(frm.taxPrice.value) );
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
	intToCom(frm.totPrices);
	intToCom(frm.taxPrice);
	intToCom(frm.allPrice);
	intToCom(frm.viTotPrice);
}
function calc2(){
	var frm = document.estimateForm;
	frm.allPrice.value = Number( filterNum(frm.totPrices.value) ) + Number( filterNum(frm.taxPrices.value) );
	frm.viTotPrice.value = Number( filterNum(frm.totPrices.value) ) + Number( filterNum(frm.totPrices.value) );
	int2Com();
}
function estimateFormCheck(){
	var frm = document.estimateForm;
	frm.action = "DBM.jsp";
	if( !validate(frm) ){
		return;
	}
	editor_event("memo");
	frm.submit();
}
function inputRevision(){
	var frm = document.estimateForm;
	frm.action = "DBRW.jsp";
	if( !validate(frm) ){
		return false;
	}
	editor_event("memo");
	frm.submit();
}
function validate(frm){
	var len = in_table01.rows.length;
	if( !dateCheck(frm.wDate, "견적일") ) return false;
	if( !onlyNumber1(frm.edDate) ){ 
		alert("유효기간을 선택해 주십시요!");
		return false;
	}	
	if( !nchk(frm.title,"제목") ) return false;
	else if( !nchk1(frm.priceKinds) ){
		alert("통화를 입력하여 주십시요"); 
		return false;
	}else if( len < 1 ){
		alert("견적 품목을 입력해 주십시요");
		return false;
	}

    if (frm.limitDateOptFlag.checked) {
        if( !nchk(frm.limitDateOpt01,"납기항목") ) return false;
    } else {
        if( !comNum(frm.limitDate,"납기") ) return false;
    }
	
	return true;
}
function initChange(){
	document.frames['itemList'].location="init_mod_item.jsp?seq=<%=seq%>";

}
function inputEdDate(){
	var frm = document.estimateForm;
	if( frm._edDate.value==0 ){
		frm.edDate.style.display = "block";
		frm.edDate.value = "<%=em.edDate%>";
		frm.edDate.focus();
	}else{
		frm.edDate.style.display = "none";
		frm.edDate.value = frm._edDate.value;
	}
	
}
function chPlace(){
	var frm = document.estimateForm;
	if( frm._place.value==0 ){
		frm.place.value = '';
		frm.place.style.display = "block";
		frm.place.focus();
	}else{
		frm.place.value = frm._place.value;
		frm.place.style.display = "none";
	}
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
function basicForm(){
	var lft = (screen.availWidth-500)/2;
	var tp	= (screen.availHeight-490)/2;
	var pop = window.open("frm_index.jsp","formView","width=500,height=490,top="+tp+",left="+lft);
	pop.focus();
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
function chPriceKinds(){
	var frm = document.estimateForm;
	if( frm._priceKinds.value==0 ){
		frm.priceKinds.value = frm.priceKinds_temp.value;
		show1("id_priceKinds","block");
		frm.priceKinds.focus();
	}else{
		frm.priceKinds.value = frm._priceKinds.value;
		show1("id_priceKinds","none");
	}
}
function go_print_preview(){
	var frm = document.estimateForm;
	frm.action = "view.jsp";
	frm.submit();
}
function goDelete(){
	if( confirm("삭제하시겠습니까?") ){
		document.location = "DBD.jsp?seq=<%=seq%>";
	}
}
function fnChkLimitFlag(){
    var frm = document.estimateForm;
    if (frm.limitDateOptFlag.checked) {
        document.all.idLmt01.style.display = "none";
        document.all.idLmt02.style.display = "block";
    } else {
        document.all.idLmt01.style.display = "block";
        document.all.idLmt02.style.display = "none";
    }
}
</SCRIPT>
</HEAD>





<BODY leftmargin="0" topmargin="0" onload="initChange()">




<table cellpadding="0" cellspacing="1" border="0" width="700">

<form name="estimateForm" method="post" onsubmit="return false;">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="reload" value="<%=reload%>">
<input type="hidden" name="rowCount" value="0">
<input type="hidden" name="defaultRowCount" value="0">
<input type="hidden" name="language" value="KOR">
</table>

<table cellpadding="0" cellspacing="0" border="0" width="700">
<tr align=center height=35>
	<td colspan=2 style="line-height:35px"><h2><U>見   積   書</U></h2></td>
</tr>
<tr>
	<td width="480">
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>Project : <%=KUtil.nchk(pDAO.selectOne(em.seq_project).name)%></td>
		</tr>
		<tr>
			<td>會 社 名 : <%=KUtil.nchk(cDAO.selectOne(em.seq_client).bizName)%> 貴中</td>
		</tr>
		<tr>
			<td>擔 當 者 :	<input type="hidden" name="seq_clientUser" value="<%=em.seq_clientUser%>">
				   <input type="text" class="inputbox" name="clientUser_name" value="<%=KUtil.nchk(cuDAO.selectOne(em.seq_clientUser).userName)%>" size="10" readonly> 
				   <input type="button" value="담당자 선택" onclick="viewClientUser()" class="inputbox2"></td>
		</tr>
		</table></td>
	<td align=right>
		<table cellpadding="0" cellspacing="0" border="0" width="200">
		<tr>
			<td>DATE : 
				<input type="text" name="wDate" value="<%=em.wDate%>" size="10" class="inputbox1">
				<IMG SRC="/images/icon/calendar.gif" WIDTH="20" HEIGHT="20" BORDER="0" onclick="show_cal(document.estimateForm.wDate,'',calStr);showbox1(calStr,'block',-200,-80);" align=absmiddle style="cursor:hand"></td>
		</tr>
		<tr>
			<td>
				<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>견적서 NO. :&nbsp;</td>
					<td><%=emDAO.getEstNo(em)%></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2>&nbsp;</td>
</tr>
<tr>
	<td>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><table cellpadding="0" cellspacing="0" border="0">
                <tr>
                	<td>納    基 : </td>
                    <td><input type="checkbox" name="limitDateOptFlag" value="1" onclick="fnChkLimitFlag()"
                            <%=em.limitDateOptFlag > 0 ? "checked" : ""%>></td>
                    <td id="idLmt01" style="display:<%=em.limitDateOptFlag > 0 ? "none" : ""%>">
                        發住後 
                        <input type="text" name="limitDate" class="inputbox1" value="<%=NumUtil.numToFmt(em.limitDate,"##.#","0")%>" 
                            size=3 maxlength=5>
                        <select name="limitDateOpt" class="selbox">
                            <option value="개월" <%=em.limitDateOpt.equals("개월")?"selected":""%>>개월</option>
                            <option value="일" <%=em.limitDateOpt.equals("일")?"selected":""%>>일</option>
                        </select></td>
                    <td id="idLmt02" style="display:<%=em.limitDateOptFlag > 0 ? "" : "none"%>">
                        <input type="text" name="limitDateOpt01" value="<%=KUtil.nchk(em.limitDateOpt)%>" size=25 maxlength="120" class="inputbox1"></td>
                </tr>
                </table></td>
		</tr>
		<tr>
			<td><table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>引渡場所 :&nbsp;</td>
					<td><%	flag = false;
							em.place = KUtil.nchk(em.place);	%>
						<select name="_place" onchange="chPlace()" class="selbox">
							<option value="귀사지정장소" <%if(em.place.equals("귀사지정장소")){out.println("selected"); flag=true;}%>>귀사지정장소</option>

							<option value="귀사지정장소 상차도" <%if(em.place.equals("귀사지정장소 상차도")){out.println("selected"); flag=true;}%>>귀사지정장소 상차도</option>

							<option value="귀사지정장소 하차도" <%if(em.place.equals("귀사지정장소 하차도")){out.println("selected"); flag=true;}%>>귀사지정장소 하차도</option>

							<option value="귀사지정장소 설치도" <%if(em.place.equals("귀사지정장소 설치도")){out.println("selected"); flag=true;}%>>귀사지정장소 설치도</option>

							<option value="" <%if(em.place.length() < 1){out.println("selected"); flag=true;}%>>없음</option>
							<option value="0" <%=flag?"":"selected"%>>▒▒직접입력▒▒</option>
						</select></td>
					<td><input type="text" class="inputbox" name="place" value="<%=em.place%>" size="30" maxlength="100" style="display:<%=flag?"none":"block"%>"></td>
				</tr>
				</table></td>
		</tr>
		<tr>
			<td><table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>支拂條件 :&nbsp;</td>
					<td>
						<%	flag = false;
							em.payKinds = KUtil.nchk(em.payKinds);	%>
						<select name="_payKinds" onchange="chPayKinds()" class="selbox">
							<option value="정기결제" <%if(em.payKinds.equals("정기결제")){out.println("selected"); flag=true;}%>>정기결제</option>
							<option value="납품후 현금결제" <%if(em.payKinds.equals("납품후 현금결제")){out.println("selected"); flag=true;}%>>납품후 현금결제</option>
							<option value="귀사 지불조건에 준함" <%if(em.payKinds.equals("귀사 지불조건에 준함")){out.println("selected"); flag=true;}%>>귀사 지불조건에 준함</option>
							<option value="계약금 30% 납품후 70%" <%if(em.payKinds.equals("계약금 30% 납품후 70%")){out.println("selected"); flag=true;}%>>계약금 30% 납품후 70%</option>
							<option value="0" <%=flag?"":"selected"%>>▒▒직접입력▒▒</option>
						</select></td>
					<td><input type="text" class="inputbox" name="payKinds" value="<%=em.payKinds%>" size="30" maxlength="100" style="display:<%=flag?"none":"block"%>"></td>
				</tr>
				</table></td>
		</tr>
		<tr>
			<td><table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>見積 有效期間 :&nbsp;</td>
					<td><select name="_edDate" class="selbox1" onchange="inputEdDate()">
						<%	flag = false;
							for( int i=10 ; i<=90 ; i=i+5 ){	%>
							<option value="<%=i%>" <%if( i==30 ){ out.println("selected"); flag=true;}%>><%=i%></option>
						<%	}//for	%>
							<option value="0" <%=flag?"":"selected"%>>직접입력</option>
						</select></td>
					<td><input type="text" class="inputbox1" name="edDate" value="<%=em.edDate%>" size=2 maxlength=2 style="display:<%=flag?"none":"block"%>"></td>
					<td>일</td>
				</tr>
				</table></td>
		</tr>
		</table></td>
	<td align=right>
		<table cellpadding="0" cellspacing="0" border="0" width="200">
		<tr>
			<td><B>피암코리아 주식회사</B></td>
		</tr>
		<tr>
			<td><B>FIAM KOREA CO.,LTD.</B></td>
		</tr>
		<tr>
			<td>주소 : 서울시 구로구 구로동 197-48</td>
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
	<td colspan=2>아래와 같이 見積합니다</td>
</tr>
<tr>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>合  計 :</td>
			<td style="padding:0 2 0 2">
				<input type="text" class="inputbox" name="viTotPrice" value="0" maxlength="20" onblur="intToCom(this)"></td>
			<td style="padding:0 2 0 2">
				<select name="_priceKinds" class="selbox1" onchange="chPriceKinds()">
			<%	flag = false;
				Vector vecPriceKinds = pkDAO.getList();
				for( int i=0 ; i<vecPriceKinds.size() ; i++ ){	
					String priceKinds  = (String)vecPriceKinds.get(i);	%>
					<option value="<%=priceKinds%>" <%if( em.priceKinds.equals(priceKinds) ){out.println("selected"); flag = true;}%>><%=priceKinds%></option>
			<%	}//for	%>
					<option value="0" <%=flag?"":"selected"%>>직접입력</option>
				</select></td>
			<td id="id_priceKinds" style="display:<%=flag?"none":"block"%>;padding:0 2 0 2">
				<input type="text" name="priceKinds" value="<%=em.priceKinds%>" class="inputbox1" size=5 maxlength="50">
				<input type="hidden" name="priceKinds_temp" value="<%=em.priceKinds%>"></td>
		</tr>
		</table></td>
</tr>
<tr>
	<td colspan=2>
		<input type="checkbox" name="isUnit" value="개별견적" <%=KUtil.nchk(em.isUnit).equals("개별견적")?"checked":""%>> 개별견적</td>
	
</tr>
<tr class="bgc1">
	<td><input type="hidden" name="isModItem" value="1"><!-- 품목수정 (아래 <FONT COLOR="#FF0000">품목이 수정</FONT>되었을 경우 체크해 주십시요) --></td>
	<td align=right><span onclick="showItem('0')" style="cursor:hand">(+)</span> 
		<span onclick="delRow()" style="cursor:hand">(-)</span></td>
</tr>
<tr>
	<td colspan=2>
		<table cellpadding="0" cellspacing="1" border="0" width="100%">
		<tr align=center class="title_bg" height=28>
			<td width="10"><IMG SRC="/images/1x1.gif" BORDER="0" ALT=""></td>
			<td width="195">品 名</td>
			<td width="195">規 格</td>
			<td width="90">數 量</td>
			<td width="100">單 價</td>
			<td width="110">金 額</td>
		</tr>
		<tr>
			<td colspan=6 class="bgc1">題 目 : <input type="text" class="inputbox1" name="title" value="<%=em.title%>" style='width:600' maxlength=200></td>
		</tr>
		</table>

		<!-- insert 테이블 -->
		<table cellpadding="0" cellspacing="1" border="0" width="100%" name="in_table01" id="in_table01"></table>
		
		<table cellpadding="0" cellspacing="1" border="0" width="100%">
		<tr align=center height=25>
			<td width="200" class="title_bg">供給價額</td>
			<td width="390" class="r_bg">&nbsp;</td>
			<td width="110" class="title_bg">
				<input type="text" class="inputbox" name="totPrices" value="0" size="12" maxlength=20 readonly></td>
		</tr>
		<tr align=center height=25>
			<td class="title_bg">附加價値稅</td>
			<td class="r_bg" align=left>&nbsp;
				<input type="checkbox" name="isTax" value="1" onclick="calc()" <%=em.isTax==1?"checked":""%>> 부가세 별도</td>
			<td class="title_bg">
				<input type="text" class="inputbox" name="taxPrice" value="<%=NumUtil.numToFmt(em.taxPrice,"###,###,##","0")%>" size="12" maxlength=20 onBlur="calc1()"></td>
		</tr>
		<tr align=center height=25>
			<td class="title_bg">合 計</td>
			<td class="r_bg">&nbsp;</td>
			<td class="title_bg">
				<input type="text" class="inputbox" name="allPrice" value="0" size="12" maxlength=20 readonly></td>
		</tr>
		</table></td>
</tr>
<tr height=25>
	<td colspan=2>※ 特記事項 <input type="button" value="기본폼선택" onclick="basicForm();" class="inputbox2"></td>
</tr>
<tr align=center>
	<td colspan=2><textarea name="memo" style="width:700;height:200"><%=KUtil.nchk(em.memo)%></textarea></td>
</tr>
<tr align=center height=40>
	<td colspan=2>
	<%	if( cnt_con == 0 ){	%>
		<input type="button" value="견적서 수정" onclick="estimateFormCheck()" class="inputbox2"> 
		<input type="button" value="삭제" onclick="goDelete()" class="inputbox2">
	<%	}	%>
		<input type="button" value="REVISION 입력" onclick="inputRevision()" class="inputbox2">
		<input type="button" value="(프린트)미리보기" onclick="go_print_preview();" class="inputbox2">
		<input type="button" value="닫기" class="inputbox2" onclick="top.window.close();"></td>
</tr>
</form>
</table>




<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>
<iframe id="clientUser" width="0" height="0"></iframe>
<iframe id="itemList" width="0" height="0"></iframe>
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
editor_generate("memo");
resize(730,730);
</SCRIPT>