package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Project;
import com.izect.fiamm.domain.User;

public interface ProjectMapper {
	public int getTotal(@Param("sk") String sk, @Param("sk") String st);
	public ArrayList<Project> getList(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st);
	
	public int getTotal2(@Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client);
	public ArrayList<Project> getList2(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client);
	
	public int getTotal3(@Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client, @Param("contract") int contract);
	public int getTotal4(@Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client, @Param("contract") int contract, @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds);
	
	public ArrayList<Project> getList3(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client, @Param("contract") int contract, @Param("sStDate") int sStDate, @Param("sEdDate") int sEdDate, @Param("schKinds") String schKinds);
	
	public int insert(Project pj);
	public int delete(@Param("seq") int seq);
	
	public Project selectOne(@Param("seq") int seq);
	public void update(Project pj);
	
	public ArrayList<Project> getList4();
	public ArrayList<Project> getList5(@Param("seq_client") int seq_client);
	
	public int getCommissionTotal(@Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client);
	public ArrayList<Project> getCommissionList(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st, @Param("seq_client") int seq_client);
}
