package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.User;

public interface ClientUserMapper {
	public int getTotal(@Param("sk") String sk, @Param("st") String st, @Param("seq") int seq);
	public List<ClientUser> getList(@Param("start") int start, @Param("pageSize") int pageSize, @Param("sk") String sk, @Param("st") String st, @Param("seq") int seq);
	public int insert(ClientUser cu);
	public ClientUser selectOne(@Param("seq") int seq);
	public int update(ClientUser cu);
	public int delete(@Param("seq") int seq);
	public List<ClientUser> getClientUser(@Param("seq_fk") int seq_fk);
	public List<ClientUser> getList2(@Param("seq_client") String seq_client);
	
}
