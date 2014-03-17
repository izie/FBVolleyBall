package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Link;
import com.izect.fiamm.domain.User;

public interface LinkMapper {
	
	public List<Link> getList(@Param("seq_po") int seq_po);
	public List<Link> getListContractNo(@Param("seq_po") int seq_po);
	public List<Link> getList2(Link lk);
	public List<Link> getList3(@Param("seq_project") int seq_project, @Param("seq_contract") int seq_contract, @Param("seq_po") int seq_po);
	public int getListCnt3(@Param("seq_project") int seq_project, @Param("seq_contract") int seq_contract, @Param("seq_po") int seq_po);
	public List<Link> getListProj(@Param("seq_project") int seq_project);
	public List<Integer> getListPo(@Param("seq_project") int seq_project);
	public List<Integer> getListCon(@Param("seq_po") int seq_po);
	public List<Link> selectOne(@Param("seq_po") int seq_po);
	
	//SELECT seq FROM link WHERE seq_project=#{seq_project} AND seq_po=#{seq_po} AND  (seq_contract=#{seq_contract} OR seq_contract=0)
	public List<Integer> getListSeq(@Param("seq_project") int seq_project, @Param("seq_po") int seq_po, @Param("seq_contract") int seq_contract); 
	
	public int insert(Link link);
	public int deleteForInsert(@Param("seq") int seq);
	public List<Entity> selectForInsert(Link link);
	public int update(Link link);
	public int delete(@Param("seq") int seq);
	public int deleteAll(@Param("seq_po") int seq_po);
	public Link select(@Param("seq") int seq);
	
}
