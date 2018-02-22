package com.devunlimit.project.board.service.serviceImpl;

import com.devunlimit.project.board.domain.dao.BoardListDAO;
import com.devunlimit.project.board.domain.dto.BoardDTO;
import com.devunlimit.project.board.service.BoardListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BoardListServiceImpl implements BoardListService {

    @Autowired
    private BoardListDAO boardListDAO;

    @Override
    public List<BoardDTO> selectList(int start, int displayDataCount,String searchType, String searchData) {
        return boardListDAO.selectLIst(start,displayDataCount,searchType,searchData);
    }

    @Override
    public int totalCount(String searchType , String searchData) {
        return boardListDAO.totalCount(searchType,searchData);
    }

    @Override
    public List<BoardDTO> noticeList() {
        return boardListDAO.noticeList();
    }
}
