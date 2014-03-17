package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoNo;
import com.izect.fiamm.domain.TT_payment;
import com.izect.fiamm.domain.User;

public interface TT_paymentMapper {
	public int insert(TT_payment tp);
	public List<TT_payment> getList(@Param("seq_tt") int seq_tt);
	public int getListCnt(@Param("seq_tt") int seq_tt);
	public int delete(@Param("seq") int seq);
	public int deleteAll(@Param("seq_tt") int seq_tt);
	public TT_payment selectOne(@Param("seq") int seq);
	
}
