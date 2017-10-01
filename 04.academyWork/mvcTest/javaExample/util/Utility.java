package work.util;

import java.util.Random;

public class Utility {

   public static int createSecureNumber () {
	      
	      int secureLength = 5;
	      
	      Random ran = new Random();
	      int result = ran.nextInt(10);
	      
	      for(int i=0; i<secureLength; i++) {
	         
	         result = result * 10;
	      }
	      
	      return result;
	 }
 
	 public static String getRandomText(int textSize , int rmSeed){
	  /* �Է¹��� �� ��ŭ ���� ���ڸ� ����� ��ȯ�Ѵ�.
	   * ������ �߻����� �̿� �����ϴ� ���Ĺ� ���ڸ� �����Ѵ�.
	   * ������ ���Ĺ��� ������ �ϳ��� ���� ���ڸ� �����.
	   * */
	  
	  String rmText = "";
	  
	  Random random = new Random(System.currentTimeMillis());
	  
	  int rmNum = 0;
	  char ch = 'a';
	  for (int i = 0; i < textSize; i++) {
	   random.setSeed(System.currentTimeMillis() * rmSeed * i + rmSeed + i);
	   rmNum = random.nextInt(25);
	   ch += rmNum;
	   rmText = rmText + ch ;
	   ch = 'a';
	  }
	    
	  return rmText; 
	 }
}
