package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Link;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoItem;
import com.izect.fiamm.domain.PoSum;
import com.izect.fiamm.domain.User;

public interface PoMapper {
	public int getTotal1(@Param("sk") String sk, @Param("st") String st,
                         @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds);

	public int getTotal2(@Param("sk") String sk, @Param("st") String st,
                         @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds,
                         @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                         @Param("schKinds") String schKinds, @Param("schKinds") String poKind);

	public int getTotal3(@Param("sk") String sk, @Param("st") String st,
                         @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds,
                         @Param("seq_client") int sStDate, @Param("sEdDate") int sEdDate,
                         @Param("schKinds") String schKinds);

	public double getSum1(@Param("sk") String sk, @Param("st") String st,
                          @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds);

	public List<PoSum> getSum2(@Param("sk") String sk, @Param("st") String st,
                               @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds,
                               @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                               @Param("schKinds") String schKinds);

	public int insert(Po po);

	public List<Po> getList1(@Param("start") int start, @Param("pageSize") int pageSize,
                             @Param("sk") String sk, @Param("st") String st,
                             @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds);

	public List<Po> getList2(@Param("start") int start, @Param("pageSize") int pageSize,
                             @Param("sk") String sk, @Param("st") String st,
                             @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds,
                             @Param("oby") String oby, @Param("sStDate") int sStDate,
                             @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds,
                             @Param("poKind") String poKind);

	public List<Po> getList3(@Param("seq_project") int seq_project);

	public List<Po> getList4(@Param("start") int start, @Param("pageSize") int pageSize,
                             @Param("sk") String sk, @Param("st") String st,
                             @Param("seq_client") int seq_client, @Param("priceKinds") String priceKinds,
                             @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                             @Param("schKinds") String schKinds, @Param("oby") String oby);

	public Po selectOne(@Param("seq") int seq);

	public int calcMoney(@Param("taxPrice") double taxPrice, @Param("poTotPrice") double poTotPrice, @Param("seq_po") int seq_po);

	public int updatePo(Po po);

	public int update1(@Param("seq") int seq, @Param("eventMsg") String eventMsg);

	public int update2(Po po, @Param("saveDir") String saveDir);

	public int delete(@Param("seq") int seq);

	public int update3(@Param("seq") int seq, @Param("eff") int eff,
                       @Param("eventMsg") String eventMsg, @Param("saveDir") String saveDir);

	public String getPoNo1(Po po);

	public String getPoNo2(@Param("seq_po") int seq_po);

	public List<Entity> getList6(@Param("seq_contract") int seq_contract,
                                 @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                                 @Param("schKinds") String schKinds);

	public int updateFile(@Param("sEdDate") int seq, @Param("fname") String fileName);

}
