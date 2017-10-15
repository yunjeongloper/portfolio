import java.util.Scanner;

public class AlTest {
	/*
	public int solution(int number) {
		int result = 1;
		
		for(int i=1;i<=number;i++) {
			result = result * i;
		}
		return result;
	}
	*/
	public int solutionWithRecursion(int number) {
		int result[] = null;
		int cnt = 0;
		if(result[0] == 0) {
			return 1;
		} else {
			cnt++;
			return result[number]*solutionWithRecursion(number-1);
		}
	}
	
	public int solution(int number) {
		
		int sum = 0;
		
		while(number>=1) {
			sum = sum+number%10;
			System.out.println(sum+":"+number%10);
			number = number/10;
		}

		if(sum>10) {
			sum = solution(sum);
		}
		
		return sum;
	}
	
	public int solutionWithString(String number) {
		/*
		 * 1. 연산자 X
		 * 2. 
		 */
		
		int sum = 0;
		
		String num[] = number.split("");
		
		
		for(int i=0;i<num.length;i++) {
			sum = sum + Integer.parseInt(num[i]);
		}
		
		if(sum>10) {
			sum = this.solutionWithString(Integer.toString(sum));
		}
		
		return sum;
		
	}
	
	public static void main(String[] args) {
//		System.out.println(new AlTest().solution(18));
//		System.out.println(new AlTest().solutionWithRecursion(18));
		System.out.println(new AlTest().solutionWithString("123456789"));
		
	}

}
