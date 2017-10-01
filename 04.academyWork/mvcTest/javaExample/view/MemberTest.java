package work.view;

import java.util.ArrayList;

import work.controller.MemberController;
import work.model.dao.MemberDao;
import work.model.dto.Member;
import work.util.Utility;

public class MemberTest {

	public static void main(String[] args) {
		
		// ȸ������ ��û���ü ���� : controller 
		MemberController controller = new MemberController();
		
		print("ȸ������");
//		ArrayList<String> result = controller.addMember(null);
//		print(result);
//		������ ����
//		Member dto = new Member(null,null,null,null,null);
//		dto = new Member("user07","password07",
//				"jang","010-3332-3333","jyj2@syu.ac.kr");
//		result = controller.addMember(dto);
//		print(result);
//		print(controller.addMember(dto));

		// ȸ�� ���̺� ���ο� Member ��ü �߰�
		print("ȸ������");
		Member dto = new Member("user09","password08","jyj","010-1734-9954","jlj@syu.ac.kr",
				"2017.08.10","S",8000,"����");
		MemberDao dao = MemberDao.getInstance();
		int row = dao.insertMember(dto);
		if(row==0)
			System.out.println("ȸ�� ��� �����ϼ̽��ϴ�. �Ф�");
		else
			System.out.println("ȸ�� ��� �����ϼ̽��ϴ�. ^__^");

		print("�α���");
		String results = controller.login("user01", "password01");
		System.out.println(results);
		
		print("�α׾ƿ�");
		
		print("���̵�ã��");
		results = controller.findMemberId("ȫ�浿","010-1234-1111");
		System.out.println(results);

		print("��й�ȣ ã��");
		System.out.println(Utility.getRandomText(7,10)); 
		
	}
	
	// �׽�Ʈ�� ���� ��ü�������� �ƱԸ�Ʈ�� ���޹��� ���ڿ��� ����ϴ� �޼��� ����
	// �޼����̸� : print
	public static void print(String message) {
		System.out.println("\n### "+message+" ###");
	}

	public static void print(ArrayList<String> message){
		System.out.println();
		for(String data : message) {
			System.out.println(data);
		}
	}
}
