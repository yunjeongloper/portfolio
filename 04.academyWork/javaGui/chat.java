import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

class MyFrame extends JFrame implements ActionListener
{
	//변수들은 반드시 여기에 만들어야 써먹고싶을 때 써먹을 수 있음
	private JPanel displayPanel;
	private JPanel inputPanel;
	
	private JTextArea display;
	private JTextField input;

	//생성자
	public MyFrame()
	{
		this.setSize(500,400);
		this.setTitle("SYU Chatting");
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		//프레임의 레이아웃을 센터, 동서남북으로 구분해줘 (여기선 중앙, 남쪽만 사용)
		this.setLayout(new BorderLayout());
		
		Font font = new Font("Serif", Font.BOLD, 20);
		
		displayPanel = new JPanel();
		displayPanel.setLayout(new FlowLayout());
		this.add(displayPanel, BorderLayout.CENTER);
		display = new JTextArea(12,30);
		
		//displayPanel.add(display)를 이렇게 바꾸면 스크롤바가 생김
		JScrollPane scroll = new JScrollPane(display);
		displayPanel.add(scroll);
		
		display.setFont(font);
		
		inputPanel = new JPanel();
		inputPanel.setLayout(new FlowLayout());
		this.add(inputPanel, BorderLayout.SOUTH);
		input = new JTextField(30);
		inputPanel.add(input);
		
		input.setFont(font);
		input.addActionListener(this);
		
		
		this.setVisible(true);
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getSource()==input)
		{
			//display.setText(input.getText() + "\n" + input.getText());
			display.append(input.getText()+"\n");
			input.selectAll();
			
			//스크롤이 알아서 최근 내용이 있는 곳으로 내려가게 함
			display.setCaretPosition(display.getDocument().getLength());
		}
	}

}


public class Test {

	public static void main(String[] args) {
		new MyFrame();
	}

}
