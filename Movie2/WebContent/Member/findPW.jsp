<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reset Password</title>
  <%@ include file="_memberHead.jspf" %>
</head>
<body>

<div class="member-page">
  <div class="member-card">
    <div class="member-card__header">
      <h1 class="member-title">비밀번호 재설정</h1>
      <p class="member-subtitle">아이디/이름 확인 후 새 비밀번호를 설정합니다.</p>
    </div>

    <div class="member-card__body">
      <form class="member-form" method="post" action="findPWProcess.jsp">
        <div class="member-field">
          <label>아이디</label>
          <input class="member-input" type="text" name="user_id" required>
        </div>

        <div class="member-field">
          <label>이름</label>
          <input class="member-input" type="text" name="name" required>
        </div>

        <div class="member-field">
          <label>새 비밀번호</label>
          <input class="member-input" type="password" name="new_password" required>
        </div>

        <button class="member-btn" type="submit">변경</button>

        <div class="member-links">
          <a href="login.jsp">로그인으로</a>
          <span></span>
          <span></span>
        </div>
      </form>
    </div>
  </div>
</div>

</body>
</html>
