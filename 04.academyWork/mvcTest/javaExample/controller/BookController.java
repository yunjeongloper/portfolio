package work.controller;

import java.util.ArrayList;

import work.model.dto.Book;
import work.model.service.BookService;


/**
 * 
 * <pre>
 * 
 * ���� ���� ��û ���� Controller Ŭ����
 * 
 * ## Controller Ŭ���� ���� (=servlet)
 * 1. ��û �ľ�
 * 2. ��û ������ ���� : �Ű����� ����
 * 3. ��û ������ ����
 * 4. Model ��ûó�� �Ƿ�
 * 5. Model ��û��� �޾Ƽ� ���� ���� ����
 * 6. ��� ���� : ȭ�� �̵�(��)
 * 
 * </pre>
 * 
 * @author ������
 *
 */

public class BookController {
	/** �������� �ý��� ���񽺸� ����ϱ� ���� ��ü  */
	private BookService service = new BookService();

//	print("ȸ������");
//	ArrayList<String> result = controller.addMember(null);
//	print(result);
//	������ ����
//	Member dto = new Member(null,null,null,null,null);
//	dto = new Member("user07","password07",
//			"jang","010-3332-3333","jyj2@syu.ac.kr");
//	result = controller.addMember(dto);
//	print(result);
//	print(controller.addMember(dto));
	
	public ArrayList<String> insertBook(Book dto) {
		
		ArrayList<String> message = new ArrayList<String>();
		
		if(dto != null) {
			
			int bookNum = dto.getBookNum();
			String bookName = dto.getBookName();
			String authorName = dto.getAuthorName();
			int publisherNum = dto.getPublisherNum();
			int bookPrice = dto.getBookPrice();
			int stock = dto.getStock();
			String publishDate = dto.getPublishDate();
			String category = dto.getCategory();
			
			if(bookNum == 0)
				message.add("å ��ȣ�� �ʼ��� �Է��ϼž� �մϴ�.");
			if(bookName == null)
				message.add("å �̸��� �ʼ��� �Է��ϼž� �մϴ�.");
			if(authorName == null)
				message.add("���� �̸��� �ʼ��� �Է��ϼž� �մϴ�.");
			if(publisherNum == 0)
				message.add("���ǻ� ��ȣ�� �ʼ��� �Է��ϼž� �մϴ�.");
			if(bookPrice == 0)
				message.add("å ���� �ʼ��� �Է��ϼž� �մϴ�.");
			if(stock == 0)
				message.add("å ���� �ʼ��� �Է��ϼž� �մϴ�.");
			if(publishDate == null)
				message.add("���� ��¥�� �ʼ��� �Է��ϼž� �մϴ�.");
			if(category == null)
				message.add("ī�װ��� �ʼ��� �Է��ϼž� �մϴ�.");
			
			if(message.size()==0)
				System.out.println("");
			else
				return message;
		}
		
		return null;
	}
	
	/**
	 * ȸ������ ��û ������ ����
	 * -- �ʼ��׸� : ���̵�,��й�ȣ,�̸�,����ó,�̸���
	 * -- ���̵� : 6~20�ڸ� ��������
	 * -- ��й�ȣ : 8~20�ڸ� ��������
	 * 
	 * @param dto ȸ����ü
	 * @return ��� �޼��� (����:�������ϸ޼���, ����: �����׸�޼���)
//	 */
//	public ArrayList<String> addMember(Book dto) {
//		ArrayList<String> message = new ArrayList<String>();
//		if (dto != null) {
//			 String memberId = dto.getMemberId();
//			 String memberPw = dto.getMemberPw();
//			 String memberName = dto.getMemberName();
//			 String mobile = dto.getMobile();
//			 String email = dto.getEmail();
//			 
//			 if (memberId!=null) {
//				 memberId = memberId.trim();
//				 if (memberId.length()>=6&&
//						 memberId.length()<=20) {
//					 if (isExist(memberId)) {
//						message.add("���̵� �ߺ��Դϴ�"); 
//					 }
//				 }else {
//					 message.add("���̵�� 6�ڸ����� 20�ڸ� �̳��� �������ּ���.");
//				 }
//			 }else {
//				 message.add("���̵�� �ʼ��Է��׸��Դϴ�.");
//			 }
//			 
//			 //���
//			 if (memberPw==null ||
//					 memberPw.trim().length()<8 ||
//					 memberPw.trim().length()>20) {
//				 message.add("��й�ȣ�� 8�ڸ����� 20�ڸ� �̳��� �������ּ���.");
//			 }
//			 
//			 //�̸�
//			 if (memberName==null||memberName.trim().length()==0)
//				 message.add("�̸��� �Է����ּ���.");
//			 
//			 //����ó
//			 if (mobile==null||mobile.trim().length()==0)
//				 message.add("�ڵ��� ��ȣ�� �Է����ּ���.");
//			 
//			 //�̸���
//			 if (email==null||email.trim().length()==0)
//				 message.add("�̸��� �ּҸ� �Է����ּ���.");
//			 
//		} else {
//			message.add("ȸ�� ��� ������ �������� �ʽ��ϴ�.");
//		}
//		
//		// ���� ���� ���� ���н�
//		if (!message.isEmpty()) {
//			return message;
//		}else {
//			message.add("ȸ�� ������ �Ϸ�Ǿ����ϴ�.");
//		}
//		
//		// ���� ���� ���� ������ : Model���� ��û ó�� �Ƿ�
//		return message;
//	}

