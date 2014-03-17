<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<jsp:include page="/inc/inc_permission.jsp" flush="true">
	<jsp:param name="loc" value="estimate"/>
	<jsp:param name="col" value="L"/>
</jsp:include>

<%

	Database db = new Database();

try{ 


	//request
	int prn			= KUtil.nchkToInt(request.getParameter("prn"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	String oby		= KUtil.nchk(request.getParameter("oby"),"estYear DESC,estNum DESC,estNumIncre DESC");
	int pageSize	= KUtil.nchkToInt(request.getParameter("pageSize"),20);
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"),"e.wDate");
	if( sStDate < 1 && sEdDate < 1 ){	//�⺻ ����Ÿ 2�� ����
		int nowDate	= KUtil.getIntDate("yyyyMMdd");	
		sStDate		= KUtil.getNextDate( nowDate, -365*2);
		//sEdDate		= nowDate;
	}

	EstimateDAO eDAO = new EstimateDAO(db);
	EstItemDAO eiDAO = new EstItemDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ProjectDAO pDAO = new ProjectDAO(db);
	

	int totCnt = eDAO.getTotal(sk, st, seq_client, sStDate, sEdDate, schKinds);
	if( prn == 1 ) pageSize = totCnt; //����Ʈ��
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 10, totCnt, nowPage);
	String indicator = paging.getIndi();

	Vector vecEstimate = eDAO.getListOby(start, pageSize, sk, st, seq_client, oby, sStDate, sEdDate, schKinds);
	int num = pageSize*nowPage - (pageSize-1);
%>


<HTML>
<HEAD>
<title>�Ǿ��ڸ���</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/list_print.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function move(pge){
	var frm = document.estimateForm;
	frm.nowPage.value = pge;
	frm.action = "list.jsp";
	frm.submit();
}
function sel_item( seq ){
	var pop = window.open("view.jsp?seq="+seq,"esti","scrollbars=1,resizable=1");
	pop.focus();
}
function selectClient(){
	var frm = document.estimateForm;
	frm.nowPage.value = 1;
	frm.action = "list.jsp";
}
function goWrite(){
	var pop = window.open("write.jsp","inEst","scrollbars=1,resizable=1");
	pop.focus();
}
function orderBy(work){
	var frm = document.estimateForm;
	if( work=='w' ){
		if( frm.oby.value.indexOf("wDate DESC") < 0 ){
			frm.oby.value = "wDate DESC";
		}else{
			frm.oby.value = "wDate";
		}
	}else{
		if( frm.oby.value.indexOf("estYear DESC") < 0 ){
			frm.oby.value = "estYear DESC,estNum DESC,estNumIncre DESC";
		}else{
			frm.oby.value = "estYear,estNum,estNumIncre";
		}
	}
	frm.action = "list.jsp";
	frm.submit();
}
function viewClient(seq){
	var lft = (screen.availWidth-720)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/client/view.jsp?seq="+seq,"viClient","top="+tp+",left="+lft+",scrollbars=1,width=720,height=660");
	pop.focus();
}
function viewProject(i, seq_project){
	//var pop = window.open("/main/project/one_inte_view.jsp?seq_project="+seq_project,"viProj","scrollbars=0");
	document.getElementById('ifm_'+i).src = "/main/project/one_inte_view.jsp?seq_project="+seq_project+"&id="+i;
	show2('id_'+i);
}
function repage(){
	var frm = document.estimateForm;
	frm.action = "list.jsp";
	frm.submit();
}
function chPageSize(){
	var frm = document.forms[0];
	frm.action = "list.jsp";
	frm.nowPage.value = 1;
	frm.submit();
}
function popPrint(){
	var frm = document.estimateForm;
	var w = screen.availWidth;
	var h = screen.availHeight;
	var pop = window.open("","listprint","width=100,height=100,top=0,left=0");
	frm.nowPage.value = 1;
	frm.target = "listprint";
	frm.action = "list.jsp?prn=1";
	frm.submit();
	pop.focus();
	frm.target = "_self";
}
</SCRIPT>
</HEAD>

<BODY <%=prn != 1 ?"class='body1'":""%>>
<table cellpadding="0" cellspacing="0" border="0">
<tr>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">������</FONT></B></td>
    </tr>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="estimateForm" method="post" onsubmit="return selectClient();">
<input type="hidden" name="nowPage" value="<%=nowPage%>">
<input type="hidden" name="seq" value="">
<input type="hidden" name="oby" value="<%=oby%>">
<tr>
	<td colspan=6 class="ti1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td width="150">&nbsp;�� ��ü : <%=totCnt%> ��</td>
			<%  if(prn != 1){ %>
			<td align=right>
				<select name="seq_client" class="selbox" onchange="chPageSize()">
					<option value="">�ƾ�ü�������</option>
			<%	Vector vecClient = cDAO.getClient("����");
				for( int i=0 ; i<vecClient.size() ; i++ ){	
					Client cl  = (Client)vecClient.get(i);	%>
					<option value="<%=cl.seq%>" <%=cl.seq==seq_client?"selected":""%>><%=cl.bizName%></option>
			<%	}//for	%>
				</select>
			<%	String searchTxt = "concat( estYear*if(estNum<100,1000,1)";
				searchTxt += "+if(estNum<100,estNum,0)";
				searchTxt += ",if(estNum>99,estNum,''),'-',estNumIncre)";%>
				<select name="sk" class="selbox">
					<option value="">�ư˻����Ǣ�</option>
					<option value="i.itemName" <%=sk.equals("i.itemName")?"selected":""%>>ǰ��</option>
					<option value="<%=searchTxt%>" <%=sk.equals(searchTxt)?"selected":""%>>������ȣ</option>
				</select>
				
				<input type="text" name="st" value="<%=st%>" class="inputbox" size="15">&nbsp;</td>
			<td rowspan=2 width="50"><input type="submit" value="�˻�" class="inputbox2" style="height:40"></td>
			
		</tr>
		
		<tr>
			<td><select name="pageSize" class="selbox" onchange="chPageSize()">
					<option value="5" <%=pageSize==5?"selected":""%>>5��������</option>
					<option value="10" <%=pageSize==10?"selected":""%>>10��������</option>
					<option value="15" <%=pageSize==15?"selected":""%>>15��������</option>
					<option value="20" <%=pageSize==20?"selected":""%>>20��������</option>
					<option value="30" <%=pageSize==30?"selected":""%>>30��������</option>
					<option value="50" <%=pageSize==50?"selected":""%>>50��������</option>
					<option value="100" <%=pageSize==100?"selected":""%>>100��������</option>
					<option value="<%=totCnt%>" <%=pageSize==totCnt?"selected":""%>>��ü����</option>
				</select>
				<input type="button" value="����Ʈ" onclick="popPrint();" class="Btn_prn"></td>
			<td align=right>
				<FONT class="schDuring">�Ⱓ�˻�:
				<input type="text" name="sStDate" value="<%=sStDate>0?sStDate+"":""%>" class="inputbox" size=8 maxlength=8> 
				~ 
				<input type="text" name="sEdDate" value="<%=sEdDate>0?sEdDate+"":""%>" class="inputbox" size=8 maxlength=8>
				<select name="schKinds" class="selbox">
					<option value="e.wDate" <%=schKinds.equals("e.wDate")?"selected":""%>>������</option>
				</select></FONT>&nbsp;</td>
		</tr>
		<%} %>
		</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" class="line-table_A2" width="100%">
<tr height=30 align=center>
	<th width="3%">Ÿ��</th>
	<th width="5%"><A HREF="javascript:orderBy('n')">��ȣ</A></th>
	
	<th width="5%"><A HREF="javascript:orderBy('w')">�ۼ���</A></th>
	
	<th width="10%">�ŷ�ó</th>
	
	<th width="15%">ǰ��</th>
        <th width="10%">����</th>
	
	<th width="30%">������Ʈ��</th>
</tr>


<%	for( int i=0 ; i<vecEstimate.size() ; i++ ){	
		Estimate em = (Estimate)vecEstimate.get(i);		
		Project pj = (Project)pDAO.selectOne(em.seq_project);		
		Client cl = cDAO.selectOne(em.seq_client);
		Vector vecItem = eiDAO.getList(em.seq);	
		String cls = i%2==0?"databg_line":"";		%>
<tr height=25 align=center>
	<td class="<%=cls%>"><%=em.estKind%></td>
	<td class="<%=cls%>" align=left>&nbsp;
		<A HREF="javascript:sel_item('<%=em.seq%>')"><%=eDAO.getEstNo(em)%></A></td>
	
	<td class="<%=cls%>"><%=KUtil.dateMode(em.wDate,"yyyyMMdd","yy.MM.dd","&nbsp")%></td>
	
	<td class="<%=cls%>" align=left>&nbsp;<A HREF="javascript:viewClient('<%=cl.seq%>')"><%=KUtil.nchk(cl.bizName,"")%></A></td>
	
	<td valign=top class="<%=cls%>">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="nontable">
	<%	for( int j=0 ; j<vecItem.size() ; j++ ){	
			EstItem ei = (EstItem)vecItem.get(j);	%>
		<tr align=center height=25 <%=j+1 != vecItem.size() ? "class='bk2_3'" : ""%>>
			<td align=center><%=KUtil.nchk(ei.itemName)%>&nbsp;</td>
		</tr>	
	<%	}	%>
		</table></td>
		
		<td valign=top class="<%=cls%>">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="nontable">
	<%	for( int j=0 ; j<vecItem.size() ; j++ ){	
			EstItem ei = (EstItem)vecItem.get(j);	%>
		<tr align=center height=25 <%=j+1 != vecItem.size() ? "class='bk2_3'" : ""%>>
			<td align=center><%=KUtil.intToCom(ei.cnt)%>&nbsp;</td>
		</tr>	
	<%	}	%>
		</table></td>
	
	<td class="<%=cls%>" align=left>&nbsp;<A HREF="javascript:viewProject(<%=i%>,'<%=pj.seq%>')"><%=KUtil.nchk(pj.name)%></A></td>
</tr>
<tr style="display:none;" id="id_<%=i%>" height="50">
	<td colspan=6><iframe name="ifm_<%=i%>" id="ifm_<%=i%>" width="100%" height="200" frameborder="0"></iframe></td>
</tr>


<%	}//for	%>




<%	if( vecEstimate.size() < 1 ){	%>
<tr align=center height=50>
	<td colspan=6>����Ÿ�� �������� �ʽ��ϴ�.</td>
</tr>
<%	}	%>
</table>
<% if(prn != 1) { %>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td colspan=8 class="bmenu">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td><%=indicator%></td>
			<td align=right>
				<input type="button" value="������ �Է�" onclick="goWrite()" class="inputbox2"></td>
		</tr>
		</table></td>
</tr>
</table> 
<%} %> 
</form>
 
 
</BODY>
</HTML>

<jsp:include page="/inc/inc_print.jsp" flush="true"/>

<%
	if( prn == 1 ){
		KUtil.scriptOut(out, "list_print_preview(true,'������','�� "+totCnt+"��')");
		%>
		<script>setTimeout('window.close()' ,100);</script>
		<%
	}
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>