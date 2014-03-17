<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %>
<% 
	String fName = KUtil.toEng("PO리스트_"+KUtil.getDate("yyyyMMdd")+".xls");
	response.setHeader("Content-Disposition", "attachment; filename="+fName); 
	response.setHeader("Content-Description", "JSP Generated Data"); 
%>
<%@ page import = "java.sql.*"%>				 
<%@ page import = "java.util.*,java.io.*"%>				 
<%@ page import = "pool.*,com.util.khs.*,dao.*"%>
<% request.setCharacterEncoding("euc-kr");  %>

<%@ include file="/inc/inc_loginCheck.jsp"%>

<%

	Database db = new Database();

try{ 


	//request
	int nowPage		= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk		= KUtil.nchk(request.getParameter("sk"));
	String st		= KUtil.nchk(request.getParameter("st"));
	int seq_client	= KUtil.nchkToInt(request.getParameter("seq_client"));
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	//생성자
	ProjectDAO pDAO			= new ProjectDAO(db);
	PoDAO poDAO				= new PoDAO(db);
	LinkDAO lkDAO			= new LinkDAO(db);
	ContractDAO ctDAO		= new ContractDAO(db);
	PoItemDAO poiDAO		= new PoItemDAO(db);
	ClientDAO cDAO			= new ClientDAO(db);
	ClientUserDAO cuDAO		= new ClientUserDAO(db);
	PassDAO psDAO			= new PassDAO(db);
	PassItemLnkDAO pilDAO	= new PassItemLnkDAO(db);
	SetupItemDAO siDAO		= new SetupItemDAO(db);
	LcDAO lcDAO				= new LcDAO(db);
	TtDAO ttDAO				= new TtDAO(db);
	PriceKindsDAO pkDAO		= new PriceKindsDAO(db);
	Link lnk = new Link();
	

	

	double sumVal	= poDAO.getSum(sk, st, seq_client, priceKinds);
	int totCnt		= poDAO.getTotal(sk, st, seq_client, priceKinds);
	int pageSize	=  10;// 한페이지에 보여줄 사이즈
	int start		= (nowPage*pageSize) - pageSize;
	
	PagingUtil paging = new PagingUtil(pageSize,5,totCnt,nowPage);
	String indicator = paging.getIndi();

	Vector vecPo = poDAO.getList(start, totCnt, sk, st, seq_client, priceKinds);
%>

<table cellpadding="0" cellspacing="0" border="1" width="1148">
<tr align=center height=20 bgcolor="#B3BFD9">
	<td width="60"><B>Date</B></td>
	<td width="60">P/O<br>NO</td>
	<td width="60">계약<br>NO</td>
	<td width="150">금액(계약처)</td>
	<td>보</td>
	<td width="220">품명</td>
	<td width="130">설치장소</td>
	<td width="60">납기일</td>
	<td width="60">EXW</td>
	<td width="60">ETD</td>
	<td width="60">ETA</td>
	<td width="60">통관</td>
	<td width="60">납품</td>
	<td width="60">결재</td>
</tr>
<%	for( int i=0 ; i<vecPo.size() ; i++ ){	
		Po po = (Po)vecPo.get(i);		
		Client cl = cDAO.selectOne(po.seq_client);		
		Vector vecPil	 = pilDAO.getList(po.seq);
															%>

<tr align=center height=20>
	<td><%=KUtil.dateMode(po.wDate, "." , " ")%></td>

	<td align=left> <%=poDAO.getPoNo(po)%></td>


	<td>
	<%	int inCnt = 0;
		Vector vecLink = lkDAO.getList(po.seq);		
		for( int j=0 ; j<vecLink.size() ; j++ ){
			Link lk = (Link)vecLink.get(j);	
			Project pj = pDAO.selectOne(lk.seq_project);
			Vector vecContract = ctDAO.getListInProject(pj.seq);	
			for( int k=0 ; k<vecContract.size() ; k++ ){	
				Contract ct = (Contract)vecContract.get(k);		inCnt++;			%>
			<div><%=KUtil.nchk(ctDAO.getContractNo(ct)," ")%></div>
	<%		}//for
		}//for Link		
		if( inCnt ==0 ) out.println(" ");		%></td>
	
	<td>
		<%=po.priceKinds%> <%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","0")%>
		<br>
		( <%=KUtil.nchk(cl.bizName," ")%> )</td>

	<td colspan=10>
		<table cellpadding="0" cellspacing="0" border="1" width="100%" height="100%">
		<%	for( int h=0 ; h<vecPil.size() ; h++ ){		
				PassItemLnk pil = (PassItemLnk)vecPil.get(h);	
				Vector vecLc = lcDAO.getListPil(pil.seq);		
				Vector vecTt = ttDAO.getListPil(pil.seq);		%>
		<tr align=center>
			<td><%=KUtil.nchk(pil.isDropGuar,"N")%></td>
			<td width="220">
			<%	Vector vecSetupItem = siDAO.getListIn(pil.seq_setupitem);
				for( int g=0 ; g<vecSetupItem.size() ; g++ ){	
					SetupItem si = (SetupItem)vecSetupItem.get(g);			
					PoItem pi = poiDAO.selectOne(si.seq_poitem);	%>		
				<div><%=KUtil.nchk(pi.itemName)+" "+KUtil.nchk(pi.itemDim)%> 수량:<%=KUtil.intToCom(si.cnt)%></div>
			<%	}//for	%></td>
			<td width="130"><%=KUtil.nchk(pil.place," ")%></td>
			<td width="60"><%=KUtil.dateMode(pil.currDate,"."," ")%></td>
			<td width="60"><%=KUtil.dateMode( psDAO.selectLastOne(pil.seq,"EXW").passDate , "." , " ")%></td>
			<td width="60"><%=KUtil.dateMode( psDAO.selectLastOne(pil.seq,"ETD").passDate , "." , " ")%></td>
			<td width="60"><%=KUtil.dateMode( psDAO.selectLastOne(pil.seq,"ETA").passDate , "." , " ")%></td>
			<td width="60"><%=KUtil.dateMode( psDAO.selectLastOne(pil.seq,"통관일").passDate , "." , " ")%></td>
			<td width="60"><%=KUtil.dateMode(pil.deliDate,"."," ")%></td>
			<td width="60">
				<%	for( int m=0 ; m<vecLc.size() ; m++ ){	
						Lc lc = (Lc)vecLc.get(m);					%>
				<div><%=KUtil.dateMode( lc.lcPayDate , "." , " ")%></div>
				<%	}//for m	%>
				<%	for( int m=0 ; m<vecTt.size() ; m++ ){	
						Tt tt = (Tt)vecTt.get(m);					%>
				<div><%=KUtil.dateMode( tt.payDate , "." , " ")%></div>
				<%	}//for m	%>
				<%=vecLc.size()+vecTt.size()<1?" ":""%></td>
		</tr>
			
			
		</tr>
		<%	}//for	%>
		</table></td>
</tr>

<%	}//for	최상위%>
</table>


<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
