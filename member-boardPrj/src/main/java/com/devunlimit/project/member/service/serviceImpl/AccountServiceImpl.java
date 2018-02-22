package com.devunlimit.project.member.service.serviceImpl;

import com.devunlimit.project.member.domain.dao.AccountDAO;
import com.devunlimit.project.member.service.AccountService;
import com.devunlimit.project.util.exceptions.CheckNull;
import java.util.HashMap;
import java.util.Map;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.devunlimit.project.member.domain.dto.MemberDTO;

import javax.naming.AuthenticationException;

@Service
@Transactional
public class AccountServiceImpl implements AccountService {

  @Autowired
  private AccountDAO accountDAO;

  @Override
  public Map login(String id, String pass) throws AuthenticationException {

    Map<String, String> status = new HashMap<>();

    status.put("status", "400");

    MemberDTO memberDTO = this.accountDAO.findByUsername(id);

    if (id.length() == 0 || id.equals("")) {

      status.put("message", "아이디가 입력되지 않았습니다.");

      throw new AuthenticationException("아이디가 입력되지 않았습니다");

    } else {

      if (!CheckNull.isEmpty(memberDTO)) {

        String pwd = pass;

        Integer memberno = memberDTO.getNo();

        status.put("memberNo", String.valueOf(memberDTO.getNo()));

        String isLock = this.accountDAO.isAccountLock(memberno);

        // 계정이 잠겼다면
        if (CheckNull.isEmpty(isLock) || isLock.equals("N")) {

          if (!BCrypt.checkpw(pwd, memberDTO.getPwd())) {

            // 실패한 기록 ++
            int plusedRow = this.accountDAO.plusFailCount(memberno);

            // 실패한 기록이 없었다면
            if(plusedRow == 0) {

              this.accountDAO.firstLogInsert(memberno);

              status.put("message", "firstLogCount");

              throw new AuthenticationException("패스워드가 올바르지 않습니다.");
            }

            // 5회 이상 실패시 잠김
            int lockedRow = this.accountDAO.updateAccountLock(memberno);

            if(lockedRow == 1) {

              status.put("message", "accountLock");

              throw new AuthenticationException("accountLock");

            }

            throw new AuthenticationException("패스워드가 올바르지 않습니다.");

          } else {

            status.put("status", "200");

            status.put("message", "유효한 아이디입니다.");

            status.put("memberNo", String.valueOf(memberDTO.getNo()));

          }
        } else if (isLock.equals("Y")) {

          status.put("message", "accountLock");

          throw new AuthenticationException("accountLock");

        }
      } else {

        status.put("status", "400");

        status.put("message", "유효하지 않은 회원정보입니다.");

        throw new AuthenticationException("유효하지 않은 회원정보입니다");

      }
    }

    return status;

  }

}