	/**
	 * ���̵� �ߺ� �˻�
	 * @param memberId ���̵�
	 * @return �����ϸ� true, �������� ������ false
	 */
	public boolean isExist(String memberId) {
		
		return false;
	}
	
	/**
	 * �α���
	 * @param memberId ���̵�
	 * @param memberPw ��й�ȣ
	 * @return �����ϸ� ȸ����޹�ȯ, �̰��� Ȥ�� ��й�ȣ ������ null ��ȯ
	 */
	public String login(String memberId, String memberPw) {
		// ������ ���� : �α��� ���̵�, ��й�ȣ �ʼ� �Է�
		if ( memberId != null && memberPw != null ) {
			String grade = service.login(memberId,memberPw);
			if (grade != null) {
				System.out.println("�α��� ����! ����� "+grade+"�Դϴ�.");
			} else {
				//�α��� ���� : ���̵� ������ �Ǵ� ��й�ȣ Ʋ��
				return "�α��� �����Դϴ�. ���̵�� ��й�ȣ�� Ȯ�����ּ���.";
			}
		} else {
			//�ʼ��׸� ���Է� ���� ó��
			return "���̵�� ��й�ȣ�� ��� �ԷµǾ�� �մϴ�.";
		}
		return null;
	}
	
	public String findMemberId (String memberName, String mobile) {
		if ( memberName != null && mobile != null ) {
			String memberId = service.findMemberId(memberName,mobile);
			if (memberId != null) {
				return "���̵� ã�� ����! ���̵�� "+memberId+"�Դϴ�";
			} else {
				//ã�� ���� : �̸� ������ �Ǵ� �ڵ��� ��ȣ Ʋ��
				return "���̵� ã�� �����Դϴ�. ���̵�� ��й�ȣ�� Ȯ�����ּ���.";
			}
		} else {
			//�ʼ��׸� ���Է� ���� ó��
			return "���̵�� �ڵ��� ��ȣ�� ��� �ԷµǾ�� �մϴ�.";
		}
	}

	/**
	 * �α׾ƿ�
	 */
	public void logout() {
		
	}

	/**
	 * ��й�ȣ ����
	 * @param memberId ���̵�
	 * @param memberPw ���� ��й�ȣ
	 * @param modifiedPw ����� ��й�ȣ
	 * @return ��� �޼��� (����:����Ǿ����ϴ�. ����:���̵� Ȥ�� ��й�ȣ �Է¿���)
	 */
	public String UpdateMemberPw(String memberId, String memberPw, String modifiedPw) {
		return null;
	}

	/**
	 * ȸ�� Ż��
	 * @param memberId ���̵�
	 * @param memberPw ��й�ȣ
	 * @return ��� �޼��� (����:����Ǿ����ϴ�. ����:���̵� Ȥ�� ��й�ȣ �Է¿���(
	 */
	public String removeMember(String memberId, String memberPw) {
		return null;
	}
	
	//���̵�ã��
	//��й�ȣã����
	//���ϸ�������
	//����ڹ���
	//ȸ���Ӽ���ȸ
	//ȸ���Ӽ�����
	//ȸ����
	//ȸ������
	//���ϰ����ο���
	//��üȸ����޺���ȸ
	//����Ȯ��
	//Ż��ȸ�����̵���ȸ
	
	

}
