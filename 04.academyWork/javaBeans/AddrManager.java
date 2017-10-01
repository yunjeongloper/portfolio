package ch07;

import java.util.ArrayList;
import java.util.List;

// 주소록 관리 클래스
public class AddrManager {
	
	// 주소록 목록을 관리하기 위한 ArrayList
	List<AddrBean> addrList = new ArrayList<AddrBean>();
	
	// 주소록 추가 메서드
	public void add(AddrBean ab) {
		addrList.add(ab);
	}
	
	// 주소록 목록 전달 메서드
	public List<AddrBean> getAddrList(){
		return addrList;
	}

}
