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
import com.izect.fiamm.domain.User;

public interface LcMapper {
	public PoSum getValue1(@Param("sk") String sk, @Param("st") String st,
                           @Param("bankCode") String bankCode,
                           @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                           @Param("seq_passItemLnk") int seq_passItemLnk,
                           @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                           @Param("schKinds") String schKinds,
                           @Param("priceKinds") String priceKinds,
                           @Param("pKinds") String pKinds, @Param("viewMode") String viewMode);

	public PoSum getValue2(@Param("sk") String sk, @Param("st") String st,
                           @Param("bankCode") String bankCode,
                           @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                           @Param("seq_passItemLnk") int seq_passItemLnk,
                           @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                           @Param("schKinds") String schKinds,
                           @Param("priceKinds") String priceKinds,
                           @Param("pKinds") String pKinds, @Param("viewMode") String viewMode);

	public int getTotal(@Param("sk") String sk, @Param("st") String st,
                        @Param("bankCode") String bankCode,
                        @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                        @Param("seq_passItemLnk") int seq_passItemLnk,
                        @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate,
                        @Param("schKinds") String schKinds,
                        @Param("priceKinds") String priceKinds,
                        @Param("pKinds") String pKinds, @Param("viewMode") String viewMode);

	public List<Lc> getList1(@Param("start") int start,
                             @Param("pageSize") int pageSize, @Param("sk") String sk,
                             @Param("st") String st, @Param("bankCode") String bankCode,
                             @Param("seq_client") int seq_client, @Param("seq_po") int seq_po,
                             @Param("seq_passItemLnk") int seq_passItemLnk,
                             @Param("oby") String oby, @Param("sStDate") int sStDate,
                             @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds,
                             @Param("priceKinds") String priceKinds,
                             @Param("pKinds") String pKinds, @Param("viewMode") String viewMode);

	public List<Lc> getList2(@Param("seq_po") int seq_po);

	public List<Lc> getListPil(@Param("seq_passItemLnk") int seq_passItemLnk);

	public int getListPilCnt(@Param("seq_passItemLnk") int seq_passItemLnk);

	public int getListCnt(@Param("seq_po") int seq_po);

	public Lc selectOne(@Param("seq") int seq);

	public Lc selectOnePo(@Param("seq_po") int seq_po);

	public int insert(Lc lc);

	public int update(Lc lc);

	public int deleteOne(@Param("seq") int seq);

	public int delete(@Param("seq_po") int seq_po);

	public int chkInAlert(Lc lc);
}
