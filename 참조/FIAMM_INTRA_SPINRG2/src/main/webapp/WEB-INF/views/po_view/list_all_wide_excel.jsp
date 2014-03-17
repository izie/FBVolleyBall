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
	int nowPage			= KUtil.nchkToInt(request.getParameter("nowPage"),1);
	String sk			= KUtil.nchk(request.getParameter("sk"));
	String st			= KUtil.nchk(request.getParameter("st"));
	int seq_client		= KUtil.nchkToInt(request.getParameter("seq_client"));
	String priceKinds	= KUtil.nchk(request.getParameter("priceKinds"));
	int pageSize		= KUtil.nchkToInt(request.getParameter("pageSize"),10);
	int sStDate			= KUtil.nchkToInt(request.getParameter("sStDate"));
	int sEdDate			= KUtil.nchkToInt(request.getParameter("sEdDate"));
	String schKinds		= KUtil.nchk(request.getParameter("schKinds"),"p.wDate");
	String oby			= KUtil.nchk(request.getParameter("oby"),"p.poYear DESC,p.poNum DESC,p.poCnt DESC,p.poNumIncre DESC");
	if( sStDate < 1 && sEdDate < 1 ){
		int nowDate			= KUtil.getIntDate("yyyyMMdd");	
		sStDate = KUtil.getNextDate( nowDate, -365*2);
		//sEdDate	= nowDate;
	}

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
	Pass ps = null;
	Link lnk = new Link();
	

	

	
	int totCnt		= poDAO.getTotal1(sk, st, seq_client, priceKinds, sStDate, sEdDate, schKinds);
	int start		= (nowPage*pageSize) - pageSize;
	
	PagingUtil paging = new PagingUtil(pageSize,5,totCnt,nowPage);
	String indicator = paging.getIndi();

	Vector vecPo = poDAO.getList1(0, totCnt, sk, st, seq_client, priceKinds, sStDate, sEdDate, schKinds, oby);


	Vector vecSum = null;
	if( priceKinds.length() > 0 ){
		vecSum = poDAO.getSum1(sk, st, seq_client, priceKinds, sStDate, sEdDate, schKinds);
	}
	

%>


<style type="text/css">
table{
	font-size:10px;
}
</style>

<table cellpadding="0" cellspacing="0" border="1" width="1000">
<tr align=center height=20 bgcolor="#C4ECFF" style="font-weight:bold;">
	<td width="30">Date</td>
	<td width="45">P/O<br>NO</td>
	<td width="45">계약<br>NO</td>
	<td width="10">PO 업체</td>
	<td width="110">금액</td>
	<td>보</td>
	<td width="75">매출처</td>
	<td width="150">품명 [수량]</td>
	<td width="80">설치장소</td>
	
	<td width="55">납기일</td>
	<td width="55">EXW</td>
	<td width="55">ETD</td>
	
	<td width="55">ETA</td>
	<td width="55">통관일</td>
	<td width="55">납품일</td>
	<td width="80">결재방법</td>
	<td width="50">메모</td>
</tr>

