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
	ProjectDAO pDAO		= new ProjectDAO(db);
	
	Project pj		= pDAO.selectOne(seq_project);
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
	chg_color();
	document.frames['id_fr01'].location.href = "fm_in.jsp?seq_po="+seq_po;
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function viewPo(seq_po){
	var tp = (screen.availHeight-700)/2;
	var lt = (screen.availWidth-720)/2;
	var pop = window.open("/main/po/printPo.jsp?seq_po="+seq_po,"poView","top="+tp+",scrollbars=1,height=700,width=720,resizable=1,left="+lt);
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
					<span <%=po.eff<0?"class='cline'":""%>>[P<%=poDAO.getPoNo(po)%>]</span></A>
				<a id="a<%=i%>" style="cursor:hand;" onclick="sel_item('<%=i%>','<%=po.seq%>')">
					<%=po.title%></a></td>
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

<iframe name="id_fr01" id="id_fr01" width="0" height="0"></iframe>
</BODY>
</HTML>




<SCRIPT LANGUAGE="JavaScript">
var tfrm = top.document.tForm;
<%	String []arrSeq_client = pj.com_seq_client.split(",");	
	if( arrSeq_client != null ){	%>
	for( var i=0 ; i<tfrm.seq_client.length ; i++ ){
		if( Number( tfrm.seq_client.options[i].value ) == <%=arrSeq_client[0]%> ){
			tfrm.seq_client.options[i].selected=true;
		}
	}
<%	}								%>
</SCRIPT>

<%	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>