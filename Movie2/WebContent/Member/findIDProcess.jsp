<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, thinkonweb.util.ConnectionContext" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Find ID Result</title>
  <%@ include file="_memberHead.jspf" %>
</head>
<body>

<%
  request.setCharacterEncoding("UTF-8");

  String name = request.getParameter("name");
  String foundId = null;

  String sql = "SELECT user_id FROM users WHERE name = ?";

  try (Connection conn = ConnectionContext.getConnection();
       PreparedStatement ps = conn.prepareStatement(sql)) {

    ps.setString(1, name);

    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) {
        foundId = rs.getString("user_id");
      }
    }
  } catch (Exception e) {
    // 에러 상황도 화면에 표시할 수 있게(디버깅용)
    request.setAttribute("dbError", e.getMessage());
  }
%>

<div class="member-page">
  <div class="member-card">
    <div class="member-card__header">
      <h1 class="member-title">아이디 찾기 결과</h1>
      <p class="member-subtitle">입력하신 이름: <b><%= (name == null ? "" : name) %></b></p>
    </div>

    <div class="member-card__body">
      <%
        String dbError = (String)request.getAttribute("dbError");
        if (dbError != null) {
      %>
          <div class="member-alert member-alert--error">
            DB 오류: <%= dbError %>
          </div>
      <%
        } else if (foundId != null) {
      %>
          <div class="member-alert member-alert--success">
            아이디: <b><%= foundId %></b>
          </div>
      <%
        } else {
      %>
          <div class="member-alert member-alert--error">
            해당 이름으로 가입된 아이디가 없습니다.
          </div>
      <%
        }
      %>

      <div style="margin-top:12px;">
        <a href="findID.jsp" class="member-btn member-btn--ghost" style="display:block; text-align:center;">
          다시 찾기
        </a>
      </div>

      <div class="member-links" style="margin-top:14px;">
        <a href="login.jsp">로그인</a>
        <a href="findPW.jsp">비밀번호 재설정</a>
        <a href="signup.jsp">회원가입</a>
      </div>
    </div>
  </div>
</div>

</body>
</html>
