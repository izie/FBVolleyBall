package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoItem;
import com.izect.fiamm.domain.PoNo;
import com.izect.fiamm.domain.User;

public interface PoItemMapper {
	public int insert(PoItem pi);
	public int update(PoItem pi);
	public List<PoItem> getList(@Param("seq_po") int seq_po);
	public PoItem selectOne(@Param("seq") int seq);
	public int delete(@Param("seq_item") int seq_item);
	public int deletePo(@Param("seq_po") int seq_po);
	public int update1(List<PoItem> vecPoItem, int seq_po);
	public int getPoSum(@Param("seq_po") int seq_po);
}
