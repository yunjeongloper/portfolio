package com.devunlimit.project.member.service;

import com.devunlimit.project.member.domain.dto.MemberDTO;

import java.util.Map;

public interface SignUpService {

    Map checkId(String id);

    int signUp(MemberDTO memberDTO);
}
