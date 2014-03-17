package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.User;

public interface ClientMapper {
	public int getTotal(String sk, String st, int seq);
	public List<Client> getList(int start, int pageSize, String sk, String st,
                                int seq);
	public int getTotal2(String sk, String st, String bizKinds);
	public List<Client> getList2(int start, int pageSize, String sk, String st,
                                 String bizKinds);
	
	public List<Client> getListOby(int start, int pageSize, String sk,
                                   String st, String oby);
	public List<Client> getListOby2(int start, int pageSize, String sk,
                                    String st, String oby, int seq_client);
	
	public int insert(Client cl);
	public Client selectOne(@Param("seq") int seq);
	public int update(@Param("cl") Client cl, @Param("saveDir") String saveDir);
	public int delete(@Param("seq") int seq);
	public List<Client> getClient();
	public List<Client> getClient2(String bizKinds);
	
}
