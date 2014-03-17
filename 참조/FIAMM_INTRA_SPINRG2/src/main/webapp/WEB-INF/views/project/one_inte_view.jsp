<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*,dao.common.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

	Database db = new Database();

try{ 


	//request
	
	ProjectDAO pDAO = new ProjectDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
	UserDAO uDAO = new UserDAO(db);

	
	int seq_project	= KUtil.nchkToInt(request.getParameter("seq_project"));
	int id			= KUtil.nchkToInt(request.getParameter("id"));
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/file.js"></script>
<SCRIPT LANGUAGE="JavaScript">
function selectClient(){
	var frm = document.projectForm;
	frm.nowPage.value = 1;
	frm.action = "list.jsp";
	frm.submit();
}
function goModify(seq){
	var frm = document.projectForm;
	var lft = (screen.availWidth-700)/2;
	var tp	= (screen.availHeight-390)/2;
	var pop = window.open("mod.jsp?seq="+seq,"viewProject","width=700,height=390,scrollbars=0,left="+lft+",top="+tp);
	pop.focus();
	
}
function goDelete(seq){
	var frm = document.projectForm;
	if( confirm("삭제하시겠습니까?") ){
		frm.seq.value = seq;
		frm.action = "DBD.jsp";
		frm.submit();
	}
}
function popView(seq){
	var frm = document.projectForm;
	var lft = (screen.availWidth-720)/2;
	var tp	= (screen.availHeight-600)/2;
	var pop = window.open("","viewProject","width=720,height=600,scrollbars=1,left="+lft+",top="+tp);
	frm.seq.value = seq;
	frm.target = "viewProject";
	frm.action = "view.jsp";
	frm.submit();
}
function chkSearch(){
	var frm = document.projectForm;
	frm.nowPage.value = "1";
	frm.action = "list.jsp";
}
function popAllDoc(seq_project){
	var lft = screen.availWidth-10;
	var tp = screen.availHeight;
	var pop = window.open("/main/view_all/index.jsp?seq_project="+seq_project,"allview","top=0,left=1,resizable=1,scrollbars=0,width="+lft+",height="+tp);
	pop.focus();
}
function projAdd(){
	var pop = window.open("write.jsp","padd","scrollbars=0");
	pop.focus();
}
function addEstimate( i, seq_project ){
	var lt = (screen.availWidth-720)/2;
	var pop = window.open("/main/estimate/write.jsp?reload=4&reloadval="+i+"&seq_project="+seq_project,"estAdd","left="+lt+",top=0,width=720,height=700, scrollbars=1");
	pop.focus();
}
function inContract(seq_project){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-600)/2;
	var pop = window.open("/main/contract/write.jsp","padd","top="+tp+",left="+lft+",scrollbars=1,width=720,height=600");
	pop.focus(); 
}
function modifyCon(seq){
	var frm = document.projectForm;
	var lft = (screen.availWidth-700)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/contract/view.jsp?seq="+seq+"&reload=4","padd","top="+tp+",left="+lft+",scrollbars=0,width=700,height=660");
	pop.focus();
}
function viewClient(seq){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/client/view.jsp?seq="+seq,"viClient","top="+tp+",left="+lft+",scrollbars=1,width=720,height=660");
	pop.focus();
}
function viewClientUser(seq_fk, seq){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/client/clientUser_view.jsp?sub_seq="+seq+"&seq="+seq_fk,"viClientUser","top="+tp+",left="+lft+",scrollbars=1,width=720,height=660");
	pop.focus();
}

function showboxPosition(object,work,left,top){
	var obj = document.getElementById(object); 
	obj.style.pixelLeft = event.clientX + document.body.scrollLeft + Number(left);
	obj.style.pixelTop	= event.clientY + document.body.scrollTop + Number(top)+10;
	obj.style.display	= work;
}
function reloadpage(){
	document.location.reload();
}
function init(){
	try{
		if( parent.document.getElementById("ifm_<%=id%>") ){	
			var objBody = document.body;
			var h = objBody.scrollHeight + (objBody.offsetHeight - objBody.clientHeight);
			var objfme = parent.document.getElementById("ifm_<%=id%>");
			objfme.style.height = h;
			id_mtb.style.width = document.body.clientWidth;
		}
	}catch(e){}
}
function popContractW(seq_project,seq_estimate){
	var pop = window.open("/main/contract/write.jsp?seq_project="+seq_project+"&seq_estimate="+seq_estimate,"viEsti2","scrollbars=0");
	pop.focus();
}
</SCRIPT>
</HEAD>

<BODY class="body2" class="xnoscroll" onload="init()">

<%
		Project pj = pDAO.selectOne(seq_project);		
		ClientUser cu = cuDAO.selectOne(pj.seq_clientUser);	
		Vector vecContract = ctDAO.getListInProject(pj.seq);
		Client cl = cDAO.selectOne(pj.seq_client);			%>





		<table cellpadding="0" cellspacing="0" border="0" width="100%" id="id_mtb">
		<form name="projectForm" method="post">
		<tr height="20">
			<td><table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr>
					<td><%=KUtil.nchk(pj.content,"&nbsp;")%></td>
				</tr>
				<tr>
					<td align=right><input type="button" value="프로젝트수정" class="inputbox2" onclick="goModify('<%=pj.seq%>')">	
					&nbsp;</td>
				</tr>
				</table></td>
		</tr>
