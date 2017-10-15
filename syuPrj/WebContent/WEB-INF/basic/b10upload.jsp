<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File, java.io.IOException" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.awt.Image" %>
<%@ page import="javax.swing.ImageIcon" %>


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
	
	String serverFileName = multi.getFilesystemName("upfile");
	String originalFileName = multi.getOriginalFileName("upfile");
	
	
	
	String root = request.getSession().getServletContext().getRealPath("/");
	String fileName = root +"/"+ savePath + "/" + serverFileName;
	
	File file;
	BufferedImage bi;
	int x = 0;
	int y = 0;
	
	try
	{
		file = new File(fileName);
		bi = ImageIO.read(file);
		x = bi.getWidth();
		y = bi.getHeight();
	}catch(Exception e)
	{
		
	}
	
	
	// ============== Thumb Nail 처리 
	int thumbX = 100;
	int thumbY = 0;
	File srcImgFile = new File(fileName);
	String saveDir = "upload";
	String pathDelimeter ="\\";
	
	try
	{
		BufferedImage srcImg = ImageIO.read(srcImgFile);
		BufferedImage dstImg = null;
		
		thumbY = (int)(y * thumbX / x) ; 
		
		dstImg = new BufferedImage(thumbX, thumbY, BufferedImage.TYPE_3BYTE_BGR);
		java.awt.Graphics2D g = dstImg.createGraphics();
		g.drawImage(srcImg, 0, 0, thumbX, thumbY, null);
		
		String outFileName = "thumb_" + srcImgFile.getName().substring(srcImgFile.getName().lastIndexOf(".")+1);
		File outFile = new File(root + "upload/thumb_"+serverFileName);
		ImageIO.write(dstImg, "JPEG", outFile);
	}catch(Exception e)
	{
		
	}
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	uploadFilePath = <%=uploadFilePath %><br>
	serverFileName = <%=serverFileName %><br>
	originalFileName = <%=originalFileName %><br>
	root = <%=root %><br>
	x = <%=x %>, y = <%=y %><br>
	
	<img src="upload/thumb_<%=serverFileName %>"><br>
	
	<img src="upload/<%=serverFileName%>"> <br>
	
	<a href='b09file.jsp'>이전 페이지</a> <br>
	
	


</body>
</html>