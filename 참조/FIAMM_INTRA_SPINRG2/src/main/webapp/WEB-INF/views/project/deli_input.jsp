<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db = new Database();
try{ 
	int seq			= KUtil.nchkToInt(request.getParameter("seq"));
	EstItemOutDAO eoDAO = new EstItemOutDAO(db);

	EstItemOut eo = eoDAO.selectOne(seq);
%>
<form name="inform">

<input type="hidden" name="seq" value="<%=eo.seq%>">
<input type="hidden" name="deliDate" value="<%=eo.deliDate>0?eo.deliDate+"":""%>">
<input type="hidden" name="realDeliDate" value="<%=eo.realDeliDate>0?eo.realDeliDate+"":""%>">
<input type="hidden" name="setupDate" value="<%=eo.setupDate>0?eo.setupDate+"":""%>">
<textarea name="place" style="display:none"><%=KUtil.nchk(eo.place)%></textarea>
<input type="hidden" name="cnt" value="<%=eo.cnt>0?eo.cnt+"":""%>">

</form>

<SCRIPT LANGUAGE="JavaScript">
var pfrm	= parent.document.modform;
var frm		= document.inform;
pfrm.seq.value			= frm.seq.value;
pfrm.deliDate.value		= frm.deliDate.value;
pfrm.realDeliDate.value = frm.realDeliDate.value;
pfrm.setupDate.value	= frm.setupDate.value;
pfrm.place.value		= frm.place.value;
pfrm.cnt.value		= frm.cnt.value;
pfrm._cnt.value		= frm.cnt.value;
</SCRIPT>
<%	

}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>