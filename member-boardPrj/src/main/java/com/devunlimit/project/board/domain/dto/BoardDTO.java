package com.devunlimit.project.board.domain.dto;

import java.util.Date;

public class BoardDTO {

  private String no;
  private String subject;
  private String content;
  private String writer;
  private Date write_date;
  private boolean notice;
  private String parents_no;
  private String count;
  private String delete_ok;
  private int cnt;

  private String name;
  private String id;



  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public BoardDTO() {
  }

  public BoardDTO(String subject, String content, String writer, boolean notice) {
    this.subject = subject;
    this.content = content;
    this.writer = writer;
    this.notice = notice;
  }

  public String getNo() {
    return no;
  }

  public void setNo(String no) {
    this.no = no;
  }

  public String getSubject() {
    return subject;
  }

  public void setSubject(String subject) {
    this.subject = subject;
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

  public Date getWrite_date() {
    return write_date;
  }

  public void setWrite_date(Date write_date) {
    this.write_date = write_date;
  }

  public boolean isNotice() {
    return notice;
  }

  public void setNotice(boolean notice) {
    this.notice = notice;
  }

  public String getParents_no() {
    return parents_no;
  }

  public void setParents_no(String parents_no) {
    this.parents_no = parents_no;
  }

  public String getCount() {
    return count;
  }

  public void setCount(String count) {
    this.count = count;
  }

  public String getDelete_ok() {
    return delete_ok;
  }

  public void setDelete_ok(String delete_ok) {
    this.delete_ok = delete_ok;
  }

  public int getCnt() {
    return cnt;
  }

  public void setCnt(int cnt) {
    this.cnt = cnt;
  }
}

