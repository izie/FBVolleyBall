package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Lc;
import com.izect.fiamm.domain.Pass;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoItem;
import com.izect.fiamm.domain.PoNo;
import com.izect.fiamm.domain.PoSum;
import com.izect.fiamm.domain.User;

public interface PassMapper {
	public List<Pass> getList(@Param("seq_passitemlnk") int seq_passitemlnk,
                              @Param("passCode") String passCode);

	public int getCnt(@Param("seq_passitemlnk") int seq_passitemlnk);

	public int insert(Pass ps);

	public int delete(@Param("seq") int seq);

	public List<Entity> selectSeq(@Param("seq_po") int seq_po);

	public List<Entity> selectSeq2(@Param("seq_passitemlnk") int seq_passitemlnk);

	public Pass selectOne(@Param("seq") int seq);

	public Pass selectLastOne(@Param("seq_passitemlnk") int seq_passitemlnk,
                              @Param("passCode") String passCode);

	public int update(Pass ps);

	public int updateLastInfo(Pass ps);

	public int chkAlertUpdate(Pass ps);
}
