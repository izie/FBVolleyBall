<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	//
	int seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));
	int reload = KUtil.nchkToInt(request.getParameter("reload"));
	int seq_pil= KUtil.nchkToInt(request.getParameter("seq_pil"));

	
	PassItemLnkDAO pilDAO	= new PassItemLnkDAO(db);
	SetupItemDAO siDAO		= new SetupItemDAO(db);
	PoItemDAO poiDAO		= new PoItemDAO(db);
	PassCodeDAO pcDAO		= new PassCodeDAO(db);
	PassDAO psDAO			= new PassDAO(db);
	UserDAO uDAO			= new UserDAO(db);
	PoDAO poDAO				= new PoDAO(db);
	
	
	Po po = poDAO.selectOne(seq_po);
	Vector vecPil = pilDAO.getList(seq_po);
	
	Vector vecList = pcDAO.getList();
	Vector vecUser = uDAO.getUserList();
%>


<HTML>
<HEAD>
<title>Fiamm Korea</title>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/common/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/common/editorSimple.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/common/move.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function selectPil( obj , i ){
	if( obj.checked ){
		document.frames['id_lc'+i].location = "lc_list.jsp?seq_po=<%=seq_po%>&seq_pil="+obj.value;		
		show('id_lcv'+i);
	}
}
</SCRIPT>
</HEAD>

<BODY leftmargin="0" topmargin="0" class="xnoscroll">

<table cellpadding="0" cellspacing="0" border="0" width="850">
<tr height=25>
	<td width=120  align=center class="ti1">PO</td>
	<td class="bgc1">&nbsp;[<%=poDAO.getPoNo(po)%>] <%=po.title%></td>
</tr>
<tr height=2>
	<td></td>
</tr>
</table>


<table cellpadding="0" cellspacing="0" border="0" width="850">
<tr height=28>
	<td class="ti1" colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td>&nbsp;▶ 품목 구분</td>
			<td align=right><input type="button" value="닫기" class="inputbox2" onclick="top.window.close();">&nbsp;</td>
		</tr>
		</table></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="850">
<tr height=25 align=center>
	<td class="menu1" width="30">선택</td>
	<td class="menu1" width="720">품목명</td>
	<td class="menu1" width="100">수량</td>
</tr>
<%	for( int i=0 ; i<vecPil.size() ; i++ ){	
		PassItemLnk pil = (PassItemLnk)vecPil.get(i);	
		String clas = i%2==0?"menu2_1":"menu2";			%>
<tr>
	<td class="<%=clas%>" align=center>
		<input type="radio" name="seq_pil" value="<%=pil.seq%>" onclick="selectPil(this,'<%=i%>')" <%=pil.seq==seq_pil?"checked":""%>></td>
	<td colspan=2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<%	Vector vecSetupItem = siDAO.getListIn(pil.seq_setupitem);
		for( int j=0 ; j<vecSetupItem.size() ; j++ ){	
			SetupItem si = (SetupItem)vecSetupItem.get(j);			
			PoItem pi = poiDAO.selectOne(si.seq_poitem);			%>
		<tr>
			<td class="<%=clas%>" width="720"><%=KUtil.nchk(pi.itemName)%> / <%=KUtil.nchk(pi.itemDim)%></td>
			<td class="<%=clas%>" width="100" align=right><%=KUtil.intToCom(si.cnt)%>&nbsp;</td>
		</tr>
	<%	}//for	%>
		</table></td>
</tr>
<tr id="id_lcv<%=i%>" style="display:<%=pil.seq==seq_pil?"block":"none"%>" class="bgc4">
	<td colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr height=25>
			<td class="ti2" colspan=3>&nbsp; <B>LC 정보</B></td>
		</tr>
		<tr>
			<td class="tdAllLine">
				<iframe <%=pil.seq==seq_pil?"src='lc_list.jsp?seq_po="+seq_po+"&seq_pil="+pil.seq+"'":""%> name="id_lc<%=i%>" id="id_lc<%=i%>" width="100%" height="200" frameborder="0"></iframe></td>
		</tr>
		</table></td>
</tr> 
<%	}//for	%>
</table>


</BODY>
</HTML>


<!-- 달력 -->
<div id=calStr style="position:absolute;left:500;top:500;width:150;height:120;padding:1px;display:none;"></div>
<div id=box style="position:absolute;background-color: #DBDBDB;width:120;height:25;display:none"></div>

<SCRIPT LANGUAGE="JavaScript">
resize(875,500);
</SCRIPT>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>