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
	  /* 입력받은 수 만큼 렌덤 문자를 만들어 반환한다.
	   * 난수를 발생시켜 이에 대응하는 알파뱃 문자를 생성한다.
	   * 생성된 알파뱃을 연결해 하나의 랜덤 문자를 만든다.
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