<%	for( int i=0 ; i<vecPo.size() ; i++ ){	
		Po po = (Po)vecPo.get(i);				
		Client cl = cDAO.selectOne(po.seq_client);		
		Vector vecPil	 = pilDAO.getList(po.seq);			%>

<tr align=center height=20>
	<td><%=KUtil.dateMode(po.wDate,"yyyyMMdd","yy.MM.dd","&nbsp")%></td>

	<td>
		<FONT <%=po.eff<0?"color='red' style='font-decoraction:line-through'":"COLOR='blue'"%>><%=poDAO.getPoNo(po)%></FONT></td>


	<td>
	<%	int inCnt = 0;
		Vector vecLink = lkDAO.getListCon(po.seq);		
		for( int j=0 ; j<vecLink.size() ; j++ ){
			Contract ct = ctDAO.selectOne(((Integer)vecLink.get(j)).intValue() );
			if( ct.seq > 0 ){
				inCnt++;			%>
			<table width="100%">
			<tr align=center>
				<td><FONT COLOR="blue"><%=KUtil.nchk(ctDAO.getContractNo(ct)," ")%></FONT></td>
			</tr>
			</table>
	<%		}//if 
		}//for Link		

		if( inCnt ==0 ) out.println(" ");		%></td>
	
	
	<td><%=KUtil.nchk(cl.bizName," ")%></td>

	<td align=right><%=po.priceKinds%> <%=NumUtil.numToFmt(po.poTotPrice,"###,###.##","0")%>&nbsp;</td>
	

	<td colspan=11>
		<table cellpadding="0" cellspacing="0" border="1" width="100%" height="100%">
	<%	if( po.eff < 0 ){	%>
		<tr align=center>
			<td colspan=11><B><FONT COLOR="red">CANCEL</FONT></B></td>
		</tr>
	<%	}else{	%>
		<%	for( int h=0 ; h<vecPil.size() ; h++ ){		
				PassItemLnk pil = (PassItemLnk)vecPil.get(h);	
				Vector vecLc = lcDAO.getListPil(pil.seq);		
				Vector vecTt = ttDAO.getListPil(pil.seq);		
				Contract ct = null;
				Client ct1 = null;
				if( pil.seq_contract >0 ) ct = ctDAO.selectOne(pil.seq_contract);
				if( ct != null ) ct1 = cDAO.selectOne(ct.seq_client);				%>
		<tr align=center>
			<td>
				<%=KUtil.nchk(pil.isDropGuar,"N")%></td>
			<td width="75">
				<%	if( ct1==null ) out.print(" ");
					else{
						out.print( KUtil.nchk(ct1.bizName," ") );		}%></td>
			<td width="150" align=left>
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<%	Vector vecSetupItem = siDAO.getListIn(pil.seq_setupitem);
				for( int g=0 ; g<vecSetupItem.size() ; g++ ){	
					SetupItem si = (SetupItem)vecSetupItem.get(g);			
					PoItem pi = poiDAO.selectOne(si.seq_poitem);	%>		
				<tr>
					<td><%=KUtil.nchk(pi.itemName)%> <FONT COLOR="#3300CC">[<%=KUtil.intToCom(si.cnt)%>]</FONT></td>
				</tr>			
			<%	}//for	%>
				</table></td>
			<td width="80">
				<%=KUtil.nchk(pil.place," ")%></td>
			
			<td width="55">
				<%=KUtil.dateMode(pil.currDate,"yyyyMMdd","yy.MM.dd",KUtil.nchk(pil.currDateMemo) )%></td>
			<td width="55">
				<%	ps = psDAO.selectLastOne(pil.seq,"EXW");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , " "));
					else out.print(KUtil.nchk(ps.memo," "));		%></td>
			<td width="55">
				<%	ps = psDAO.selectLastOne(pil.seq,"ETD");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , " "));
					else out.print(KUtil.nchk(ps.memo," "));		%></td>

			<td width="55">
				<%	ps = psDAO.selectLastOne(pil.seq,"ETA");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , " "));
					else out.print(KUtil.nchk(ps.memo," "));		%></td>
			<td width="55">
				<%	ps = psDAO.selectLastOne(pil.seq,"통관일");
					if( ps.passDate > 0 ) out.print(KUtil.dateMode(  ps.passDate, "yyyyMMdd","yy.MM.dd" , " "));
					else out.print(KUtil.nchk(ps.memo," "));		%></td>
			<td width="55">
				<%=KUtil.dateMode(pil.deliDate,"yyyyMMdd","yy.MM.dd"," ")%></td>
			<td width="80" align=center>
				
				<%	if( vecLc.size() > 0 || ( pil.isUse==0 && KUtil.nchk(po.termPay).indexOf("L/C") > -1 ) ){	%>
					L/C
				<%	}else if( vecLc.size()<1 && KUtil.nchk(po.termPay).indexOf("L/C") > -1 ){	%>
					<font color="#2F26CC">L/C</font>
				<%	}	%>

				<%	if( vecTt.size() > 0 || ( pil.isUse==0 && KUtil.nchk(po.termPay).indexOf("L/C") > -1 ) ){	%>
					T/T
				<%	}else if( vecTt.size()<1 && KUtil.nchk(po.termPay).indexOf("T/T") > -1 ){	%>
					<font color="#C4690F">T/T</font>
				<%	}	%>

				<%	if( KUtil.nchk(po.termPay).indexOf("FOC") > -1 ){	%>
					FOC
				<%	}	%>
			</td>
		</tr>
		<%	}//for		%>
<%	}//if	%>
		</table></td>
	<td><%=KUtil.nchk(po.eventMsg," ")%></td>
</tr>
<%	}//for	최상위%>

	
<%	if( vecSum != null ){		%>
<tr height=25  align=right>
	<td colspan=3 >합계:&nbsp;</td>
	<td>
	<%	for( int i=0 ; i<vecSum.size() ; i++ ){		
			PoSum psm = (PoSum)vecSum.get(i);	%>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td align=right><%=psm.priceKinds%> <%=NumUtil.numToFmt(psm.price,"###,###.##","0")%>&nbsp;</td>
		</tr>
		</table>
	<%	}//for	%></td>
	<td colspan=13>&nbsp;</td>
</tr>
<%	}//if		%>
</table>
<%
}catch(Exception e){
	out.print(e.toString());
}finally{
	db.closeAll();
}
%>
