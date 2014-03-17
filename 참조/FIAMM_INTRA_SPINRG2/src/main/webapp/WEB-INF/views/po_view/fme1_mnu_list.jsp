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
	int seq_client = KUtil.nchkToInt(request.getParameter("seq_client"));

	ProjectDAO pjDAO = new ProjectDAO(db);
	PoDAO poDAO = new PoDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript" src="/tree/menu1.js"></SCRIPT>
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
function opWin(seq){
	alert(seq);
}


var foldersTree = gFld("MF","<b>프로젝트리스트</b>", "");

<%	Vector vecProject = pjDAO.getList(seq_client);
	for( int i=0 ; i<vecProject.size() ; i++ ){	
		Project pj = (Project)vecProject.get(i);		%>
		
var p<%=i%> = insFld(foldersTree, gFld("fme2", '<%=KUtil.cutTitle(pj.name,15).replaceAll("\'","&quot")%>',""));
	var p<%=i%>a = insFld(p<%=i%>, gFld("fme2", '전체견적서',"fme2_list_estimate.jsp?seq_project=<%=pj.seq%>"));
	var p<%=i%>b = insFld(p<%=i%>, gFld("fme2", '계약서',"fme2_list_contract.jsp?seq_project=<%=pj.seq%>"));
<%	Vector vecContract = ctDAO.getListInProject(pj.seq);	
		for( int k=0 ; k<vecContract.size() ; k++ ){		
			Contract ct = (Contract)vecContract.get(k);	%>
		var p<%=i%>b<%=k%>a = insFld(p<%=i%>b, gFld("fme2", '<%=KUtil.cutTitle(ct.title,15).replaceAll("\'","&quot")%>',""));
			var p<%=i%>b<%=k%>aa = insFld(p<%=i%>b<%=k%>a, gFld("fme2", '견적서',"fme2_listOne_estimate.jsp?seq_estimate=<%=ct.seq_estimate%>"));
	<%	}//for contract	%>
	var p<%=i%>c = insFld(p<%=i%>, gFld("fme2", 'PO',"fme2_list_po.jsp?seq_project=<%=pj.seq%>"));

<%		Link lk = new Link();
		lk.seq_project = pj.seq;
		Vector vecLink = lkDAO.getList(lk);	
		Vector vecPo = poDAO.getList(vecLink);
		for( int j=0 ; j<vecPo.size() ; j++ ){	
			Po po = (Po)vecPo.get(j);			%>
			var p<%=i%>c<%=j%> = insFld(p<%=i%>c, gFld("fme2", '<%=KUtil.cutTitle(po.title,15).replaceAll("\'","&quot")%>',""));
				var p<%=i%>c<%=j%>a = insFld(p<%=i%>c<%=j%>, gFld("fme2", '계약서',"fme2_list_contract1.jsp?seq_po=<%=po.seq%>"));
				insDoc(p<%=i%>c<%=j%>, gLnk("fme2", '통관',"popup.jsp?seq_po=<%=po.seq%>"));
<%		}//for Po
	}//for	project	%>
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