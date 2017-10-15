import javax.swing.JFrame;


//JFrame 스윙버전 awt
class MyFrame extends JFrame {
   
   public MyFrame () {
      
      //사이즈
      this.setSize(500, 400);
      //창 타이틀
      this.setTitle("삼육대학교 GUI 테스트");
      //닫기버튼
      this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      
      this.setVisible(true);
   }
}

public class GuiTest {

   public static void main(String[] args) {

      MyFrame myFrame = new MyFrame();
   }
}