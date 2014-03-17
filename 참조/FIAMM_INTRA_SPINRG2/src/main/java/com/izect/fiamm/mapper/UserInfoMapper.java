package com.izect.fiamm.mapper;

import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.User;

public interface UserInfoMapper {
	public User selectUserOne(Entity param);
	
	public int idPassChk(Entity param);
	
	public void passwdFail(Entity param);
	
	public void initFail(Entity param);
}
