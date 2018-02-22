package com.devunlimit.project.board.service.serviceImpl;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.devunlimit.project.board.domain.dao.BoardDeleteDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.service.BoardDeleteService;

@Service
public class BoardDeleteServiceImpl implements BoardDeleteService {

	@Autowired
	private BoardDeleteDAO dao;
	
	private static Logger logger = LoggerFactory.getLogger(BoardDeleteServiceImpl.class);
	
	@Override
	public boolean delete(String no) {// 게시글 삭제
		
		//게시글이 존재하는지 확인(존재하면 1 없으면 0)
		int result = dao.boardExistCheck(no);

		if (result==1) {//삭제할 게시물이 있으면
			
			if (dao.delete(no)==1) {//delete를 수행하면 1을 반환
				dao.fileDelete(no);
				logger.info("delete_ok : 1");
				return true;
			} else {
				logger.info("delete_ok : 0");
				return false;
			}
			
		} else {//삭제할 게시물이 없으면
			logger.info("게시물이 없음");
		}
		
		return false;
	}

	@Override
	public boolean imgDelete(String no) { //이미지 삭제
		
		List<HashMap<String, String>> result = dao.imageUrl(no);
		for (int i = 0; i < result.size(); i++) {	
			File file = new File(result.get(i).get("url"));
			if (file.delete()) {
				dao.imageDelete(result.get(i).get("save_name"));
			} else {
				return false;
			}
		}

		return true;
	}

}
