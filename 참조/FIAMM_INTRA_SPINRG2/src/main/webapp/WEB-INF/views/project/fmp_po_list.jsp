<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq_project = KUtil.nchkToInt(request.getParameter("seq_project"));
	
	PoDAO poDAO			= new PoDAO(db);
	LinkDAO lkDAO		= new LinkDAO(db);
	ContractDAO cDAO	= new ContractDAO(db);
	LcDAO lDAO			= new LcDAO(db);
	TtDAO	ttDAO		= new TtDAO(db);

	Vector vecPo	= poDAO.getList(seq_project);	
%>


<HTML>
<HEAD>
<title>피암코리아</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
var sel_stat = "";
function sel_item( item_num, seq_po ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	show2('id_'+item_num);
	chg_color();
	//parent.document.frames['fme3'].location = "/main/pass/p_view.jsp?seq_po="+seq_po;
	//parent.document.frames['fme4'].location = "/main/lc/p_view.jsp?seq_po="+seq_po;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function popPoW(){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-740)/2;
	var pop = window.open("/main/po/write.jsp?seq_project=<%=seq_project%>&reload=1","viEsti2","width=720,height=600,left="+lft+",top=0,scrollbars=1");
	pop.focus();
}
function opWinPass(seq_po){
	var tp = (screen.availHeight-700)/2;
	var lft = (screen.availWidth-720)/2;
	var pop = window.open("/main/pass/select.jsp?seq_po="+seq_po,"passView","top="+tp+",scrollbars=1,height=700,width=720,left="+lft);
	pop.focus();
}

function opWinLc(seq_po){
	var tp = (screen.availHeight-600)/2;
	var lft = (screen.availWidth-870)/2;
	var pop = window.open("/main/lc/index_div.jsp?seq_po="+seq_po+"&reload=1","lcListView","top="+tp+",scrollbars=1,height=600,width=870,left="+lft);
	pop.focus();
}
function opWinTt(seq_po){
	var tp = (screen.availHeight-600)/2;
	var lft = (screen.availWidth-870)/2;
	var pop = window.open("/main/tt/index_div.jsp?seq_po="+seq_po+"&reload=1","ttListView","top="+tp+",scrollbars=1,height=600,width=870,left="+lft);
	pop.focus();
}

function viewPo(seq_po){
	var tp = (screen.availHeight-700)/2;
	var lt = (screen.availWidth-720)/2;
	var pop = window.open("/main/po/printPo.jsp?seq_po="+seq_po,"poView","top="+tp+",scrollbars=1,height=700,width=720,resizable=1,left="+lt);
	pop.focus();
}
function opWinSetup(seq_po){
	var tp = (screen.availHeight-600)/2;
	var lt = (screen.availWidth-720)/2;
	var pop = window.open("/main/setup/list.jsp?seq_po="+seq_po+"&seq_project=<%=seq_project%>","setupView","top="+tp+",scrollbars=1,height=600,width=720,resizable=1,left="+lt);
	pop.focus();
}
function addPo(){
	var lt = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-700)/2;
	var pop = window.open("/main/po/write.jsp?seq_project=<%=seq_project%>","poAdd","left="+lt+",top="+tp+",width=720,height=700, scrollbars=1");
	pop.focus();
}
function repage(){
	document.location.reload();
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="xnoscroll">

<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<tr valign=top>
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<%	for( int i=0 ; i<vecPo.size() ; i++ ){	
				
				Po po		= (Po)vecPo.get(i);		
				
				int lcCnt	= lDAO.getListCnt(po.seq);
				int ttCnt	= ttDAO.getListCnt(po.seq);		%>
		<tr height=20>
			<td class="bk2_1">
				<IMG SRC="/images/doc.gif" WIDTH="20" HEIGHT="20" BORDER="0" ALT="" align=absmiddle>
				<A HREF="javascript:viewPo('<%=po.seq%>')">
				<span <%=po.eff<0?"class='cline'":""%>>[<%if("".equals(po.poKind) || "FK".equals(po.poKind)){out.write("FK");}else{out.write(po.poKind);}%><%=poDAO.getPoNo(po)%>]</span></A>
				<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('<%=i%>','<%=po.seq%>')"><%=po.title%></a></td>
		</tr>
		<tr id="id_<%=i%>" height=20 style="display:none">
			<td class="bgc4">
				<div>
					<A HREF="javascript:opWinPass('<%=po.seq%>');">[통관정보]</A>
					<A HREF="javascript:opWinSetup('<%=po.seq%>');">[설치대장]</A>
					<A HREF="javascript:opWinLc('<%=po.seq%>')">
					<%=lcCnt>0?"<font color='#990000'>":""%>[L/C]</A>
					<A HREF="javascript:opWinTt('<%=po.seq%>')">
					<%=ttCnt>0?"<font color='#990000'>":""%>[T/T]</A></div></td>
		</tr>
		<%	}//for	%>

		<%	if( vecPo.size()<1 ){	%>
		<tr height=50>
			<td>PO가 없습니다.</td>
		</tr>
		<%	}	%>	
			</td>
		</tr>
		</table></td>
</tr>


</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
//id_tb.style.width = document.body.clientWidth;
</SCRIPT>
<%

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>