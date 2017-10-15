package kr.ac.syu.web;
import javax.swing.JButton;
import javax.swing.JFrame;

class MyFrame extends JFrame 
{
	
	private JButton btn1;
	private JButton btn2;
	private JButton btn3;
	private JButton btn4;
	private JButton btn5;
	
	public MyFrame () 
	{      
      //사이즈
      this.setSize(500, 400);
      //창 타이틀
      this.setTitle("삼육대학교 GUI 테스트");
      //닫기버튼
      this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      
      btn1 = new JButton();
      btn1.setText("버튼 1번입니다.");

      // 한번에 값까지 넣기
      btn2 = new JButton("두번째 버튼입니다");
      
      this.add(btn1);
      
      this.setVisible(true);
   }
   
   // method를 만들 예정
}

public class E03Test {

   public static void main(String[] args) {

      MyFrame myFrame = new MyFrame();
   }
}