<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%
	Database db  = new Database();
try{ 
		
	int seq_client = KUtil.nchkToInt(request.getParameter("seq_client"));

	ClientUserDAO cuDAO = new ClientUserDAO(db);
	Vector vecClientUser = cuDAO.getClientUser(seq_client);	%>



<HTML>
<head>
<jsp:include page="/inc/inc_script.jsp" flush="true" />
<SCRIPT LANGUAGE="JavaScript">
function chkSel(){
	var frm = document.clientForm;
	var ofrm = parent.opener.document.poForm;
	ofrm.seq_clientUser.value="";
	ofrm.clientUser_name.value="";
	var strSeq	= "";
	var strName = "";
	var cnt = 0;
	if( frm.seq_clientUser.length ){	//여러개일때
		for( var i=0 ; i<frm.seq_clientUser.length ; i++ ){
			if( frm.seq_clientUser[i].checked ){
				if( cnt > 0 ){
					strSeq	+= ",";
					strName += ",";
				}//if
				strSeq  += frm.seq_clientUser[i].value;
				strName += eval("document.clientForm.clientUser_name"+i).value;
				cnt++;
			}//if
			
		}//for
	}else{	//1개일때
		if( frm.seq_clientUser.checked ){
			strSeq  = frm.seq_clientUser.value;
			strName = eval("document.clientForm.clientUser_name0").value;
		}
	}
	ofrm.seq_clientUser.value = strSeq;
	ofrm.clientUser_name.value = strName;
}
</SCRIPT>
</head>
<BODY leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0 valign=top class="xnoscroll">
<table cellpadding="0" cellspacing="0" border="0" width="200" >
<form name="clientForm" method="post">
<input type="hidden" name="seq_client" value="<%=seq_client%>">
<%	for( int i=0 ; i<vecClientUser.size() ; i++ ){		
		ClientUser cu = (ClientUser)vecClientUser.get(i);	%>
		<tr height="20">
			<td class="bk2_1">
			<input type="checkbox" name="seq_clientUser" value="<%=cu.seq%>" onclick="chkSel()">
			<IMG SRC="/images/icon_user.gif" BORDER="0" ALT=""> <%=cu.userName%>
			<textarea name="clientUser_name<%=i%>" style="display:none"><%=cu.userName%></textarea></td>
		</tr>
<%	}//for	%>

<%	if( vecClientUser.size()<1 ){	%>
		<tr height="50">
			<td>담당자가 없습니다.</td>
		</tr>

<%	}	%>
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