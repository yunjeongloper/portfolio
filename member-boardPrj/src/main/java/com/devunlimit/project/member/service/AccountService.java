package com.devunlimit.project.member.service;

import java.util.Map;
import javax.naming.AuthenticationException;

public interface AccountService {

  Map login(String id, String pass) throws AuthenticationException;

}
