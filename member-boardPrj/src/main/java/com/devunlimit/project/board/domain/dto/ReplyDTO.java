package com.devunlimit.project.board.domain.dto;

import java.util.Date;

public class ReplyDTO {

  private String no;
  private String board_no;
  private String content;
  private String writer;
  private String writer_no;
  private Date write_date;
  private String parents_no;
  private String delete_ok;
  private String deleted;
  private String re_re;

  public ReplyDTO() {

  }

  public ReplyDTO(String no, String board_no, String content, String writer, String parents_no) {
    this.no = no;
    this.board_no = board_no;
    this.content = content;
    this.writer = writer;
    this.parents_no = parents_no;
  }

  public ReplyDTO(String board_no, String content, String writer, String parents_no) {
    this.board_no = board_no;
    this.content = content;
    this.writer = writer;
    this.parents_no = parents_no;
  }

  public String getNo() {
    return no;
  }

  public void setNo(String no) {
    this.no = no;
  }

  public String getBoard_no() {
    return board_no;
  }

  public void setBoard_no(String board_no) {
    this.board_no = board_no;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public String getWriter() {
    return writer;
  }

  public void setWriter(String writer) {
    this.writer = writer;
  }

  public String getWriter_no() {
    return writer_no;
  }

  public void setWriter_no(String writer_no) {
    this.writer_no = writer_no;
  }

  public Date getWrite_date() {
    return write_date;
  }

  public void setWrite_date(Date write_date) {
    this.write_date = write_date;
  }

  public String getParents_no() {
    return parents_no;
  }

  public void setParents_no(String parents_no) {
    this.parents_no = parents_no;
  }

  public String getDelete_ok() {
    return delete_ok;
  }

  public void setDelete_ok(String delete_ok) {
    this.delete_ok = delete_ok;
  }

  public String getDeleted() {
    return deleted;
  }

  public void setDeleted(String deleted) {
    this.deleted = deleted;
  }

  public String getRe_re() {
    return re_re;
  }

  public void setRe_re(String re_re) {
    this.re_re = re_re;
  }
}
