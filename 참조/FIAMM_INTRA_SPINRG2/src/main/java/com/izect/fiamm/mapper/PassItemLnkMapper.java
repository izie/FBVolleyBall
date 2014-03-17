package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Pass;
import com.izect.fiamm.domain.PassItemLnk;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoNo;
import com.izect.fiamm.domain.SetupItem;
import com.izect.fiamm.domain.User;

public interface PassItemLnkMapper {
	public  int insert(@Param("seq_po") int seq_po, @Param("seq_list") String seq_list, @Param("seq_contract") int seq_contract, @Param("place") String place);
	public List<SetupItem> getList(@Param("seq_po") int seq_po);
	public PassItemLnk selectOne(@Param("seq") int seq);
	public  int delete(@Param("seq") int seq);
	public  int update(PassItemLnk pil);
	public int poCntSameChk(@Param("seq_po") int seq_po);
	public  int update2(@Param("seq_pil") int seq_pil, @Param("seq_contract") int seq_contract);
	public  int update3(@Param("passCode") String passCode, @Param("passDate") int passDate, @Param("seq_passitemlnk") int seq_passitemlnk);
	public  int getCntPo(@Param("seq_po") int seq_po);
	
}
