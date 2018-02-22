package com.devunlimit.project.member.domain.dao;

import com.devunlimit.project.member.domain.dto.MemberDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface SignUpDAO {

    int checkId(@Param("id") String id);

    int signUp(@Param("member") MemberDTO memberDTO);

}
