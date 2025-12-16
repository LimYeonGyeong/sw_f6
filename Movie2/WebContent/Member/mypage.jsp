<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../base.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>

<%
  // ✅ base.jsp 변수에 의존하지 않고, loginProcess.jsp가 저장한 세션값으로 로그인 판별
  String _ctx = request.getContextPath();
  String _loginUserId = (String) session.getAttribute("loginUserId");
  String _loginUserName = (String) session.getAttribute("loginUserName"); // 필요하면 사용

  if (_loginUserId == null || _loginUserId.trim().isEmpty()) {
%>
    <script>
      alert("로그인 후 이용해 주세요.");
      location.href="<%=_ctx%>/Member/login.jsp";
    </script>
<%
    return;
  }

  String userName = "";
  String userPw = "";

  DataSource ds = null;
  try {
    Context env = (Context) new InitialContext().lookup("java:comp/env");
    ds = (DataSource) env.lookup("jdbc/movieDB");
  } catch(Exception e) {
    ds = null;
  }

  // 사용자 정보 (users)
  if (ds != null) {
    String userSql = "SELECT user_id, name, password FROM users WHERE user_id=?";
    try (Connection conn = ds.getConnection();
         PreparedStatement ps = conn.prepareStatement(userSql)) {

      ps.setString(1, _loginUserId);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          userName = rs.getString("name");
          userPw = rs.getString("password");
        }
      }
    } catch(Exception ignore) {}
  }

  // 비밀번호 마스킹
  String pwMask = "";
  if (userPw != null) {
    for (int i = 0; i < userPw.length(); i++) pwMask += "*";
  }
%>

<style>
  .mypage-wrap{
    width: 88%;
    margin: 70px auto 40px;
  }

  .mypage-content{
    display:flex;
    gap: 28px;
    align-items:flex-start;
  }

  .mypage-panel{
    border: 4px solid #111;
    background:#fff;
    padding: 18px 18px 22px;
    box-sizing:border-box;
  }

  .mypage-title{
    text-align:center;
    font-size: 34px;
    font-weight: 800;
    margin: 6px 0 18px;
  }

  /* 왼쪽 */
  .mypage-left{
    width: 52%;
  }

  .mypage-field{
    border: 2px solid #111;
    height: 54px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size: 20px;
    margin: 14px 22px;
    box-sizing:border-box;
  }

  /* 오른쪽 */
  .mypage-right{
    width: 48%;
    position: relative;
  }

  .mypage-reserve-list{
    margin-top: 8px;
    display:flex;
    flex-direction:column;
    gap: 18px;
    padding: 0 12px;
  }

  .mypage-reserve-item{
    display:flex;
    gap: 16px;
    align-items:center;
  }

  .mypage-reserve-poster{
    width: 120px;
    height: 160px;
    border: 3px solid #111;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size: 14px;
    box-sizing:border-box;
    background:#fff;
    overflow:hidden;
    border-radius:8px;
  }

  .mypage-reserve-poster img{
    width:100%;
    height:100%;
    object-fit:cover;
    display:block;
  }

  .mypage-reserve-info{
    flex: 1;
    font-size: 16px;
    line-height: 1.7;
  }

  .mypage-cancel-btn{
    padding: 10px 14px;
    border: 2px solid #111;
    background:#fff;
    cursor:pointer;
    white-space:nowrap;
  }
</style>

<div class="mypage-wrap">
  <div class="mypage-content">

    <!-- 내 정보 -->
    <div class="mypage-panel mypage-left">
      <div class="mypage-title">내 정보</div>

      <div class="mypage-field"><%= _loginUserId %></div>
      <div class="mypage-field"><%= pwMask %></div>
      <div class="mypage-field"><%= (userName == null ? "" : userName) %></div>
    </div>

    <!-- 예약 내역 -->
    <div class="mypage-panel mypage-right">
      <div class="mypage-title">예약 내역</div>

      <div class="mypage-reserve-list">
        <%
          boolean hasReservation = false;

          if (ds != null) {
            String resSql =
              "SELECT r.reservation_id, m.title, m.poster_url, s.start_time, " +
              "       GROUP_CONCAT(CONCAT(se.seat_row, se.seat_col) " +
              "                    ORDER BY se.seat_row, se.seat_col SEPARATOR ', ') AS seats " +
              "FROM reservation r " +
              "JOIN showtime s ON r.showtime_id = s.showtime_id " +
              "JOIN movie m ON s.movie_id = m.movie_id " +
              "LEFT JOIN reserved_seat rs ON r.reservation_id = rs.reservation_id " +
              "LEFT JOIN seat se ON rs.seat_id = se.seat_id " +
              "WHERE r.user_id = ? " +
              "  AND (r.status IS NULL OR r.status <> 'CANCELLED') " +
              "GROUP BY r.reservation_id, m.title, m.poster_url, s.start_time " +
              "ORDER BY r.reservation_id DESC";

            try (Connection conn = ds.getConnection();
                 PreparedStatement ps = conn.prepareStatement(resSql)) {

              ps.setString(1, _loginUserId);

              try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                  hasReservation = true;

                  int reservationId = rs.getInt("reservation_id");
                  String title = rs.getString("title");
                  String posterUrl = rs.getString("poster_url");
                  Timestamp startTime = rs.getTimestamp("start_time");
                  String seats = rs.getString("seats");

                  String posterSrc = null;
                  if (posterUrl != null && posterUrl.trim().length() > 0) {
                    posterSrc = _ctx + posterUrl; // poster_url이 /media/... 형태라면 OK
                  }

                  String timeText = (startTime == null) ? "" : startTime.toString().substring(0,16);
        %>

        <div class="mypage-reserve-item">
          <div class="mypage-reserve-poster">
            <% if (posterSrc != null) { %>
              <img src="<%=posterSrc%>" alt="poster">
            <% } else { %>
              해당 영화 포스터
            <% } %>
          </div>

          <div class="mypage-reserve-info">
            <%= (title == null ? "" : title) %><br>
            <%= timeText %><br>
            좌석: <%= (seats == null ? "-" : seats) %>
          </div>

          <button class="mypage-cancel-btn" type="button"
                  onclick="location.href='<%=_ctx%>/reserve/reservationCancel.jsp?reservationId=<%=reservationId%>'">
            예매 취소
          </button>
        </div>

        <%
                }
              }
            } catch(Exception ignore) {}
          }

          if (!hasReservation) {
        %>
          <div style="text-align:center; padding:30px 0; font-size:16px;">
            예약 내역이 없습니다
          </div>
        <%
          }
        %>
      </div>
    </div>

  </div>
</div>
