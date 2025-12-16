<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*
, thinkonweb.util.ConnectionContext,java.text.SimpleDateFormat" %>

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

String showtimeIdStr   = request.getParameter("showtime_id");
String seatIdsParam    = request.getParameter("seatIds");
String seatLabelsParam = request.getParameter("seatLabels");
String peopleParam     = request.getParameter("people");

if (showtimeIdStr == null || seatIdsParam == null || seatIdsParam.trim().length() == 0) {
%>
  <script>
    alert("필수 정보가 누락되었습니다.");
    history.back();
  </script>
<%
    return;
}

int showtimeId = Integer.parseInt(showtimeIdStr);
String[] seatIdArr = seatIdsParam.split(",");
String[] seatLabelArr;
if (seatLabelsParam != null && seatLabelsParam.trim().length() > 0) {
    seatLabelArr = seatLabelsParam.split(",");
} else {
    seatLabelArr = new String[seatIdArr.length];
}

int people = seatIdArr.length;  // 실제 좌석 개수 기준

boolean success = false;
int reservationId = -1;
String movieTitle = "";
Timestamp startTime = null;

Connection conn = null;

try {
    conn = ConnectionContext.getConnection();
    conn.setAutoCommit(false);

    // 상영 정보 + remaining_seats 조회
    int remainingSeats = 0;
    String infoSql =
        "SELECT m.title, st.start_time, st.remaining_seats " +
        "FROM showtime st JOIN movie m ON st.movie_id = m.movie_id " +
        "WHERE st.showtime_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
        ps.setInt(1, showtimeId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                movieTitle     = rs.getString("title");
                startTime      = rs.getTimestamp("start_time");
                remainingSeats = rs.getInt("remaining_seats");
            }
        }
    }

    if (remainingSeats < people) {
        conn.rollback();
%>
<script>
  alert("잔여 좌석보다 많은 인원을 예약할 수 없습니다. 다시 시도해 주세요.");
  location.href="selectSeat.jsp?showtime_id=<%= showtimeId %>";
</script>
<%
        return;
    }

    // 선택한 좌석 중 이미 예약된 것이 있는지 체크
    String checkSql =
        "SELECT COUNT(*) FROM reserved_seat WHERE showtime_id = ? AND seat_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
        for (String seatIdStr : seatIdArr) {
            int seatId = Integer.parseInt(seatIdStr.trim());
            ps.setInt(1, showtimeId);
            ps.setInt(2, seatId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    conn.rollback();
%>
<script>
  alert("이미 예약된 좌석이 포함되어 있어 예약에 실패했습니다. 다시 선택해 주세요.");
  location.href="selectSeat.jsp?showtime_id=<%= showtimeId %>";
</script>
<%
                    return;
                }
            }
        }
    }

    String insertResSql =
        "INSERT INTO reservation (user_id, showtime_id, reserved_at, status) " +
        "VALUES (?, ?, NOW(), 'RESERVED')";
    try (PreparedStatement ps = conn.prepareStatement(insertResSql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, loginUserId);
        ps.setInt(2, showtimeId);
        int row = ps.executeUpdate();
        if (row > 0) {
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) reservationId = rs.getInt(1);
            }
        }
    }

    if (reservationId == -1) {
        conn.rollback();
%>
<script>
  alert("예약 생성에 실패했습니다.");
  history.back();
</script>
<%
        return;
    }

    // 여러 좌석
    String insertSeatSql =
        "INSERT INTO reserved_seat (reservation_id, seat_id, showtime_id) " +
        "VALUES (?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(insertSeatSql)) {
        for (String seatIdStr : seatIdArr) {
            int seatId = Integer.parseInt(seatIdStr.trim());
            ps.setInt(1, reservationId);
            ps.setInt(2, seatId);
            ps.setInt(3, showtimeId);
            ps.addBatch();
        }
        ps.executeBatch();
    }

    // 남은 자리리 감소
    String updateShowtimeSql =
        "UPDATE showtime SET remaining_seats = remaining_seats - ? " +
        "WHERE showtime_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(updateShowtimeSql)) {
        ps.setInt(1, people);
        ps.setInt(2, showtimeId);
        ps.executeUpdate();
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
<title>예약 완료</title>
</head>
<body>
<div class="navbar">
  <!-- 왼쪽 상단: 홈 -->
  <a class="home" href="<%=ctx%>/home/home.jsp">
    <img src="<%=ctx%>/media/home.png" alt="home">
  </a>

  <!-- 오른쪽 상단 -->
  <div class="right">
    <% if (!isLogin) { %>
      <button class="login-btn" type="button"
              onclick="location.href='<%=ctx%>/Member/login.jsp'">로그인</button>
    <% } else { %>
      <img id="profileBtn" class="profile-img"
           src="<%=ctx%>/media/user.png" alt="user">

      <div id="profileDropdown" class="dropdown">
        <a href="<%=ctx%>/Member/mypage.jsp">마이페이지</a>
        <a class="logout" href="<%=ctx%>/Member/logout.jsp">로그아웃</a>
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
    String seatsText = "";
    for (int i = 0; i < seatLabelArr.length; i++) {
        if (seatLabelArr[i] != null && seatLabelArr[i].trim().length() > 0) {
            if (seatsText.length() > 0) seatsText += ", ";
            seatsText += seatLabelArr[i].trim();
        }
    }
%>
<%
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
  String formattedTime = (startTime != null) ? sdf.format(startTime) : "";
%>
<div class="result-box">
  <h2>예약이 완료되었습니다.</h2>
  <p>예약 번호: <strong><%= reservationId %></strong></p>
  <p>영화: <strong><%= movieTitle %></strong></p>
  <p>상영 시간: <strong><%= formattedTime %></strong></p>
  <p>인원 수: <strong><%= people %>명</strong></p>
  <p>좌석: <strong><%= seatsText %></strong></p>
  <p>예약자: <strong><%= (loginUserName != null ? loginUserName : loginUserId) %></strong></p>
</div>

<%
}
%>
<script>
  const btn = document.getElementById("profileBtn");
  const dd  = document.getElementById("profileDropdown");

  if (btn && dd) {
    btn.addEventListener("click", (e) => {
      e.stopPropagation();
      dd.classList.toggle("show");
    });

    window.addEventListener("click", () => {
      dd.classList.remove("show");
    });
  }
</script>


</body>
</html>