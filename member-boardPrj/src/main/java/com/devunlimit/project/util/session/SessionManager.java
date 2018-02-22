package com.devunlimit.project.util.session;

import java.util.Enumeration;
import java.util.Hashtable;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionManager implements HttpSessionListener {

  public static SessionManager sessionManager = null;
  public static Hashtable sessionMonitor;

  public SessionManager() {
    if (sessionMonitor == null) {
      sessionMonitor = new Hashtable();
    }
    sessionManager = this;
  }

  public static synchronized SessionManager getInstance() {
    if (sessionManager == null) {
      sessionManager = new SessionManager();
    }
    return sessionManager;
  }

  /**
   * 현재 활성화 된 session의 수를 반환한다.
   */
  public int getActiveSessionCount() {
    return sessionMonitor.size();
  }

  /**
   * 현재 등록된 session의 id목록을 반환한다.
   */
  public Enumeration getIds() {

    return sessionMonitor.keys();
  }

  /**
   * 현재 등록된 session중 현재 접속된 사용자 정보와 중복 여부 확인 후 중복 접속 이면 이전의 세션을 소멸 시킨다.

  public boolean checkDuplicationLogin(String sessionId, String userEeno) {
    boolean ret = false;
    Enumeration eNum = sessionMonitor.elements();
    System.out.println("session count : " + getActiveSessionCount());
    while (eNum.hasMoreElements()) {
      HttpSession sh_session = null;
      try {
        sh_session = (HttpSession) eNum.nextElement();
      } catch (Exception e) {
        continue;
      }
      UserModel baseModel = sh_session.getAttribute("UserInfo");
      if (baseModel != null) {
        if (userEeno.equals(baseModel.getUserId_()) && !sessionId.equals(sh_session.getId())) {
// 전달 받은 사번과(userEeno) 기존 세션값 중 사번이 중복 되면
// 기존 세션을 소멸 시킨다.
// 사용자 로그아웃 이력(중복접속)을 저장한다.
          try {
            HashMap param = new HashMap();
            param.put("usrId", baseModel.getUserId_());
            param.put("ipAddr", baseModel.getRemoteIp_());
            param.put("logKind", "LOGOUT");
            param.put("logRsn", "DUPLICATE");
// DB 처리
            xxxxxxxx.insertLoginLog(param);

          } catch (Exception e) {
            e.printStackTrace();
          }
// 해당 세션 무효화
          sh_session.invalidate();
          ret = true;
          break;
        }
      }
    }
    return ret;
  }
   */

  /**
   * 세션 생성시 이벤트 처리
   */
  public void sessionCreated(HttpSessionEvent event) {
    HttpSession session = event.getSession();
    synchronized (sessionMonitor) {
      sessionMonitor.put(session.getId(), session);
    }
  }

  /**
   * 세션 소멸(종료)시 이벤트 처리
   */
  public void sessionDestroyed(HttpSessionEvent event) {
    HttpSession session = event.getSession();
    synchronized (sessionMonitor) {
      sessionMonitor.remove(session.getId());
    }
  }
}