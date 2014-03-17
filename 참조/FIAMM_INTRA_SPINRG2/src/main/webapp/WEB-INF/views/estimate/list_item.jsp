<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{
	String itemCom = KUtil.nchk(request.getParameter("itemCom"));

	ItemDAO iDAO = new ItemDAO(db);
	Vector vecItem = iDAO.getList(itemCom);
	
%>

<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num,itemCom ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	chg_color();
	parent.estimateItem.seq_item.value = itemCom;
	parent.estimateItem.itemName.value = eval("document.itemFormsub.itemName"+item_num).value;
	parent.estimateItem.itemDim.value = eval("document.itemFormsub.itemDim"+item_num).value;
	parent.result();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0>
<table cellpadding="0" cellspacing="0" border="0" width="100%">


<form name="itemFormsub" method="post">
<%	for( int i=0 ; i<vecItem.size() ; i++ ){		
		Item im = (Item)vecItem.get(i);	%>
	<tr>
		<td class="bk2_1">
		<IMG SRC="/images/icon_box.gif" BORDER="0" ALT="">
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('<%=i%>','<%=im.seq%>')"><%=im.itemName%> / <%=KUtil.nchk(im.itemModel)%></a>
		<textarea name="itemName<%=i%>" style="display:none"><%=KUtil.nchk(im.itemName)%> / <%=KUtil.nchk(im.itemModel)%></textarea>
		<textarea name="itemDim<%=i%>" style="display:none"><%=KUtil.nchk(im.itemDim)%></textarea></td>
	</tr>
<%	}//for	%>
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