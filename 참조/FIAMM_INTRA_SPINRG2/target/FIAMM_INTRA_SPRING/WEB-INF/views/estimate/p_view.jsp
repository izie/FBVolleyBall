<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%@ include file="/inc/inc_per_r.jsp"%>

<%
try{ 
	int seq = KUtil.nchkToInt(request.getParameter("seq"));
%>


<HTML>
<HEAD>
<title>피암코리아</title>


<jsp:include page="/inc/inc_script.jsp" flush="true" />
<script language="javascript">
function print_preview(){
	if(factory.printing){
		factory.printing.header = "";
		factory.printing.footer = "";
		factory.printing.portrait = true;
		//factory.printing.leftMargin = 12.0;
		//factory.printing.topMargin = 20.0;
		//factory.printing.rightMargin = 10.0;
		//factory.printing.bottomMargin = 5.0; 
		// factory.printing.printBackground = true; //유료 서비스
		
		// enable control buttons
		fullsize();
		show1('noprint','none');
		var templateSupported = factory.printing.IsTemplateSupported();
		if( templateSupported  ){
			factory.printing.Preview();
		}
		resize(730,730);
		show1('noprint','block');
	}else{
		alert("ActiveX Print 프로그램을 설치하십시요!");
		return;
	}
	
}
</script>
</HEAD>

<BODY leftmargin="0" topmargin="0">
<table cellpadding="0" cellspacing="0" border="1" width="100%" height="100%">
<tr valign=top valign=center>
	<td><iframe id="pnt_view" name="pnt_view" src="view.jsp?seq=<%=seq%>" width="700" height="100" frameborder=1></iframe></td>
</tr>
</table>

</BODY>
</HTML>
<%	

}catch(Exception e){
	out.print(e.toString());
}
%>

<SCRIPT LANGUAGE="JavaScript">
fullsize();
</SCRIPT>

<object id=factory viewastext style="display:none"
classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814"
  codebase="/printx/scriptx/ScriptX.cab#Version=6,2,433,9">
</object>