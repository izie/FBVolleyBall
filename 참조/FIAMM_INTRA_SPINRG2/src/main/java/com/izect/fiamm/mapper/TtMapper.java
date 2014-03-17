package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Lc;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoItem;
import com.izect.fiamm.domain.PoNo;
import com.izect.fiamm.domain.PoSum;
import com.izect.fiamm.domain.Tt;
import com.izect.fiamm.domain.User;

public interface TtMapper {
	public List<PoSum> getSum(@Param("sk") String sk, @Param("st") String st,
                              @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                              @Param("seq_passItemLnk") int seq_passItemLnk, @Param("sStDate") int sStDate,
                              @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds,
                              @Param("priceKinds") String priceKinds, @Param("viewMode") String viewMode);

	public int getTotal(@Param("sk") String sk, @Param("st") String st,
                        @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                        @Param("seq_passItemLnk") int seq_passItemLnk, @Param("sStDate") int sStDate,
                        @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds,
                        @Param("priceKinds") String priceKinds, @Param("viewMode") String viewMode);

	public List<Lc> getList1(@Param("start") int start, @Param("pageSize") int pageSize,
                             @Param("sk") String sk, @Param("st") String st,
                             @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                             @Param("seq_passItemLnk") int seq_passItemLnk, @Param("oby") String oby,
                             @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                             @Param("schKinds") String schKinds, @Param("priceKinds") String priceKinds,
                             @Param("viewMode") String viewMode);

	public List<PoSum> getSum1(@Param("sk") String sk, @Param("st") String st,
                               @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                               @Param("seq_passItemLnk") int seq_passItemLnk, @Param("sStDate") int sStDate,
                               @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds,
                               @Param("priceKinds") String priceKinds);

	public int getTotal1(@Param("sk") String sk, @Param("st") String st,
                         @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                         @Param("seq_passItemLnk") int seq_passItemLnk, @Param("sStDate") int sStDate,
                         @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds,
                         @Param("priceKinds") String priceKinds);

	public List<Tt> getList2(@Param("start") int start, @Param("pageSize") int pageSize,
                             @Param("sk") String sk, @Param("st") String st,
                             @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                             @Param("seq_passItemLnk") int seq_passItemLnk, @Param("oby") String oby,
                             @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                             @Param("schKinds") String schKinds, @Param("priceKinds") String priceKinds);

	public List<Tt> getList3(@Param("seq_po") int seq_po);

	public List<Tt> getListPil(@Param("seq_passItemLnk") int seq_passItemLnk);

	public int getListPilCnt(@Param("seq_passItemLnk") int seq_passItemLnk);

	public int getListCnt(@Param("seq_po") int seq_po);

	public Tt selectOne(@Param("seq") int seq);

	public Tt selectOnePo(@Param("seq_po") int seq_po);

	public int insert(Tt tt);

	public int update(Tt tt);

	public int deleteOne(@Param("seq") int seq);

	public int delete(@Param("seq_po") int seq_po);

	public int chkInAlert(Tt tt);

	public int updatePrice(@Param("seq") int seq, @Param("price") double price);
}
