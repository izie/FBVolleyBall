<%@page language="Java" contentType="text/html; charset=euc-kr"%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%
	Database db = new Database();
try{ 
	ProjectDAO pDAO = new ProjectDAO(db);
	ContractDAO ctDAO = new ContractDAO(db);
	LinkDAO lkDAO = new LinkDAO(db);
	PoDAO poDAO		= new PoDAO(db);

	Vector vecChkList = pDAO.getChkList();
%>
<SCRIPT LANGUAGE="JavaScript">
function clickProject(seq){
	var lft = (screen.availWidth-700)/2;
	var tp	= (screen.availHeight-390)/2;
	var pop = window.open("/main/project/mod.jsp?seq="+seq,"modeProject","width=700,height=390,scrollbars=0,left="+lft+",top="+tp);
	pop.focus();
}
function modifyContract(seq){
	var lft = (screen.availWidth-700)/2;
	var tp = (screen.availHeight-660)/2;
	var pop = window.open("/main/contract/mod.jsp?seq="+seq,"contractView","top="+tp+",left="+lft+",scrollbars=0,width=700,height=660");
	pop.focus();
}
function goWritePo(seq_project){
	var lft = (screen.availWidth-720)/2;
	var tp	= (screen.availHeight-650)/2;
	var pop = window.open("/main/po/write.jsp?seq_project="+seq_project,"writePo","width=720,height=650,scrollbars=1,resizable=1,left="+lft+",top="+tp);
	pop.focus(); 
}
function goProjView(seq_project){
	var lft = (screen.availWidth-870)/2;
	var tp	= (screen.availHeight-650)/2;
	var pop = window.open("/main/project/list_project.jsp?seq_project="+seq_project,"projectListView","width=870,height=650,scrollbars=1,resizable=1,left="+lft+",top="+tp);
	pop.focus(); 
}
function poView(seq_po){
	var tp = (screen.availHeight-700)/2;
	var lt = (screen.availWidth-720)/2;
	var pop = window.open("/main/po/mod.jsp?seq_po="+seq_po,"poView","top="+tp+",scrollbars=1,height=700,width=720,resizable=1,left="+lt);
	pop.focus();
}
</SCRIPT>

<table cellpadding="0" cellspacing="1" border="0" width="800">
<tr height="25">
	<td class="ti1" colspan>&nbsp;▶ 프로젝트 체크</td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" width="800">
<tr align=center height=25>
	<td class="menu1" width="60">시작일</td>
	<td class="menu1">제조업체</td>
	<td class="menu1">프로젝트명</td>
	<td class="menu1" width="80">계약</td>
	<td class="menu1" width="80">PO</td>
	<td class="menu1" width="80">통관</td>
	<td class="menu1" width="80">LC/TT</td>
</tr>
<%	if( vecChkList.size() < 1 ){	%>
<tr align=center height=50>
	<td colspan=8>체크할 프로젝트가 없습니다</td>
</tr>
<%	}%>
<%	for( int i=0 ; i<vecChkList.size() ; i++ ){		
		Project pj = (Project)vecChkList.get(i);		
		Vector vecContract = ctDAO.getListInProject(pj.seq);			
		Vector vecLink = lkDAO.getListProj(pj.seq);		
		String cls = i%2==0?"menu2_1":"menu2";		%>
<tr align=center height=25>
	<td class="<%=cls%>"><%=KUtil.dateMode(pj.stDate,".","&nbsp;")%></td>
	<td class="<%=cls%>"><%=KUtil.nchk(pj.itemCom,"&nbsp;")%></td>
	<td class="<%=cls%>" align=left>&nbsp;<A HREF="javascript:" onclick="clickProject('<%=pj.seq%>')"><%=KUtil.nchk(pj.name)%></A></td>
	<td class="<%=cls%>"><%	if( pj.chkContract==0 ){	
				for( int j=0 ; j<vecContract.size() ; j++ ){
					Contract ct = (Contract)vecContract.get(j);		%>
			<A HREF="javascript:modifyContract('<%=ct.seq%>')"><font color='red'>체크요망</font></A>
		<%		}//for
			}else{ out.print("&nbsp;");	}%></td>
	<td colspan=3>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
				<%	if( pj.chkPo==0 ){	%>
					<tr align=center>
						<td class="<%=cls%>" width="80"><A HREF="javascript:goWritePo('<%=pj.seq%>')"><font color='red'>PO없음</font></A></td>
						<td class="<%=cls%>" width="80">&nbsp;</td>
						<td class="<%=cls%>" width="80">&nbsp;</td>
					</tr>
				<%	}else{
						for( int g=0 ; g<vecLink.size() ; g++ ){	
							dao.Link lk = (dao.Link)vecLink.get(g);
							Po po = poDAO.selectOne(lk.seq_po);		
							if( po.chkLcTt == 0 || po.chkPass==0 ){	%>
					<tr align=center>
						<td class="<%=cls%>" width="80"><A HREF="javascript:poView('<%=po.seq%>')"><%=poDAO.getPoNo(po)%></A></td>
						<td class="<%=cls%>" width="80">
							<%	if( po.chkPass==0 ){	%>
								<A HREF="javascript:goProjView('<%=pj.seq%>')"><font color='red'>체크요망</font></A>
							<%	}else{	out.print("&nbsp;");	}	%></td>
						<td class="<%=cls%>" width="80">
							<%	if( po.chkLcTt==0 ){	%>
								<A HREF="javascript:goProjView('<%=pj.seq%>')"><font color='red'>체크요망</font></A>
							<%	}else{	out.print("&nbsp;");	}	%></td>
					</tr>
				<%			}//if
						}//for g
					}//if	%></td>		
		</table></td>
</tr>
<%	}//for	%>
</table>

<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
	db = null;
}
%>