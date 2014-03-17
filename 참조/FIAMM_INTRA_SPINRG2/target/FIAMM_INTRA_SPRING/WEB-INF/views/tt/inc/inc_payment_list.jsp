<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>
<%@ include file="/inc/inc_per_r.jsp"%>
<%
	Database db  = new Database();
try{ 
	int seq_tt = KUtil.nchkToInt(request.getParameter("seq_tt"));

	TT_paymentDAO tpDAO = new TT_paymentDAO(db);
	Vector vecList = tpDAO.getList(seq_tt);		
%>

<SCRIPT LANGUAGE="JavaScript">
function view_id_vi01(i, work){
	var ob = document.getElementById("id_vi01");
	var va = eval("document.pForm.memo"+i);
	if( !nchk1(va) ){
		return;
	}
	ob.innerHTML = va.value;
	ob.style.display = work;
	ob.style.pixelLeft	= event.clientX + document.body.scrollLeft-100;
	if( event.clientY + document.body.scrollTop > 145 ){
		ob.style.pixelTop = event.clientY + document.body.scrollTop-50;
	}else{
		ob.style.pixelTop = event.clientY + document.body.scrollTop
	}
	
	var es = event.srcElement;
	es.onmouseout = new Function("view_id_vi01('"+i+"', 'none')");
}
function del(seq){
	if( confirm("삭제하시겠습니까?") ){
		document.frames['fm_tt1'].location.href = "/main/tt/inc/tt_payment_DBD.jsp?seq="+seq;
	}
}
</SCRIPT>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="pForm" method="post" onsubmit="return search();">
<%	double sum = 0;
	for( int i=0 ; i<vecList.size() ; i++ ){	
		TT_payment tp = (TT_payment)vecList.get(i);		
		sum += tp.price;								%>
<tr height="22">
	<td class="bk2_3">&nbsp;
		<A href="javascript:del(<%=tp.seq%>)" onmouseover="view_id_vi01('<%=i%>','block')">
		<%=KUtil.dateMode(tp.pDate,"yyyyMMdd","[yyyy,MM,dd]","&nbsp;")%>
		<%=NumUtil.numToFmt(tp.price,"###,###.##","0")%></A>
		<textarea name="memo<%=i%>" style="display:none"><%=KUtil.toTextMode(tp.memo,"")%></textarea></td>
</tr>
<%	}//form												%>
<tr height="22">
	<td class="bk2_3" bgcolor="#EEEEEE">&nbsp;
		합계 : <%=NumUtil.numToFmt(sum,"###,###.##","0")%></td>
</tr>
</form>
<div id="id_vi01" style="display:none;height:50;width:100;position:absolute;background-color:lightyellow;border:1 solid #C0C0C0"></div>
</table>

<iframe name="fm_tt1" id="fm_tt0" width=0 height=0></iframe>

<%	
	
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>