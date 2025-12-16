<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../base.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>

<style>
  .wrap{ 
    width:88%;
    margin:70px auto 40px; 
    display:flex; 
    gap:28px; 
    align-items:flex-start; 
}

  .left{ 
    width:260px; 
}

  .poster{ 
    width:100%; 
    border-radius:12px; 
    border:1px solid #ddd; 
    overflow:hidden; 
}
  .poster img{ 
    width:100%; 
    display:block; 
    aspect-ratio:2/3; 
    object-fit:cover; 
}
  .info{ 
    margin-top:14px; 
    border:1px solid #ddd; 
    border-radius:12px; 
    padding:14px; 
}

  .center{ 
    flex:1; 
    border:2px solid #111; 
    border-radius:12px; 
    min-height:420px; 
    padding:26px; 
}
  .center h2{ 
    margin:0 0 18px; 
    font-size:28px; 
    text-align:center; 
}

  .times{ 
    display:flex; 
    flex-wrap:wrap; 
    gap:12px; 
    justify-content:center; 
    margin-top:18px; 
}
  .time-btn{
    min-width:160px; 
    padding:14px 16px; 
    border:1px solid #ddd; 
    border-radius:12px;
    cursor:pointer; 
    background:#fff;
  }
  .time-btn:hover{ 
    border-color:#111; 
}
  .time{ 
    font-size:18px; 
    font-weight:700; 
}
  .remain{ 
    margin-top:6px; 
    font-size:13px; 
    color:#555; 
}

  .fallback{ 
    width:100%; 
    aspect-ratio:2/3; 
    background:#f3f3f3; 
    display:flex; 
    align-items:center; 
    justify-content:center; 
    color:#666; 
  }
</style>

<%
  int movieId = 0;
  try { movieId = Integer.parseInt(request.getParameter("movie_id")); } catch(Exception ignore) {}

  String title = null, posterUrl = null, age = null, desc = null;
  int runtime = 0;

  Context env = (Context) new InitialContext().lookup("java:comp/env");
  DataSource ds = (DataSource) env.lookup("jdbc/movieDB");

  String movieSql = "SELECT movie_id, title, poster_url, age_rating, runtime, description FROM movie WHERE movie_id=?";
  try (Connection conn = ds.getConnection();
       PreparedStatement ps = conn.prepareStatement(movieSql)) {

    ps.setInt(1, movieId);
    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) {
        title = rs.getString("title");
        posterUrl = rs.getString("poster_url");
        age = rs.getString("age_rating");
        runtime = rs.getInt("runtime");
        desc = rs.getString("description");
      }
    }
  }
%>

<div class="wrap">

  <!-- 좌측: 포스터 + 영화정보 -->
  <div class="left">
    <div class="poster">
      <%
        if (posterUrl != null && posterUrl.trim().length() > 0) {
      %>
        <img src="<%=request.getContextPath() + posterUrl%>" alt="poster">
      <%
        } else {
      %>
        <div class="fallback">poster</div>
      <%
        }
      %>
    </div>

    <div class="info">
      <div style="font-weight:700; font-size:16px; margin-bottom:8px;">
        <%= (title == null ? "영화 정보 없음" : title) %>
      </div>
      <div style="font-size:13px; color:#555; line-height:1.6;">
        등급: <%= (age == null ? "-" : age) %><br>
        러닝타임: <%= runtime %>분<br>
      </div>
      <div style="margin-top:10px; font-size:13px; line-height:1.6; white-space:pre-wrap;">
        <%= (desc == null ? "" : desc) %>
      </div>
    </div>
  </div>

  <!-- 가운데: 상영시간표(4개) -->
  <div class="center">
    <h2>해당 영화 상영 시간표</h2>

    <div class="times">
      <%
        if (title != null) {
          String timeSql =
            "SELECT showtime_id, start_time, remaining_seats " +
            "FROM showtime WHERE movie_id=? " +
            "ORDER BY start_time ASC LIMIT 4";

          try (Connection conn = ds.getConnection();
               PreparedStatement ps = conn.prepareStatement(timeSql)) {

            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
              while (rs.next()) {
                int showtimeId = rs.getInt("showtime_id");
                Timestamp startTime = rs.getTimestamp("start_time");
                int remaining = rs.getInt("remaining_seats");
      %>

        <button class="time-btn"
                onclick="location.href='<%=request.getContextPath()%>/reserve/selectSeat.jsp?showtime_id=<%=showtimeId%>'">
          <div class="time"><%= startTime.toString().substring(0,16) %></div>
          <div class="remain">남은 좌석: <%= remaining %></div>
        </button>

      <%
              }
            }
          }
        }
      %>
    </div>
  </div>

</div>
