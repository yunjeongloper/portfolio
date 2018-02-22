package com.devunlimit.project.board.domain.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.devunlimit.project.board.domain.dto.BoardDTO;

@Repository
public interface BoardDeleteDAO {
	
	//게시글 있는지 없는지 확인
	int boardExistCheck(String no);
	
	//게시글 삭제
	int delete(String no);

	//게시글 삭제 시 파일 삭제
	void fileDelete(String no);
	
	//해당 글 이미지 URL, save_name 읽어오기
	ArrayList<HashMap<String, String>> imageUrl(String no);
	
	//게시글 삭제 시 업로드된 이미지 삭제
	void imageDelete(String save_name);

}
