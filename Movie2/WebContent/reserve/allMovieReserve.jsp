<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../base.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>

<style>
  .wrap{
    width:88%;
    margin:70px auto 40px;
  }
  .row{
    border:2px solid #111;
    border-radius:12px;
    padding:18px 18px 14px;
    margin-bottom:18px;
  }
  .head{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    margin-bottom:12px;
  }
  .movie-title{
    font-size:20px;
    font-weight:800;
    cursor:pointer;
    text-decoration:none;
    color:#111;
  }
  .movie-title:hover{ text-decoration:underline; }

  .times{
    display:flex;
    flex-wrap:wrap;
    gap:12px;
    align-items:center;
  }
  .time-btn{
    min-width:160px;
    padding:14px 16px;
    border:1px solid #ddd;
    border-radius:12px;
    cursor:pointer;
    background:#fff;
  }
  .time-btn:hover{ border-color:#111; }

  .time{ font-size:16px; font-weight:800; }
  .remain{ margin-top:6px; font-size:13px; color:#555; }

  .empty{ color:#777; font-size:14px; padding:10px 0; }
</style>

<div class="wrap">
<%
  Context env = (Context) new InitialContext().lookup("java:comp/env");
  DataSource ds = (DataSource) env.lookup("jdbc/movieDB");

  String movieSql = "SELECT movie_id, title FROM movie ORDER BY movie_id ASC";
  String timeSql  =
    "SELECT showtime_id, start_time, remaining_seats " +
    "FROM showtime WHERE movie_id=? " +
    "ORDER BY start_time ASC";

  try (Connection conn = ds.getConnection();
       PreparedStatement psMovie = conn.prepareStatement(movieSql);
       PreparedStatement psTime  = conn.prepareStatement(timeSql);
       ResultSet rsMovie = psMovie.executeQuery()) {

    while (rsMovie.next()) {
      int movieId = rsMovie.getInt("movie_id");
      String title = rsMovie.getString("title");
%>

  <div class="row">
    <div class="head">
      <a class="movie-title"
         href="<%=request.getContextPath()%>/reserve/movieDetail.jsp?movie_id=<%=movieId%>">
        <%=title%>
      </a>
    </div>

    <div class="times">
      <%
        psTime.setInt(1, movieId);
        try (ResultSet rsTime = psTime.executeQuery()) {
          boolean hasTime = false;
          while (rsTime.next()) {
            hasTime = true;
            int showtimeId = rsTime.getInt("showtime_id");
            Timestamp startTime = rsTime.getTimestamp("start_time");
            int remaining = rsTime.getInt("remaining_seats");
      %>
        <button class="time-btn"
                onclick="location.href='<%=request.getContextPath()%>/reserve/selectSeat.jsp?showtime_id=<%=showtimeId%>'">
          <div class="time"><%= startTime.toString().substring(0,16) %></div>
          <div class="remain">남은 좌석: <%= remaining %></div>
        </button>
      <%
          }
        }
      %>
    </div>
  </div>

<%
    } // while movie
  } // try
%>
</div>