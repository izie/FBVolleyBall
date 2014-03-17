<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
	//requets
	dao.Link lnk = new dao.Link();
	lnk.seq_po = KUtil.nchkToInt(request.getParameter("seq_po"));

	LinkDAO lkDAO = new LinkDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/tree/menu.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,seq_contract,seq_estimate ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = item_num;
	chg_color();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}


var foldersTree = gFld("fme2","<b>계약서리스트</b>", "fme2_list_contract.jsp?seq_po=<%=lnk.seq_po%>");
	
<%	Vector vecLink = lkDAO.getList(lnk);		
	for( int i=0 ; i<vecLink.size() ; i++ ){
		dao.Link lk = (dao.Link)vecLink.get(i);			
		Contract ct = ctDAO.selectOne(lk.seq_contract);
%>
	var a<%=i%> = insFld(foldersTree, gFld("fme2", '<%=KUtil.cutTitle(ct.title,10).replaceAll("\'","&quot;")%>',""));
		var a<%=i%>a<%=i%> = insFld(a<%=i%>, gFld("fme2", '견적서',"fme2_list_estimate.jsp?seq_estimate=<%=ct.seq_estimate%>"));
		var a<%=i%>b<%=i%> = insFld(a<%=i%>, gFld("fme2", '프로젝트',"fme2_list_project.jsp?seq_project=<%=ct.seq_project%>"));
		var a<%=i%>c<%=i%> = insFld(a<%=i%>, gFld("fme2", '거래처정보',"fme2_list_client.jsp?seq_client=<%=ct.seq_client%>"));
<%	}//for Link		%>
	insDoc(foldersTree, gLnk("fme2", '통관 정보',"popup.jsp?seq_po=<%=lnk.seq_po%>"));
	insDoc(foldersTree, gLnk("fme2", 'L/C 정보',"popup1.jsp?seq_po=<%=lnk.seq_po%>"));
	
</SCRIPT>
</head>


<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top>
<form name="fme2Form" method="post">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<tr valign=top>
	<td>
<!-- Tree Start -------------------------------------------------------->
<DIV style="width:100%">
<SCRIPT language=JavaScript>
initializeDocument();
</SCRIPT>
</DIV>
<!-- Tree End ---------------------------------------------------------->	
	</td>
</tr>
</table>
</form>
</BODY>
</HTML>



<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>