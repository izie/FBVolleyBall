package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Po;
import com.izect.fiamm.domain.PoNo;
import com.izect.fiamm.domain.User;

public interface MngNoMapper {
	public PoNo selectLast(@Param("poYear") int poYear);
	public PoNo selectOne1(@Param("poYear") int poYear, @Param("poNum") int poNum);
	public  int selectOne2(@Param("poYear") int poYear, @Param("poNum") int poNum, @Param("poCnt") int poCnt);
	public  int selectOne3(@Param("poYear") int poYear, @Param("poNum") int poNum);
	public  int updateEff(@Param("poYear") int poYear, @Param("poNum") int poNum, @Param("poCnt") int poCnt);
	public  int updatePoCnt(@Param("poYear") int poYear, @Param("poNum") int poNum, @Param("poCnt") int poCnt);
	public Po getPoNum(Po po);
	
}
