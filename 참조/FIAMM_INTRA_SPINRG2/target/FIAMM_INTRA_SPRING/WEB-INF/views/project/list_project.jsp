<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

	Database db = new Database();

try{ 


	//request
	int seq_project	= KUtil.nchkToInt(request.getParameter("seq_project"));
	
	
	ProjectDAO pDAO = new ProjectDAO(db);
	ClientDAO cDAO = new ClientDAO(db);
	ClientUserDAO cuDAO = new ClientUserDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
	UserDAO uDAO = new UserDAO(db);



	Project pj = pDAO.selectOne(seq_project);
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">

</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0">


<table cellpadding="0" cellspacing="0" border="0" width="850">


<form name="projectForm" method="post" onsubmit="return chkSearch();">
<input type="hidden" name="seq_project" value="<%=seq_project%>">


<tr height=35>
	<td><IMG SRC="/images/icon01.gif" WIDTH="4" HEIGHT="16" BORDER="0" ALT="" align=absmiddle>
		<B><FONT SIZE="4">프로젝트</FONT></B></td>
</tr>
</table>

<table cellpadding="0" cellspacing="1" border="0" width="850">
<tr align=center class="bk1_1" height=30>
	<td width="60">시작일</td>
	<td width="120">제조업체</td>
	<td width="380">프로젝트명</td>
	<td width="120">업체명</td>
	<td width="120">담당자</td>
	<td width="50">계약</td>
</tr>



<%		
		ClientUser cu = cuDAO.selectOne(pj.seq_clientUser);	
		Vector vecContract = ctDAO.getListInProject(pj.seq);
		Client cl = cDAO.selectOne(pj.seq_client);%>

<tr align=center class="bk2_1" height=25>
	<td><%=KUtil.toDateViewMode(pj.stDate)%></td>
	<td><%=KUtil.nchk(pj.itemCom,"&nbsp;")%></td>
	<td align=left>&nbsp;<A HREF="javascript:" onclick="clickProject('<%=pj.seq%>')"><%=KUtil.nchk(pj.name)%></A></td>
	<td><A HREF="javascript:viewClient('<%=cl.seq%>')"><%=KUtil.nchk(cl.bizName,"&nbsp;")%></A></td>
	<td>
		<%	if( cu.seq > 0 ){	%>
			<A HREF="javascript:viewClientUser('<%=cu.seq_fk%>','<%=cu.seq%>')">
		<%	}	%>
			<%=KUtil.nchk(cu.userName,"&nbsp;")%></A></td>
	<td>
	<%	if( vecContract.size() > 0 )
			out.print("Y");
		else	
			out.print("N");%></td>
</tr>

<tr height="20" class="bgc4">
	<td valign=top colspan=6 style="border:1 solid #FF3300">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr height="100">
			<td>
				<table cellpadding="0" cellspacing="1" border="0" width="100%" height="100%">
				<tr align=center height=20>
					<td class="ti2">PO 리스트</td>
				</tr>
				<tr>
					<td class="tdAllLine">
						<iframe src="fmp_po_list.jsp?seq_project=<%=seq_project%>" name="fmp" id="fmp" width="100%" height="100%" frameborder="0"></iframe></td>
				</tr>
				</table></td>
		</tr>
		</table></td>
</tr>

<tr align=center class="bgc2" height=2>
	<td colspan=6></td>
</tr>
</form>
</table>
</BODY>
</HTML>

<div id="id_str" style="display:none"></div>

<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
