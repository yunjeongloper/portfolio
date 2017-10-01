package work.model.dto;

/**
* <pre>
* 회원 도메인 클래스 모델링
*
* ## 자바 적용 기술
* -- 클래스, 멤버변수, 메서드, 생성자
* -- 데이터 타입 : 기본형, 객체형
* -- Encapsulation : 은닉성(데이터, 알고리즘 information hiding)
* -- 접근 권한(access modifier) : public protected, 생략(default, friendly, package, private)
* -- 직렬화 객체 
*
* ## 도서 property(멤버변수)
* 1. 도서 번호 숫자 : bookNum
* 2. 도서 이름 문자열 : bookName
* 3. 저자명 문자열: authorName
* 4. 출판사 번호 숫자 : publisherNum
* 5. 도서 가격 숫자 : bookPrice
* 6. 재고 수량 숫자 : stock
* 7. 출간일 문자열 : publishDate
* 8. 카테고리 문자열 : category 
*
* </pre>
*
* @author 장윤정
* @version ver.1.0
* @since jdk 1.4
*/

public class Book {
	
	/**
	* ## 도서 property(멤버변수)
	* 1. 도서 번호 숫자 : bookNum
	* 2. 도서 이름 문자열 : bookName
	* 3. 저자명 문자열: authorName
	* 4. 출판사 번호 숫자 : publisherNum
	* 5. 도서 가격 숫자 : bookPrice
	* 6. 재고 수량 숫자 : stock
	* 7. 출간일 문자열 : publishDate
	* 8. 카테고리 문자열 : category 
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

	/** 기본 생성자 */
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
			System.out.println("도서번호는 필수 입력입니다.");
		}
	}
	
	public int getBookNum() {
		return bookNum;
	}
	
	/**
	 * 도서 번호 양수 검증 메서드
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
