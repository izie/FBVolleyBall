package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoNo;
import com.izect.fiamm.domain.SetupItem;
import com.izect.fiamm.domain.User;

public interface SetupItemMapper {
	public Entity getIncreNum(@Param("sk") String tableName);
	public int insert1(SetupItem si);
	public int insert2(List<SetupItem> vecSetupItem); // SO
	public int[] insert3(@Param("seq") int seq, @Param("seq_po") int seq_po, @Param("seq_poitem") int seq_poitem, @Param("cnt") int cnt, @Param("itemName") String itemName);
	public SetupItem selectOne(@Param("sk") int seq);
	public int getCnt(@Param("sk") int seq_poItem);
	public int getPoSum(@Param("sk") int seq_po);
	public int getCount(@Param("sk") int seq_poItem);
	public int deleteOne(@Param("sk") int seq);
	public int delete(@Param("sk") int seq_setup);
	public int deleteIn(@Param("sk") String seq_setupitem);
	public List<SetupItem> getList(@Param("sk") int seq_setup);
	public List<SetupItem> getListInPo(@Param("sk") int seq_po);
	public List<SetupItem> getListIn(@Param("sk") String seq_pil);
	public int update(SetupItem si);
	public boolean selectCheck(@Param("sk") int seq_po);
	public int getSum(@Param("sk") int seq_poItem);
	
}
