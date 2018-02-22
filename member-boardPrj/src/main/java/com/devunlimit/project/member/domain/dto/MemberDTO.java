package com.devunlimit.project.member.domain.dto;

public class MemberDTO {

    private int no;         //회원고유번호
    private String name;    //회원이름
    private String id;      //회원아이디
    private String pwd;     //비밀번호
    private String pwd_Ok; //비밀번호확인
    private String phone;  //핸드폰번호
    private String authority;

    public MemberDTO() {
    }

    public MemberDTO(String name, String pwd) {
        this.name = name;
        this.pwd = pwd;
    }

    public MemberDTO(int no, String name, String id, String pwd, String pwd_Ok, String phone) {
        this.no = no;
        this.name = name;
        this.id = id;
        this.pwd = pwd;
        this.pwd_Ok = pwd_Ok;
        this.phone = phone;
    }

    public MemberDTO(String name, String id, String pwd, String pwd_Ok, String phone) {
        this.name = name;
        this.id = id;
        this.pwd = pwd;
        this.pwd_Ok = pwd_Ok;
        this.phone = phone;
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

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

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getPwd_Ok() {
        return pwd_Ok;
    }

    public void setPwd_Ok(String pwd_Ok) {
        this.pwd_Ok = pwd_Ok;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAuthority() {
        return authority;
    }

    public void setAuthority(String authority) {
        this.authority = authority;
    }
}
