package ch07;

import java.io.*;

public class CounterBean {
	
	private int CountNum = 0;
	
	FileReader in = null;
	FileWriter out = null;
	
	public void fileWriter() {
		try {
			out = new FileWriter("count.txt");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void fileReader() {
		try {
			in = new FileReader("count.txt");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
		
}
