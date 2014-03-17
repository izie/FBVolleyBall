package com.izect.fiamm.mapper;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Contract;
import com.izect.fiamm.domain.ContractNo;

public interface ContractNoMapper {
	public ContractNo selectLast(@Param("coYear") int coYear);
	public Contract selectOne(@Param("coYear") int coYear, @Param("coNum") int coNum);

}
