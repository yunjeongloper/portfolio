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
* ## ���� property(�������)
* 1. ���� ��ȣ ���� : bookNum
* 2. ���� �̸� ���ڿ� : bookName
* 3. ���ڸ� ���ڿ�: authorName
* 4. ���ǻ� ��ȣ ���� : publisherNum
* 5. ���� ���� ���� : bookPrice
* 6. ��� ���� ���� : stock
* 7. �Ⱓ�� ���ڿ� : publishDate
* 8. ī�װ� ���ڿ� : category 
*
* </pre>
*
* @author ������
* @version ver.1.0
* @since jdk 1.4
*/

public class Book {
	
	/**
	* ## ���� property(�������)
	* 1. ���� ��ȣ ���� : bookNum
	* 2. ���� �̸� ���ڿ� : bookName
	* 3. ���ڸ� ���ڿ�: authorName
	* 4. ���ǻ� ��ȣ ���� : publisherNum
	* 5. ���� ���� ���� : bookPrice
	* 6. ��� ���� ���� : stock
	* 7. �Ⱓ�� ���ڿ� : publishDate
	* 8. ī�װ� ���ڿ� : category 
	*
	 */
	private int bookNum;
	private String bookName;
	private String authorName;
	private int publisherNum;
	private int bookPrice;
	private int stock;
	private String publishDate;
	private String category;

	/** �⺻ ������ */
	public Book(){ }
	
	public Book(int bookNum, String bookName, String authorName,
			int publisherNum, int bookPrice, int stock, String publishDate, String category){
		this.bookNum = bookNum;
		this.bookName = bookName;
		this.authorName = authorName;
		this.publisherNum = publisherNum;
		this.bookPrice = bookPrice;
		this.stock = stock;
		this.publishDate = publishDate;
		this.category = category;
	}
	
	public void setBookNum(String BookId) {
		if(isBookNum(bookNum)) {
			this.bookNum = bookNum;
		}else {
			System.out.println("������ȣ�� �ʼ� �Է��Դϴ�.");
		}
	}
	
	public int getBookNum() {
		return bookNum;
	}
	
	/**
	 * ���� ��ȣ ��� ���� �޼���
	 * @param bookNum
	 * @return
	 */
	private boolean isBookNum(int bookNum) {
		if(bookNum>0) {
				return true;
		}
		return false;
	}

	/**
	 * @return the bookName
	 */
	public String getBookName() {
		return bookName;
	}

	/**
	 * @param bookName the bookName to set
	 */
	public void setBookName(String bookName) {
		this.bookName = bookName;
	}

	/**
	 * @return the authorName
	 */
	public String getAuthorName() {
		return authorName;
	}

	/**
	 * @param authorName the authorName to set
	 */
	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	/**
	 * @return the publisherNum
	 */
	public int getPublisherNum() {
		return publisherNum;
	}

	/**
	 * @param publisherNum the publisherNum to set
	 */
	public void setPublisherNum(int publisherNum) {
		this.publisherNum = publisherNum;
	}

	/**
	 * @return the bookPrice
	 */
	public int getBookPrice() {
		return bookPrice;
	}

	/**
	 * @param bookPrice the bookPrice to set
	 */
	public void setBookPrice(int bookPrice) {
		this.bookPrice = bookPrice;
	}

	/**
	 * @return the stock
	 */
	public int getStock() {
		return stock;
	}

	/**
	 * @param stock the stock to set
	 */
	public void setStock(int stock) {
		this.stock = stock;
	}

	/**
	 * @return the publishDate
	 */
	public String getPublishDate() {
		return publishDate;
	}

	/**
	 * @param publishDate the publishDate to set
	 */
	public void setPublishDate(String publishDate) {
		this.publishDate = publishDate;
	}

	/**
	 * @return the category
	 */
	public String getCategory() {
		return category;
	}

	/**
	 * @param category the category to set
	 */
	public void setCategory(String category) {
		this.category = category;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append(bookNum);
		builder.append(", ");
		builder.append(bookName);
		builder.append(", ");
		builder.append(authorName);
		builder.append(", ");
		builder.append(publisherNum);
		builder.append(", ");
		builder.append(bookPrice);
		builder.append(", ");
		builder.append(stock);
		builder.append(", ");
		builder.append(publishDate);
		builder.append(", ");
		builder.append(category);
		return builder.toString();
	}	
}