<%	if( vecContract.size() > 0 ){	%>
		<tr height=20 align=center>
			<td class="ti2">계약서 정보</td>
		</tr>		

		<tr height=20 align=center>
			<td>
				<table cellpadding="0" cellspacing="0" border="0" width="100%" class="line-table3">
				<tr align=center>
					<th>계약일</th>
					<th>계약번호</th>
					<th>계약금액</th>
					<th>결제방법</th>
					<th>선증</th>
					<th>계증</th>
					<th>하증</th>
					<th>기증</th>
					<th>지체</th>
					<th>작성자</th>
					<th>파일</th>
				</tr>
	<%		for( int j=0 ; j<vecContract.size() ; j++ ){		
			Contract ct = (Contract)vecContract.get(j);		
			String cls1 = j%2==0?"":"databg_line";		%>
				<tr align=center>
					<td class="<%=cls1%>"><A HREF="javascript:" onclick="modifyCon('<%=ct.seq%>')"><%=KUtil.toDateViewMode(ct.conDate)%></A></td>
					<td class="<%=cls1%>"><%=KUtil.nchk(ct.contractNum,"&nbsp;")%></td>
					<td class="<%=cls1%>">
						<%=KUtil.nchk(ct.priceKinds)%>
						공:<%=NumUtil.numToFmt(ct.supPrice,"###,###.##","0")%>
						부:<%=NumUtil.numToFmt(ct.taxPrice,"###,###.##","0")%></td>
					<td class="<%=cls1%>">
						<%	if( ct.payMethod1 > 0 ) { out.print("선:"+NumUtil.numToFmt(ct.payMethod1,"###,###.##","0")); }
							if( ct.payMethod2 > 0 ) { out.print(" 중:"+NumUtil.numToFmt(ct.payMethod2,"###,###.##","0")); }
							if( ct.payMethod3 > 0 ) { out.print(" 잔:"+NumUtil.numToFmt(ct.payMethod3,"###,###.##","0")); }	
							if( ct.payMethod1 < 1 && ct.payMethod2 < 1 && ct.payMethod3 < 1 ) out.print("&nbsp;");	%></td>
					<td class="<%=cls1%>">
						<%	if( ct.prepayDeed == 1  ){ %>
								<A HREF="javascript:" onmouseover="showboxPosition('p_<%=j%>','block',-120,0);" onmouseout="showboxPosition('p_<%=j%>','none',0,0)">Y</A>
								<div id="p_<%=j%>" style="display:none;position:absolute;width:150;background-color:#f7f7f7;border:1 solid #66FF00">
									<div align=center class="bk1_1"><B>선급금이행증권</B></div>
									<div align=center class="bk2_1">
										<%	if( NumUtil.numToFmt(ct.prepayPer,"###,###.##","0").equals("0") ){
												out.println("미지정");
											}else{
												out.println( NumUtil.numToFmt(ct.prepayPer,"###,###.##","0")+" %" );	
											}	%></div>
									<div align=center class="bk2_1">
										<%=ct.prepayStDate>0?KUtil.toDateViewMode(ct.prepayStDate):""%>
										<%=ct.prepayEdDate>0?" ~ "+KUtil.toDateViewMode(ct.prepayEdDate):""%></div>
									<div align=center class="bk2_1"><%=KUtil.nchk(ct.prepayContent)%></div></div>
						<%	}else{ out.print("N"); } %></td>
					<td class="<%=cls1%>">
						<% if( ct.conDeed == 1  ){		%>
								<A HREF="javascript:" onmouseover="showboxPosition('c_<%=j%>','block',-120,0);" onmouseout="showboxPosition('c_<%=j%>','none',0,0)">Y</A>
								<div id="c_<%=j%>" style="display:none;position:absolute;width:150;background-color:#f7f7f7;border:1 solid #66FF00">
									<div align=center class="bk1_1"><B>계약이행증권</B></div>
									<div align=center class="bk2_1">
										<%	if( NumUtil.numToFmt(ct.prepayPer,"###,###.##","0").equals("0") ){
												out.println("미지정");
											}else{
												out.println( NumUtil.numToFmt(ct.prepayPer,"###,###.##","0")+" %" );	
											}	%></div>
									<div align=center class="bk2_1">
										<%=ct.conStDate>0?KUtil.toDateViewMode(ct.conStDate):""%>
										<%=ct.conEdDate>0?" ~ "+KUtil.toDateViewMode(ct.conEdDate):""%></div>
									<div align=center class="bk2_1"><%=KUtil.nchk(ct.conContent)%></div></div>
						<% }else{ out.print("N"); } %></td>
					<td class="<%=cls1%>">
						<%	if( ct.defectDeed == 1  ){	%>
								<A HREF="javascript:" onmouseover="showboxPosition('d_<%=j%>','block',-120,0);" onmouseout="showboxPosition('d_<%=j%>','none',0,0)">Y</A>
								<div id="d_<%=j%>" style="display:none;position:absolute;width:150;background-color:#f7f7f7;border:1 solid #66FF00">
									<div align=center class="bk1_1"><B>하자이행증권</B></div>
									<div align=center class="bk2_1">
										<%	if( NumUtil.numToFmt(ct.defectPer,"###,###.##","0").equals("0") ){
												out.println("미지정");
											}else{
												out.println( NumUtil.numToFmt(ct.defectPer,"###,###.##","0")+" %" );	
											}	%></div>
									<div align=center class="bk2_1">
										<%=ct.defectStDate>0?KUtil.toDateViewMode(ct.defectStDate):""%>
										<%=ct.defectEdDate>0?" ~ "+KUtil.toDateViewMode(ct.defectEdDate):""%></div>
									<div align=center class="bk2_1"><%=KUtil.nchk(ct.defectContent)%></div></div>
						<%	}else{ out.print("N"); } %></td>
					<td class="<%=cls1%>">
						<%	if( ct.etcDeed == 1  ){ 	%>
								<A HREF="javascript:" onmouseover="showboxPosition('e_<%=j%>','block',-120,0);" onmouseout="showboxPosition('e_<%=j%>','none',0,0)">Y</A>
								<div id="e_<%=j%>" style="display:none;position:absolute;width:150;background-color:#f7f7f7;border:1 solid #66FF00">
									<div align=center class="bk1_1"><B>기타증권</B></div>
									<div align=center class="bk2_1">
										<%	if( NumUtil.numToFmt(ct.etcPer,"###,###.##","0").equals("0") ){
												out.println("미지정");
											}else{
												out.println( NumUtil.numToFmt(ct.etcPer,"###,###.##","0")+" %" );	
											}%></div>
									<div align=center class="bk2_1">
										<%=ct.etcStDate>0?KUtil.toDateViewMode(ct.etcStDate):""%>
										<%=ct.etcEdDate>0?" ~ "+KUtil.toDateViewMode(ct.etcEdDate):""%></div>
									<div align=center class="bk2_1"><%=KUtil.nchk(ct.etcContent)%></div></div>
						<%	}else{ out.print("N"); } %></td>
					<td class="<%=cls1%>">
						<%	if( ct.delayDeed == 1  ){ %>
								<A HREF="javascript:" onmouseover="showboxPosition('de_<%=j%>','block',-120,0);" onmouseout="showboxPosition('de_<%=j%>','none',0,0)">Y</A>
								<div id="de_<%=j%>" style="display:none;position:absolute;width:150;background-color:#f7f7f7;border:1 solid #66FF00">
									<div align=center class="bk1_1"><B>지체상금율</B></div>
									<div align=center class="bk2_1">
										<%	if( NumUtil.numToFmt(ct.delayPer,"###,###.#######","0").equals("0") ){
												out.println("미지정");
											}else{
												out.println( NumUtil.numToFmt(ct.delayPer,"###,###.#######","0")+" %" );	
											}%></div>
									<div align=center class="bk2_1"><%=KUtil.nchk(ct.delayContent)%></div></div>
						<%	}else{ out.print("N"); } %></td>
					<td class="<%=cls1%>"><%=uDAO.selectOne(ct.userId).userName%></td>
					<td class="<%=cls1%>">
						<%	if( KUtil.nchk(ct.fileName).length() > 0 ){	%>
								<A HREF="javascript:;" onclick="filesCreateLink(-150,0,<%=j%>)">
									<IMG SRC="/images/icon/disk.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A>
								<textarea name="filesLink<%=j%>" style="display:none">
									<%=FileCtl.fileViewLink(ct.fileName,"",ct.seq,"contract","<br>",0)%></textarea>
					<%		}else{
								out.println("&nbsp;");
							}	%></td>
				</tr>		
	<%		}//for		%>
				</table></td>
		</tr>
	
<%	}//if			%>

		<tr height="100">
			<td>
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<tr align=center height=20>
					<td class="ti2">
						<A HREF="javascript:;" onclick="document.frames['fme'].popEstimateW();">
							<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT="">
							견적서 리스트
							<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A></td>
					<td class="ti2">
						<A HREF="javascript:;" onclick="document.frames['fmp'].popPoW();">
							<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT="">
							PO 리스트
							<IMG SRC="/images/icon_plus.gif" WIDTH="11" HEIGHT="11" BORDER="0" ALT=""></A></td>
				</tr>
				<tr>
					<td class="tdAllLine">
						<iframe src="fme_estimate_list.jsp?seq_project=<%=seq_project%>" name="fme" id="fmp" width="100%" height="100" frameborder="0"></iframe></td>
					<td class="tdAllLine">
						<iframe src="fmp_po_list.jsp?seq_project=<%=seq_project%>" name="fmp" id="fmp" width="100%" height="100" frameborder="0"></iframe></td>
				</tr>
				</table></td>
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
