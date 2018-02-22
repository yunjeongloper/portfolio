package com.devunlimit.project.util;

public class PageUtil {

    private Integer displayRowCount = 15;           // 출력할 데이터 개수
    private Integer rowStart;                       // 시작행번호
    private Integer totPage;                        // 전체 페이수
    private Integer totData = 0;                     // 전체 데이터 수
    private Integer page;                           // 현재 페이지
    private Integer pageStart;                      // 시작페이지
    private Integer pageEnd;                        // 종료페이지

    /**
     * 전체 데이터 개수(total)를 이용하여 페이지수 계산.
     */
    public void pageCalculate(Integer total) {
        getPage();
        totData  = total;
        totPage    = (int) ( total / displayRowCount );

        if ( total % displayRowCount > 0 ) {
            totPage++;
        }

        pageStart = (page - (page - 1) % 10) ;
        pageEnd = pageStart + 9;
        if (pageEnd > totPage) {
            pageEnd = totPage;
        }

        rowStart = ((page - 1) * displayRowCount) + 1 ;
    }


    /**
     * 현재 페이지 번호.
     */
    public Integer getPage() {
        if (page == null || page == 0) {
            page = 1;
        }

        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getRowStart() {
        return rowStart;
    }

    public void setRowStart(Integer rowStart) {
        this.rowStart = rowStart;
    }

    public Integer getDisplayRowCount() {
        return displayRowCount;
    }

    public void setDisplayRowCount(Integer displayRowCount) {
        this.displayRowCount = displayRowCount;
    }

    public Integer getTotPage() {
        return totPage;
    }

    public void setTotPage(Integer totPage) {
        this.totPage = totPage;
    }

    public Integer getTotData() {
        return totData;
    }

    public void setTotData(Integer totData) {
        this.totData = totData;
    }

    public Integer getPageStart() {
        return pageStart;
    }

    public void setPageStart(Integer pageStart) {
        this.pageStart = pageStart;
    }

    public Integer getPageEnd() {
        return pageEnd;
    }

    public void setPageEnd(Integer pageEnd) {
        this.pageEnd = pageEnd;
    }

}
