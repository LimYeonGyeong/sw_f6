<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, thinkonweb.util.ConnectionContext" %>

<%
request.setCharacterEncoding("UTF-8");
String ctx = request.getContextPath();

String loginUserId   = (String) session.getAttribute("loginUserId");
String loginUserName = (String) session.getAttribute("loginUserName");
boolean isLogin = (loginUserId != null && !loginUserId.trim().isEmpty());

if (loginUserId == null) {
%>
  <script>
    alert("로그인 후 이용해 주세요.");
    location.href="../Member/login.jsp";
  </script>
<%
    return;
}

String reservationIdStr = request.getParameter("reservationId");
if (reservationIdStr == null) {
%>
  <script>
    alert("예약 번호가 없습니다.");
    history.back();
  </script>
<%
    return;
}

int reservationId = Integer.parseInt(reservationIdStr);
boolean success = false;
Connection conn = null;

try {
    conn = ConnectionContext.getConnection();
    conn.setAutoCommit(false);

    // 예약이 현재 로그인한 유저의 것인지 + 좌석 개수 / showtime_id 조회
    int seatCount = 0;
    int showtimeId = -1;

    String infoSql =
        "SELECT r.showtime_id, COUNT(rs.reserved_seat_id) AS seat_count " +
        "FROM reservation r " +
        "LEFT JOIN reserved_seat rs ON r.reservation_id = rs.reservation_id " +
        "WHERE r.reservation_id = ? AND r.user_id = ? " +
        "GROUP BY r.showtime_id";
    try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
        ps.setInt(1, reservationId);
        ps.setString(2, loginUserId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                showtimeId = rs.getInt("showtime_id");
                seatCount  = rs.getInt("seat_count");
            }
        }
    }

    if (showtimeId == -1) {
        conn.rollback();
%>
<script>
  alert("해당 예약이 없거나 다른 사용자의 예약입니다.");
  history.back();
</script>
<%
        return;
    }

    // RESERVED_SEAT 삭제
    String deleteSeatSql =
        "DELETE FROM reserved_seat WHERE reservation_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(deleteSeatSql)) {
        ps.setInt(1, reservationId);
        ps.executeUpdate();
    }

    // RESERVATION 상태 CANCELLED로
    String updateResSql =
        "UPDATE reservation SET status = 'CANCELLED' " +
        "WHERE reservation_id = ? AND user_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(updateResSql)) {
        ps.setInt(1, reservationId);
        ps.setString(2, loginUserId);
        int row = ps.executeUpdate();
        if (row == 0) {
            conn.rollback();
%>
<script>
  alert("예약 취소에 실패했습니다.");
  history.back();
</script>
<%
            return;
        }
    }

    // SHOWTIME.remaining_seats 복구
    if (seatCount > 0) {
        String updateShowtimeSql =
            "UPDATE showtime SET remaining_seats = remaining_seats + ? " +
            "WHERE showtime_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(updateShowtimeSql)) {
            ps.setInt(1, seatCount);
            ps.setInt(2, showtimeId);
            ps.executeUpdate();
        }
    }

    conn.commit();
    success = true;

} catch (Exception e) {
    e.printStackTrace();
    if (conn != null) {
        try { conn.rollback(); } catch (Exception ignore) {}
    }
} finally {
    if (conn != null) {
        try { conn.close(); } catch (Exception ignore) {}
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 취소</title>
</head>
<body>
<div class="navbar">
  <!-- 왼쪽 상단: 홈 -->
  <a class="home" href="<%=ctx%>/sw_f6/WebContent/home/home.jsp">
    <img src="<%=ctx%>/sw_f6/WebContent/media/home.png" alt="home">
  </a>

  <!-- 오른쪽 상단 -->
  <div class="right">
    <% if (!isLogin) { %>
      <button class="login-btn" type="button"
              onclick="location.href='<%=ctx%>/sw_f6/WebContent/Member/login.jsp'">로그인</button>
    <% } else { %>
      <img id="profileBtn" class="profile-img"
           src="<%=ctx%>/sw_f6/WebContent/media/user.png" alt="user">

      <div id="profileDropdown" class="dropdown">
        <a href="<%=ctx%>/sw_f6/WebContent/Member/MyPage.jsp">마이페이지</a>
        <a class="logout" href="<%=ctx%>/sw_f6/WebContent/Member/logout.jsp">로그아웃</a>
      </div>
    <% } %>
  </div>
</div>

<style>
/* ===== NAVBAR ===== */
.navbar{
  display:flex;
  justify-content:space-between;
  align-items:center;
  padding:10px 20px;
  border-bottom:1px solid #ddd;
  background:#fff;
}

.home img{ height:50px; }

.right{ position:relative; }

.login-btn{
  padding:16px 28px;
  cursor:pointer;
}

.profile-img{
  width:50px;
  height:50px;
  border-radius:50%;
  cursor:pointer;
}

.dropdown{
  display:none;
  position:absolute;
  top:52px;
  right:0;
  width:150px;
  background:#fff;
  border:1px solid #ccc;
  border-radius:8px;
  overflow:hidden;
}

.dropdown.show{ display:block; }

.dropdown a{
  display:block;
  padding:10px 12px;
  text-align:center;
  text-decoration:none;
  color:#000;
}

.dropdown a:hover{ background:#f5f5f5; }

.dropdown .logout{
  background:red;
  color:#fff;
}

.dropdown .logout:hover{ background:darkred; }

.result-box {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);

  text-align: center;
  padding: 30px 40px;
  border: 2px solid #333;
  border-radius: 10px;
  background: #fff;
}

</style>

<%
if (success) {
%>

<div class="result-box">
  <h2>예약이 취소되었습니다.</h2>
  <p>예약 번호: <strong><%= reservationId %></strong></p>
</div>

 <%
}
%>
</body>
</html>

