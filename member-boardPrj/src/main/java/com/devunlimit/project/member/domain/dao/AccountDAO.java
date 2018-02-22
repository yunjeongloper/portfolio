package com.devunlimit.project.member.domain.dao;

import com.devunlimit.project.member.domain.dto.MemberDTO;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountDAO {

  MemberDTO findByUsername(String id);

  String isAccountLock(Integer memberno);

  int plusFailCount(Integer memberno);

  int updateAccountLock(Integer memberno);

  void firstLogInsert(Integer memberno);
}
