<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../base.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>

<style>
  /* 카드 영역 전체를 아래로 내림 */
  .movie-section{
    margin-top: 80px; /* 더 내려오게 */
  }

  /* 4장 묶음(전체 폭 88%: 카드 19%*4 + 간격 4%*3 = 88%) */
  .movie-row{
    width: 88%;
    margin: 0 auto;             /* 중앙 배치 */
    display: flex;
    justify-content: space-between; /* 간격 강제 */
    gap: 4%;
  }

  .movie-card{
    width: 19%;
    position: relative;
    cursor: pointer;
  }

  /* ✅ 카드가 커진 만큼 세로도 자동으로 커지게 (비율 유지) */
  .movie-card img{
    width: 100%;
    aspect-ratio: 2 / 3;  /* 포스터 비율(가로:세로) */
    object-fit: cover;
    border-radius: 12px;
    display: block;
    border: 1px solid #ddd;
  }

  /* hover 오버레이 */
  .movie-info{
    position: absolute;
    inset: 0;
    background: rgba(0,0,0,0.75);
    color: #fff;
    padding: 14px;
    box-sizing: border-box;
    opacity: 0;
    transition: opacity 0.2s ease;
    border-radius: 12px;
  }
  .movie-card:hover .movie-info{ opacity: 1; }

  .movie-info h3{ margin: 0 0 8px; font-size: 16px; }
  .movie-info p{ margin: 4px 0; font-size: 13px; }

  /* 이미지가 없을 때도 카드가 커 보이도록(테스트용) */
  .poster-fallback{
    width: 100%;
    aspect-ratio: 2 / 3;
    border-radius: 12px;
    border: 1px solid #ddd;
    background: #f3f3f3;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#666;
    font-size:14px;
  }

  .fixed-reserve-btn{
    position: fixed;
    right: 30px;
    bottom: 30px;
    padding: 14px 22px;
    border: none;
    border-radius: 30px;
    font-size: 20px;
    cursor: pointer;
    z-index: 1000;
  }
</style>

<div class="movie-section">
  <!-- ✅ 예매하기 버튼 -->
  <button class="fixed-reserve-btn"
          onclick="location.href='<%=request.getContextPath()%>/reserve/allMovieReserve.jsp'">
    예매하기
  </button>

  <div class="movie-row">
    <%
      String sql =
        "SELECT movie_id, title, poster_url, age_rating, runtime, description " +
        "FROM movie " +
        "ORDER BY movie_id ASC " +
        "LIMIT 4";

      try {
        Context env = (Context) new InitialContext().lookup("java:comp/env");
        DataSource ds = (DataSource) env.lookup("jdbc/movieDB");

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

          while (rs.next()) {
            int movieId = rs.getInt("movie_id");
            String title = rs.getString("title");
            String posterUrl = rs.getString("poster_url");     
            String age = rs.getString("age_rating");
            int runtime = rs.getInt("runtime");
            String desc = rs.getString("description");

            boolean hasPoster = (posterUrl != null && posterUrl.trim().length() > 0);
    %>

      <div class="movie-card"
           onclick="location.href='<%=request.getContextPath()%>/reserve/movieDetail.jsp?movie_id=<%=movieId%>'">

        <% if (hasPoster) { %>
          <img src="<%=request.getContextPath() + posterUrl%>" alt="movie">
        <% } else { %>
          <div class="poster-fallback">movie</div>
        <% } %>

        <div class="movie-info">
          <h3><%=title%></h3>
          <p>등급: <%=age%></p>
          <p>러닝타임: <%=runtime%>분</p>
          <p>줄거리: <%= (desc == null ? "내용 없음" : desc) %></p>
        </div>
      </div>

    <%
          } // while
        } // try-with-resources
      } catch (Exception e) {
    %>
      <div style="width:88%; margin:0 auto; white-space:pre-wrap;">
        DB 오류: <%= e.getClass().getName() %>
        <%= e.getMessage() %>
      </div>
    <%
      }
    %>
  </div>
</div>
