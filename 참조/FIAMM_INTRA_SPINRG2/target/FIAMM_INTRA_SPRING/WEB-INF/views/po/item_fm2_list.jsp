<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>


<%
	Database db = new Database();
try{
	ItemDAO iDAO = new ItemDAO(db);
	
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	
	Item _im = iDAO.selectOne(seq);

	int ref		= _im.seq;
	int depth	= _im.depth+1;
	

	int totCnt = iDAO.getRefTotal(sk, st, ref, depth);

	int pageSize =  15;// 한페이지에 보여줄 사이즈
	int start = (nowPage*pageSize) - pageSize;

	PagingUtil paging = new PagingUtil(pageSize, 5, totCnt, nowPage);
	String indicator = paging.getIndi("","[<]","[>]","");
	Vector vecMakeCom = iDAO.getRefList(start, pageSize, sk, st, ref, depth);
%>

<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
var sel_stat = "";
function sel_item( item_num, seq ){
	if( sel_stat != "" ){
		eval( sel_stat + ".style.background = '#FFFFFF';" );
		eval( sel_stat + ".style.color = '#333333';" );
	}
	sel_stat = "a"+item_num;
	chg_color();

	var idx = top.document.estimateItem.idx.value;

	var ofrm = top.opener.document.poForm;
	var frm  = document.itemForm;
	
	if( idx != '-1' ){
		var len = top.opener.in_table01.rows.length;
		if( len > 1 ){
			ofrm.seq_item[idx].value	= seq;
			ofrm.itemName[idx].value	= eval("document.itemForm.itemName"+item_num).value;
			ofrm.itemDim[idx].value		= eval("document.itemForm.itemDim"+item_num).value;
			ofrm.itemCnt[idx].select();
			ofrm.itemCnt[idx].focus();
		}else{
			ofrm.seq_item.value	= seq;
			ofrm.itemName.value	= eval("document.itemForm.itemName"+item_num).value;
			ofrm.itemDim.value	= eval("document.itemForm.itemDim"+item_num).value;
			ofrm.itemCnt.select();
			ofrm.itemCnt.focus();
		}
		top.self.close();
	}else{
		top.opener.addRow();
		var len = top.opener.in_table01.rows.length;
		if( len > 1 ){
			ofrm.seq_item[len-1].value	= seq;
			ofrm.itemName[len-1].value	= eval("document.itemForm.itemName"+item_num).value;
			ofrm.itemDim[len-1].value	= eval("document.itemForm.itemDim"+item_num).value;
		}else{
			ofrm.seq_item.value	= seq;
			ofrm.itemName.value	= eval("document.itemForm.itemName"+item_num).value;
			ofrm.itemDim.value	= eval("document.itemForm.itemDim"+item_num).value;
		}
	
	}
	parent.itemLenView();
}
function chg_color(){
	eval( sel_stat + ".style.background = '#08246B';" );
	eval( sel_stat + ".style.color = '#FFFFFF';" );
}
function move(pge){
	document.location = "item_fm2_list.jsp?nowPage="+pge+"&seq=<%=seq%>";
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 class="xnoscroll">


<table cellpadding="0" cellspacing="0" border="0" width="100%">
<form name="itemForm" method="post">


<%	for( int i=0 ; i<vecMakeCom.size() ; i++ ){		
		Item im = (Item)vecMakeCom.get(i);	%>

<tr height=20>
	<td class="bk2_1">
		<a id="a<%=i%>" style="cursor:hand;" onclick="javascript:sel_item('<%=i%>','<%=im.seq%>')">
		<IMG SRC="/images/icon_box1.gif" BORDER="0" ALT="" align=absmiddle>
			<%=im.itemModel%> / <%=im.itemDim%></a></td>
		<textarea name="itemName<%=i%>" style="display:none"><%=KUtil.nchk(im.itemModel)%></textarea>
		<textarea name="itemDim<%=i%>" style="display:none"><%=KUtil.nchk(im.itemDim)%></textarea>
</tr>

<%	}//for	
	
	if( vecMakeCom.size() < 1 ){	%>
<tr height=50 align=center>
	<td>품명이 존재하지 않습니다.</td>
</tr>		
<%	}	%>


<tr height=20 align=center>
	<td class="bgc1">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td>&nbsp;<%=indicator%></td>
			<td align=right>
				<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<select name="sk">
							<option value="itemModel" <%=sk.equals("itemModel")?"selected":""%>>모델</option>
							<option value="itemDim" <%=sk.equals("itemDim")?"selected":""%>>규격</option>
							<option value="content" <%=sk.equals("content")?"selected":""%>>내용</option>
						</select></td>
					<td><input type="text" name="st" value="<%=st%>" class="inputbox" size="10"></td>
					<td><input type="submit" value="검색" class="inputbox2">&nbsp;</td>
				</tr>
				</table>
					
					
					
			</tr>
			</table></td>
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
