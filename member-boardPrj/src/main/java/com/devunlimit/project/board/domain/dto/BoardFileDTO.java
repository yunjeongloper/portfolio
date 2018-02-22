package com.devunlimit.project.board.domain.dto;

public class BoardFileDTO {

    private String no;
    private String boardNo;
    private String originName;
    private String saveName;
    private String url;

    public  BoardFileDTO() {}

    public BoardFileDTO(String boardNo,String originName,String saveName,String url){
        this.boardNo =boardNo;
        this.originName = originName;
        this.saveName = saveName;
        this.url = url;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getBoardNo() {
        return boardNo;
    }

    public void setBoardNo(String boardNo) {
        this.boardNo = boardNo;
    }

    public String getOriginName() {
        return originName;
    }

    public void setOriginName(String originName) {
        this.originName = originName;
    }

    public String getSaveName() {
        return saveName;
    }

    public void setSaveName(String saveName) {
        this.saveName = saveName;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
