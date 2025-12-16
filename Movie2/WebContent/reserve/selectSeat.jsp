<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, thinkonweb.util.ConnectionContext" %>

<%
request.setCharacterEncoding("UTF-8");

String ctx = request.getContextPath();
String loginUserId   = (String) session.getAttribute("loginUserId");
String loginUserName = (String) session.getAttribute("loginUserName");

if (loginUserId == null || loginUserId.trim().isEmpty()) {
%>
  <script>
    alert("로그인 후 이용해 주세요.");
    location.href = "<%= ctx %>/Member/login.jsp";
  </script>
<%
  return;
}
boolean isLogin = (loginUserId != null && !loginUserId.trim().isEmpty());

String showtimeIdStr = request.getParameter("showtime_id");
if (showtimeIdStr == null) {
%>
  <script>
    alert("상영 시간 정보가 없습니다.");
    history.back();
  </script>
<%
    return;
}
int showtimeId = Integer.parseInt(showtimeIdStr);

// 상영 정보 및 좌석 정보 조회
String movieTitle = "";
String screenName = "";
Timestamp startTime = null;
int remainingSeats = 0;

class SeatInfo {
    int seatId;
    String row;
    int col;
    boolean reserved;
}
List<SeatInfo> seatList = new ArrayList<>();

try (Connection conn = ConnectionContext.getConnection()) {

    // 상영 + 영화 + 상영관
    String infoSql =
        "SELECT m.title, s.name AS screen_name, st.start_time, st.remaining_seats " +
        "FROM showtime st " +
        "JOIN movie  m ON st.movie_id = m.movie_id " +
        "JOIN screen s ON st.screen_id = s.screen_id " +
        "WHERE st.showtime_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
        ps.setInt(1, showtimeId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                movieTitle     = rs.getString("title");
                screenName     = rs.getString("screen_name");
                startTime      = rs.getTimestamp("start_time");
                remainingSeats = rs.getInt("remaining_seats");
            }
        }
    }

    // 좌석 + 예약 여부
    String seatSql =
        "SELECT se.seat_id, se.seat_row, se.seat_col, " +
        "       CASE WHEN rs.reserved_seat_id IS NULL THEN 0 ELSE 1 END AS is_reserved " +
        "FROM seat se " +
        "JOIN showtime st ON st.screen_id = se.screen_id " +
        "LEFT JOIN reserved_seat rs " +
        "       ON rs.seat_id = se.seat_id AND rs.showtime_id = st.showtime_id " +
        "WHERE st.showtime_id = ? " +
        "ORDER BY se.seat_row, se.seat_col";

    try (PreparedStatement ps = conn.prepareStatement(seatSql)) {
        ps.setInt(1, showtimeId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SeatInfo s = new SeatInfo();
                s.seatId   = rs.getInt("seat_id");
                s.row      = rs.getString("seat_row");  // 'A' ~ 'H'
                s.col      = rs.getInt("seat_col");     // 1 ~ 13
                s.reserved = (rs.getInt("is_reserved") == 1);
                seatList.add(s);
            }
        }
    }

} catch (Exception e) {
    e.printStackTrace();
%>
  <script>
    alert("좌석 정보를 불러오는 중 오류가 발생했습니다.");
    history.back();
  </script>
<%
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좌석 선택</title>

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
  z-index: 9999;
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
  

  .seat-wrap{
  width: 680px;
  margin: 0 auto;
  border: 6px solid #000;
  padding: 18px 18px 14px 18px;
  position: relative;
  background: #fff;
}

/* 스크린 */
.screen-bar{
  width: 360px;
  height: 32px;
  margin: 0 auto 12px auto;
  background: #bfc7d5;
  color: #000;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 2px;
}

/* 인원수 - 우측 상단 */
.people-in-box{
  position: absolute;
  top: 10px;
  right: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 700;
  white-space: nowrap;
}
  .info-bottom-row{
    display: flex;
    align-items: center;
    gap: 12px;
  }

   .people-select{
    white-space: nowrap;
    margin-top: 105px;
  }

  table.seat-table {
    border-collapse: collapse;
    margin: 20px auto;
  }
  table.seat-table td {
    padding: 4px;
    text-align: center;
  }
  button.seat-btn {
    width: 40px;
    height: 40px;
    cursor: pointer;
  }
  button.reserved {
    background-color: #999;
    color: #fff;
    cursor: not-allowed;
  }
  button.selected {
    border: 2px solid red;
    font-weight: bold;
  }
</style>

<script>
  // seat_row-seat_col -> seat_id
  let seatMap = {};
  // 이미 예약된 seat_id
  let reservedSeatSet = new Set();

  // 현재 선택된 seat_id 배열 / 좌석 라벨 배열
  let selectedSeatIds = [];
  let selectedSeatLabels = [];

  function clearSelection() {
      selectedSeatIds = [];
      selectedSeatLabels = [];
      document.querySelectorAll(".seat-btn").forEach(btn => {
          btn.classList.remove("selected");
      });

      // hidden 값 초기화
      const seatIdsEl = document.getElementById("seatIds");
      const seatLabelsEl = document.getElementById("seatLabels");
      const peopleEl = document.getElementById("people");
      if (seatIdsEl) seatIdsEl.value = "";
      if (seatLabelsEl) seatLabelsEl.value = "";
      if (peopleEl) peopleEl.value = "";
  }

  // 오른쪽 우선
  // 오른쪽이 막히면 왼쪽에서 좌석 확보
  function selectSeats(row, col) {
      clearSelection();

      const people = parseInt(document.getElementById("peopleCount").value);
      const remaining = parseInt(document.getElementById("remainingSeats").value);
      const MIN_COL = 1;
      const MAX_COL = 13;

      if (!people || people <= 0) {
          alert("인원 수를 먼저 선택해 주세요.");
          return;
      }

      if (people > remaining) {
          alert("잔여 좌석(" + remaining + "석)보다 많은 인원을 선택할 수 없습니다.");
          return;
      }

      // 클릭 좌석 유효, 예약 체크
      const clickedKey = row + "-" + col;
      const clickedSeatId = seatMap[clickedKey];
      if (!clickedSeatId) {
          alert("좌석 정보가 잘못되었습니다.");
          return;
      }
      if (reservedSeatSet.has(clickedSeatId)) {
          alert("이미 예약된 좌석입니다.");
          return;
      }

      // 클릭 좌석을 포함하는 연속 빈 구간 찾기
      let left = col;
      while (left - 1 >= MIN_COL) {
          const key = row + "-" + (left - 1);
          const sid = seatMap[key];
          if (!sid || reservedSeatSet.has(sid)) break;
          left--;
      }

      let right = col;
      while (right + 1 <= MAX_COL) {
          const key = row + "-" + (right + 1);
          const sid = seatMap[key];
          if (!sid || reservedSeatSet.has(sid)) break;
          right++;
      }

      const freeLen = right - left + 1;
      if (freeLen < people) {
          alert("연속된 좌석이 부족합니다. 다른 위치를 선택해 주세요.");
          return;
      }

      // 클릭 좌석부터 오른쪽으로
      // 오른쪽이 모자라면 가능한 한 오른쪽 끝에 붙여 놓고 왼쪽으로
      let start = col;
      let end = col + people - 1;

      if (end > right) {
          end = right;
          start = end - people + 1;
      }
      if (start < left) {
          start = left;
          end = start + people - 1;
      }

      // 실제 선택 적용
      for (let c = start; c <= end; c++) {
          const key = row + "-" + c;
          const seatId = seatMap[key];

          if (!seatId || reservedSeatSet.has(seatId)) {
              alert("중간에 예약된 좌석이 있어 선택할 수 없습니다.");
              clearSelection();
              return;
          }

          selectedSeatIds.push(seatId);
          selectedSeatLabels.push(row + c);

          const btn = document.getElementById("seatBtn_" + seatId);
          if (btn) btn.classList.add("selected");
      }

      // hidden으로 값 전달
      document.getElementById("seatIds").value = selectedSeatIds.join(",");
      document.getElementById("seatLabels").value = selectedSeatLabels.join(",");
      document.getElementById("people").value = people;
  }

  function submitReservation() {
      if (selectedSeatIds.length === 0) {
          alert("좌석을 먼저 선택해 주세요.");
          return;
      }

      const labels = selectedSeatLabels.join(", ");
      if (confirm(labels + " 좌석을 예약하시겠습니까?")) {
          document.getElementById("reserveForm").submit();
      }
  }
</script>

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

<div class="seat-wrap">

  <div class="screen-bar">스크린</div>

  <div class="people-in-box">
    <span>수량 ▼</span>
    <select id="peopleCount" onchange="clearSelection()">
      <%
        int maxPeople = Math.min(10, remainingSeats);
        if (maxPeople <= 0) {
      %>
        <option value="0">예약 불가</option>
      <%
        } else {
          for (int i = 1; i <= maxPeople; i++) {
      %>
        <option value="<%=i%>"><%=i%>명</option>
      <%
          }
        }
      %>
    </select>
  </div>
  <form id="reserveForm" action="reservationComplete.jsp" method="post">
  <input type="hidden" name="showtime_id" value="<%= showtimeId %>">
  <input type="hidden" name="seatIds" id="seatIds">
  <input type="hidden" name="seatLabels" id="seatLabels">
  <input type="hidden" name="people" id="people">
  <input type="hidden" id="remainingSeats" value="<%= remainingSeats %>">
  </form>

  <table class="seat-table" border="1">
  <%  
      String currentRow = "";
      for (SeatInfo s : seatList) {
          if (!s.row.equals(currentRow)) {
              if (!"".equals(currentRow)) {
  %>
    </tr>
  <%
              }
              currentRow = s.row;
  %>
    <tr>
      <td><strong><%= currentRow %></strong></td>
  <%
          }
          if (s.reserved) {
  %>
      <td>
        <button type="button"
                id="seatBtn_<%= s.seatId %>"
                class="seat-btn reserved"
                disabled><%= s.col %></button>
      </td>
  <%
          } else {
  %>
      <td>
        <button type="button"
                id="seatBtn_<%= s.seatId %>"
                class="seat-btn"
                onclick="selectSeats('<%= s.row %>', <%= s.col %>)"><%= s.col %></button>
      </td>
  <%
          }
      }
      if (!"".equals(currentRow)) {
  %>
    </tr>
  <%
      }
  %>
  </table>

</div>

<!-- seatMap / reservedSeatSet 채우기 -->
<script>
<%
  for (SeatInfo s : seatList) {
%>
  seatMap["<%= s.row %>-<%= s.col %>"] = <%= s.seatId %>;
<%
    if (s.reserved) {
%>
  reservedSeatSet.add(<%= s.seatId %>);
<%
    }
  }
%>
</script>

<div style="text-align:center; margin-top:20px;">
  <button type="button" onclick="submitReservation()">예약하기</button>
</div>
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
