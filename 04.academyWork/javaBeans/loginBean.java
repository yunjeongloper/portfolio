package ch07;
public class loginBean {
	// 사용자로부터 입력받은 아이디와 비밀번호 저장?
	private String userId, userPw;
	// DB로부터 가져온 아이디와 비밀번호로 가정함
	final String _userId = "yunjeong";
	final String _userPw = "1234";
	// 로그인 계정 정보가 맞는지 확인하는 메서드
	public boolean checkUser() {
		if(userId.equals(_userId)&&userPw.equals(_userPw))
			return true;
		else
			return false;
	}
	// userId와 userPw의 get,set method
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

}
