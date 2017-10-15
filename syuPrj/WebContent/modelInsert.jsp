<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File, java.io.IOException" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.awt.Image" %>
<%@ page import="javax.swing.ImageIcon" %>
<%@ page import="javax.sql.*, java.sql.*, javax.naming.*" %>
<%@ page import="java.util.*"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
%>


<%
	String savePath = "upload";
	String uploadFilePath = getServletContext().getRealPath(savePath);
	
	int uploadFileSizeLimit = 30 * 1024 * 1024; // 30MB
	String encType="utf-8";
	
	MultipartRequest multi = new MultipartRequest(
								request,
								uploadFilePath,
								uploadFileSizeLimit,
								encType,
								new DefaultFileRenamePolicy()
							);
	
	String serverFileName = multi.getFilesystemName("upfile1");
	String originalFileName = multi.getOriginalFileName("upfile1");

	String serverFileName2 = multi.getFilesystemName("upfile2");
	String originalFileName2 = multi.getOriginalFileName("upfile2");	
	
	
	String root = request.getSession().getServletContext().getRealPath("/");
	String fileName = root +"/"+ savePath + "/" + serverFileName;
	String fileName2 = root +"/"+ savePath + "/" + serverFileName2;
	
	File file;
	BufferedImage bi;
	int x = 0;
	int y = 0;
	int x2 = 0;
	int y2 = 0;
	
	try
	{
		file = new File(fileName);
		bi = ImageIO.read(file);
		x = bi.getWidth();
		y = bi.getHeight();
		
		file = new File(fileName2);
		bi = ImageIO.read(file);
		x2 = bi.getWidth();
		y2 = bi.getHeight();
		
	}catch(Exception e)
	{
		
	}
	
	
	// ============== Thumb Nail 처리 
			
	String[] saveDirArray = new String[5];
	int[] thumbXArray = new int[5];
	int[] thumbYArray = new int[5];
	
	
	for(int i=1; i<=4; i++)
	{
		saveDirArray[i] = "upload/"+i;
		thumbYArray[i] = 0;
	}
	
	thumbXArray[1] = 50;
	thumbXArray[2] = 150;
	thumbXArray[3] = 800;
	thumbXArray[4] = 800;

	File srcImgFile = null;
	
	
	// String saveDir = "upload";
	String pathDelimeter ="\\";
	
	for(int i=1; i<=4; i++)
	{
		if(i<4)
			srcImgFile = new File(fileName);
		else
			srcImgFile = new File(fileName2);
		
		try
		{
			BufferedImage srcImg = ImageIO.read(srcImgFile);
			BufferedImage dstImg = null;
			
			if(i<4)
				thumbYArray[i] = (int)(y * thumbXArray[i] / x) ; 
			else
				thumbYArray[i] = (int)(y2 * thumbXArray[i] / x2) ; 
			
			
			dstImg = new BufferedImage(thumbXArray[i], thumbYArray[i], BufferedImage.TYPE_3BYTE_BGR);
			java.awt.Graphics2D g = dstImg.createGraphics();
			g.drawImage(srcImg, 0, 0, thumbXArray[i], thumbYArray[i], null);
			
			String outFileName = "thumb_" + srcImgFile.getName().substring(srcImgFile.getName().lastIndexOf(".")+1);
			File outFile = new File(root + saveDirArray[i] + "/" + serverFileName);
			ImageIO.write(dstImg, "JPEG", outFile);
		}catch(Exception e)
		{
			
		}
	}

	Enumeration params = multi.getParameterNames();
	
	String title = null;
	String model = null;
	String size = null;
	String color = null;
	int cat = 0;
	int price = 0;
	int useflag = 0;
	
	while(params.hasMoreElements())
	{
		String tmpName = null;
		String tmpValue = null;
		
		tmpName = (String) params.nextElement();
		
		if(tmpName.equals("title"))
		{
			tmpValue = multi.getParameter(tmpName);
			title = tmpValue;
		}
		if(tmpName.equals("model"))
		{
			tmpValue = multi.getParameter(tmpName);
			model = tmpValue;
		}
		if(tmpName.equals("size"))
		{
			tmpValue = multi.getParameter(tmpName);
			size = tmpValue;
		}
		if(tmpName.equals("color"))
		{
			tmpValue = multi.getParameter(tmpName);
			color = tmpValue;
		}
		if(tmpName.equals("cat"))
		{
			tmpValue = multi.getParameter(tmpName);
			cat = Integer.parseInt(tmpValue);
		}
		if(tmpName.equals("useflag"))
		{
			tmpValue = multi.getParameter(tmpName);
			useflag = Integer.parseInt(tmpValue);
		}
		if(tmpName.equals("price"))
		{
			tmpValue = multi.getParameter(tmpName);
			tmpValue = tmpValue.replaceAll(",","");
			price = Integer.parseInt(tmpValue);
		}
	}
	
	out.print("title="+title+"<br>");
	out.print("model="+model+"<br>");
	out.print("size="+size+"<br>");
	out.print("color="+color+"<br>");
	out.print("cat="+cat+"<br>");
	out.print("useflag="+useflag+"<br>");
	out.print("price="+price+"<br>");
	
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	String msg = null;
	
	try
	{
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/syudb_pool");
		
		// get connection
		conn = ds.getConnection();
		
		// multipart는 getParameter()로 받으면 안된다
		
		String sql = null;
		sql = String.format("INSERT INTO model_table "
				+ " (title,model,cat,size,color,price,useflag,file1,file2) "
				+ " values "
				+ " ('%s','%s','%d','%s','%s','%d','%d','%s','%s')"
				, title, model, cat, size, color, price, useflag, serverFileName, serverFileName2);
		
		pstmt = conn.prepareStatement(sql);
		int affectedRow = pstmt.executeUpdate();
		
		if(affectedRow >=1)
			msg = "제품이 등록되었습니다.";
		else
			msg = "제품 등록 에러입니다.";
		
		if(pstmt != null)
			pstmt.close();
		
		if(conn != null)
			conn.close();
		
		
	}catch(Exception e)
	{
		out.println("REASON: " + e.getMessage() + "<br>");
	}
	
%>
	
<script>
	alert('<%=msg%>');
	location.href='main.jsp?cmd=man_model.jsp';
</script>
	
</body>
</html>