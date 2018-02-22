package com.devunlimit.project.member.service.serviceImpl;

import com.devunlimit.project.member.domain.dao.SignUpDAO;
import com.devunlimit.project.member.domain.dto.MemberDTO;
import com.devunlimit.project.member.service.SignUpService;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class SignUpServiceImpl implements SignUpService {

  @Autowired
  private SignUpDAO signUpDAO;

  @Override
  public int signUp(MemberDTO memberDTO) {

    checkInfo(memberDTO);
    checkInfoLength(memberDTO);
    memberDTO.setPwd(BCrypt.hashpw(memberDTO.getPwd(),BCrypt.gensalt()));
    return signUpDAO.signUp(memberDTO);
  }

  //입력 정보 확인
  private void checkInfo(MemberDTO memberDTO) {

    if (!memberDTO.getPwd().equals(memberDTO.getPwd_Ok())) {
      throw new IllegalStateException("비밀번호가 미일치");
    } else if (memberDTO.getId().length() == 0 || memberDTO.getId().isEmpty()) {
      throw new IllegalStateException("아이디가 없음");
    } else if (memberDTO.getName().length() == 0 || memberDTO.getName().isEmpty()) {
      throw new IllegalStateException("이름이 없음");
    } else if (memberDTO.getPhone().length() == 0 || memberDTO.getPhone().isEmpty()) {
      throw new IllegalStateException("핸드폰번호가 없음");
    }

  }

  //입력 정보에 대한 길이 확인
  private void checkInfoLength(MemberDTO memberDTO) {
    if (memberDTO.getName().length() > 10) {
      throw new IllegalStateException("이름이 너무 깁니다.");
    } else if (memberDTO.getId().length() > 10) {
      throw new IllegalStateException("아이디가 너무 깁니다.");
    } else if (memberDTO.getPwd().length() > 20 && memberDTO.getPwd_Ok().length() > 20) {
      throw new IllegalStateException("비밀번호가 너무 깁니다.");
    } else if (memberDTO.getPhone().length() != 13) {
      throw new IllegalStateException("휴대폰 번호를 제대로 입력해주세요.");
    }
  }

  @Override
  public Map checkId(String id) {

    Map<String, String> status = new HashMap<>();

    status.put("status", "400");

    int checkId = signUpDAO.checkId(id);

    try {
      if (id.length() == 0 || id.equals("")) {
        throw new NullPointerException();
      } else {
        if (checkId == 0) {
          status.put("status", "200");
          status.put("message", "사용 가능한 아이디 입니다.");
        } else {
          status.put("message", "이미 사용 중인 아이디 입니다.");
        }
      }
    } catch (Exception e) {
      status.put("message", "아이디를 입력해 주세요");
    }

    return status;
  }
}
