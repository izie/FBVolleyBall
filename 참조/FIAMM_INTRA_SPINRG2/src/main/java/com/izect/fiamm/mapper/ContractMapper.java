package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Contract;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Link;
import com.izect.fiamm.domain.PoSum;

public interface ContractMapper {
	public int insert(Contract ct);
	public int getTotal(@Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client);
	public int getTotal2(@Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client, @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds, @Param("priceKinds") String priceKinds);
	public List<PoSum> getSum(@Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client,
                              @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds, @Param("priceKinds") String priceKinds);
	public List<Contract> getList(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client);
	public List<Contract> getList2(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client, @Param("oby") String oby, @Param("priceKinds") String priceKinds);
	public List<Contract> getList3(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client, @Param("oby") String oby, @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds, @Param("priceKinds") String priceKinds);
	
	public Contract selectOne(@Param("seq") int seq);
	
	public int update(@Param("ct") Contract ct);
	public int delete(@Param("seq") int seq);
	public List<Contract> getList4(@Param("seq_client") int seq_client);
	public List<Contract> getListInProject(@Param("seq_project") int seq_project);
	public List<Contract> getListInPo(@Param("seq_po") int seq_po);
	public int getListInProjectCnt(@Param("seq_project") int seq_project);
	public List<Contract> getListEstSeq(@Param("seq_project") int seq_project);//public String getListEstSeq(int seq_project);
	public Contract getListOne(@Param("seq_project") int seq_project);
	public List<Contract> getListInEstimate(@Param("seq_estimate") int seq_estimate);
	public int getCntInEstimate(@Param("seq_estimate") int seq_estimate);
	public boolean updateState(Contract ct);
	public int updateFile(@Param("seq") int seq, @Param("fileName") String fileName);
	
}
