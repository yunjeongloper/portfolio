package work.model.dto;

/**
* <pre>
* ȸ�� ������ Ŭ���� �𵨸�
*
* ## �ڹ� ���� ���
* -- Ŭ����, �������, �޼���, ������
* -- ������ Ÿ�� : �⺻��, ��ü��
* -- Encapsulation : ���м�(������, �˰��� information hiding)
* -- ���� ����(access modifier) : public protected, ����(default, friendly, package, private)
* -- ����ȭ ��ü 
*
* ## ȸ�� property(�������)
* 1. ���̵� ���ڿ� : memberId
* 2. ��й�ȣ ���ڿ� : memberPw
* 3. �̸� ���ڿ� : memberName
* 4. ����ó ���ڿ� (�⺻���� : 010-1234-5678) : mobile
* 5. �̸��� ���ڿ� : email
* 6. ������ ���ڿ� (�⺻���� : �⵵ 4�ڸ�, �� 2�ڸ�, �� 2�ڸ�) : entryDate
* 7. ��� ���ڿ� (ȸ������: �Ϲ�(G), ���(S), ������(A)) : grade
* 8. ���ϸ��� ���� : �Ϲ�ȸ�� : mileage
* 9. ����� ���ڿ� : ���ȸ�� : manager

* </pre>
*
* @author ������
* @version ver.1.0
* @since jdk 1.4
*/

public class Member {
	
	/** ȸ�� ���̵� ���� */
	private String memberId="Guest";
	/** ȸ�� ��й�ȣ ���� */
	private String memberPw;
	/** ȸ�� �̸� ���� */
	private String memberName;
	/** ȸ�� �޴��� ���� */
	private String mobile;
	/** ȸ�� �̸��� ���� */
	private String email;
	/** ȸ�� ������ ����(���� : �⵵ 4�ڸ�, �� 2�ڸ�, �� 2�ڸ�) */
	private String entryDate;
	/** ȸ�� ��� ����(�Ϲ�(G), ���(S), ������(A)) */
	private String grade;
	/** ȸ��(�Ϲ�) ���ϸ��� ���� */
	private Integer mileage;
	/** ȸ��(���) ����� ���� */
	private String manager=null;
	
	/**
	 * �⺻ ������
	 */
	public Member(){
	}
	
	/**
	 * �ʼ� ������ �ʱ�ȭ ������
	 * @param memberId	���̵�
	 * @param memberPw	��й�ȣ
	 * @param memberName�̸�
	 * @param mobile	�޴���
	 * @param email		�̸���
	 */
	public Member(String memberId, String memberPw, 
			String memberName, String mobile, String email){
		this.memberId=memberId;
		this.memberPw=memberPw;
		this.memberName=memberName;
		this.mobile=mobile;
		this.email=email;
	}
	
	/**
	 * ��ü ������ �ʱ�ȭ ������
	 * @param memberId	���̵�
	 * @param memberPw	�н�����
	 * @param memberName�̸�
	 * @param mobile
	 * @param email
	 * @param entryDate
	 * @param grade
	 * @param mileage
	 * @param manager
	 */
	public Member(String memberId, String memberPw, 
			String memberName, String mobile, String email,
			String entryDate, String grade, int mileage, String manager){
		this(memberId, memberPw, memberName, mobile, email);
		this.entryDate=entryDate;
		this.grade=grade;
		this.mileage=mileage;
		this.manager=manager;
	}
	
	public void setMemberId(String memberId) {
		if(isMemberId(memberId)) {
			this.memberId = memberId;
		}else {
			System.out.println("Error : ���̵�� 6�ڸ� ~ 20�ڸ� �̳��Դϴ�.");
		}
	}
	
	public String getMemberId() {
		return memberId;
	}

	/**
	 * Member �Ϲ�ȸ�� ������ �ʱ� ������ ���� _ dto5
	 * @param memberId
	 * @param memberPw
	 * @param memberName
	 * @param mobile
	 * @param email
	 * @param entryDate
	 * @param grade
	 * @param mileage
	 */
	public Member(String memberId, String memberPw, 
			String memberName, String mobile, String email,
			String entryDate, String grade, int mileage){
		this(memberId, memberPw, memberName, mobile, email);
		this.entryDate=entryDate;
		this.grade=grade;
		this.mileage=mileage;
		this.manager=manager;
		}
	
	/**
	 * ���̵� ���� �޼���
	 * ���� ��Ģ : ���̵�� �ּ� 6�ڸ�~20�ڸ� �̳�
	 * 
	 * @see java.lang.String#length()
	 * @param memberId
	 * @return
	 */
	private boolean isMemberId(String memberId) {
		if(memberId!=null) {
			int length = memberId.trim().length();
			if(length >= 6 && length <= 20) {
				return true;
			}
		}
		return false;
	}

	/**
	 * @return the memberPw
	 */
	public String getMemberPw() {
		return memberPw;
	}

	/**
	 * @param memberPw the memberPw to set
	 */
	public void setMemberPw(String memberPw) {
		this.memberPw = memberPw;
	}

	/**
	 * @return the memberName
	 */
	public String getMemberName() {
		return memberName;
	}

	/**
	 * @param memberName the memberName to set
	 */
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	/**
	 * @return the mobile
	 */
	public String getMobile() {
		return mobile;
	}

	/**
	 * @param mobile the mobile to set
	 */
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	/**
	 * @return the email
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * @param email the email to set
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * @return the entryDate
	 */
	public String getEntryDate() {
		return entryDate;
	}

	/**
	 * @param entryDate the entryDate to set
	 */
	public void setEntryDate(String entryDate) {
		this.entryDate = entryDate;
	}

	/**
	 * @return the grade
	 */
	public String getGrade() {
		return grade;
	}

	/**
	 * @param grade the grade to set
	 */
	public void setGrade(String grade) {
		this.grade = grade;
	}

	/**
	 * @return the mileage
	 */
	public Integer getMileage() {
		return mileage;
	}

	/**
	 * @param mileage the mileage to set
	 */
	public void setMileage(Integer mileage) {
		this.mileage = mileage;
	}

	/**
	 * @return the manager
	 */
	public String getManager() {
		return manager;
	}

	/**
	 * @param manager the manager to set
	 */
	public void setManager(String manager) {
		this.manager = manager;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append(memberId);
		builder.append(", ");
		builder.append(memberPw);
		builder.append(", ");
		builder.append(memberName);
		builder.append(", ");
		builder.append(mobile);
		builder.append(", ");
		builder.append(email);
		builder.append(", ");
		builder.append(entryDate);
		builder.append(", ");
		builder.append(grade);
		builder.append(", ");
		builder.append(mileage);
		builder.append(", ");
		builder.append(manager);
		return builder.toString();
	}
	
}
