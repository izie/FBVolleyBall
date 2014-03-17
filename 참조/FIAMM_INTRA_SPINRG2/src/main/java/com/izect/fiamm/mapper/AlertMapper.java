package com.izect.fiamm.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izect.fiamm.domain.Alert;
import com.izect.fiamm.domain.Client;
import com.izect.fiamm.domain.ClientUser;
import com.izect.fiamm.domain.Entity;
import com.izect.fiamm.domain.Temp;
import com.izect.fiamm.domain.User;

public interface AlertMapper {
	public Temp getStr(@Param("al") Alert al, @Param("nowDate") int nowDate); // SO

	public String getText(@Param("seq_po") int seq_po); // SO

	public int getTotal(@Param("effect") int effect, @Param("sk") String sk,
                        @Param("st") String st, @Param("nowDate") int nowDate);

	public List<Alert> getList(@Param("effect") int effect,
                               @Param("start") int start, @Param("pageSize") int pageSize,
                               @Param("oby") String oby, @Param("sk") String sk,
                               @Param("st") String st, @Param("nowDate") int nowDate);

	public int insert(Alert al);

	public Alert selectOne(@Param("seq") int seq);

	public int updateEffect(Alert al);
	
	public int updateEffect2(@Param("seq") int seq, @Param("eff") int eff);

	public Alert isIt(@Param("seq_project") int seq_project,
                      @Param("err_seq") int err_seq, @Param("err_name") String err_name);

	public int delete(@Param("seq_project") int seq_project,
                      @Param("err_seq") int err_seq, @Param("err_name") String err_name);

	public int delete1(@Param("sk") int seq_po, @Param("sk") int err_seq,
                       @Param("err_name") String err_name);

	public int delete2(@Param("err_name") String err_name,
                       @Param("err_seq") int err_seq);

	public int update1(@Param("seq_project") int seq_project,
                       @Param("err_seq") int err_seq, @Param("err_name") String err_name,
                       @Param("effect") int effect);

	public int update2(@Param("seq_po") int seq_po,
                       @Param("err_seq") int err_seq, @Param("err_name") String err_name,
                       @Param("effect") int effect);

	public int update3(@Param("err_seq") int err_seq,
                       @Param("err_name") String err_name, @Param("effect") int effect);

	public int delContract(@Param("seq_project") int seq_project,
                           @Param("err_seq") int err_seq);

	public int delPo(@Param("seq_po") int seq_po);

	public int updatePoEffect(@Param("seq_po") int seq_po);

	public List<Entity> updatePoEff(@Param("poYear") int poYear,
                                    @Param("poNum") int poNum, @Param("poCnt") int poCnt);

	public List<Alert> chkInUp1(@Param("seq_po") int seq_po,
                                @Param("seq_pil") int seq_pil, @Param("err_name") String err_name,
                                @Param("stDate") int stDate);
	
	public int chkInUp2(@Param("seq_po") int seq_po,
                        @Param("seq_pil") int seq_pil, @Param("err_name") String err_name,
                        @Param("stDate") int stDate);

	public int updatePass(@Param("seq_po") int seq_po,
                          @Param("seq_pil") int seq_pil, @Param("err_name") String err_name,
                          @Param("effect") int effect);

	public int updateAll(@Param("seq_po") int seq_po,
                         @Param("effect") int effect);

}
